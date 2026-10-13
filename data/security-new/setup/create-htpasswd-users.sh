#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 [-f <credentials-file>] [-n <num-users>]"
  echo "  -f  Path to existing credentials file (format: user:password per line)"
  echo "  -n  Number of users to randomly generate (default: 30, ignored if -f is used)"
  exit 1
}

NUM_USERS=30
INPUT_FILE=""

while getopts "f:n:h" opt; do
  case ${opt} in
    f) INPUT_FILE="${OPTARG}" ;;
    n) NUM_USERS="${OPTARG}" ;;
    h) usage ;;
    *) usage ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTPASSWD_FILE=$(mktemp)
CREDENTIALS_FILE="${SCRIPT_DIR}/user-credentials.txt"
SECRET_NAME="htpasswd-secret"
NAMESPACE="openshift-config"

trap "rm -f ${HTPASSWD_FILE}" EXIT

generate_password() {
  head -c 128 < /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 16
}

FIRST_USER=true
add_user_to_htpasswd() {
  local username="$1"
  local password="$2"
  if [ "${FIRST_USER}" = true ]; then
    htpasswd -cbB "${HTPASSWD_FILE}" "${username}" "${password}"
    FIRST_USER=false
  else
    htpasswd -bB "${HTPASSWD_FILE}" "${username}" "${password}"
  fi
}

if [ -n "${INPUT_FILE}" ]; then
  if [ ! -f "${INPUT_FILE}" ]; then
    echo "Error: credentials file '${INPUT_FILE}' not found"
    exit 1
  fi
  echo "Loading users from ${INPUT_FILE}..."
  while IFS=: read -r USERNAME PASSWORD; do
    [ -z "${USERNAME}" ] && continue
    add_user_to_htpasswd "${USERNAME}" "${PASSWORD}"
  done < "${INPUT_FILE}"
  NUM_USERS=$(wc -l < "${INPUT_FILE}")
else
  echo "Creating htpasswd file with ${NUM_USERS} random users..."
  > "${CREDENTIALS_FILE}"
  for i in $(seq 1 ${NUM_USERS}); do
    PASSWORD="$(generate_password)"
    echo "user${i}:${PASSWORD}" >> "${CREDENTIALS_FILE}"
    add_user_to_htpasswd "user${i}" "${PASSWORD}"
  done
fi

echo "Created $(wc -l < "${HTPASSWD_FILE}") users in htpasswd file"
echo "Credentials stored in ${CREDENTIALS_FILE}"

if oc get secret "${SECRET_NAME}" -n "${NAMESPACE}" &>/dev/null; then
  echo "Updating existing secret ${SECRET_NAME}..."
  oc set data secret/"${SECRET_NAME}" -n "${NAMESPACE}" --from-file=htpasswd="${HTPASSWD_FILE}"
else
  echo "Creating secret ${SECRET_NAME}..."
  oc create secret generic "${SECRET_NAME}" \
    --from-file=htpasswd="${HTPASSWD_FILE}" \
    -n "${NAMESPACE}"
fi

echo "Configuring OAuth to use htpasswd identity provider..."
oc apply -f - <<EOF
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: htpasswd
    mappingMethod: claim
    type: HTPasswd
    htpasswd:
      fileData:
        name: ${SECRET_NAME}
EOF

echo "Waiting for oauth-openshift pods to restart..."
oc rollout status deployment/oauth-openshift -n openshift-authentication --timeout=120s || true

echo ""
echo "Done. ${NUM_USERS} users created."
echo "Credentials: ${CREDENTIALS_FILE}"
