#!/bin/bash
set -euo pipefail

NUM_USERS=30
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTPASSWD_FILE=$(mktemp)
CREDENTIALS_FILE="${SCRIPT_DIR}/user-credentials.txt"
SECRET_NAME="htpasswd-secret"
NAMESPACE="openshift-config"

trap "rm -f ${HTPASSWD_FILE}" EXIT

> "${CREDENTIALS_FILE}"

generate_password() {
  head -c 128 < /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 16
}

echo "Creating htpasswd file with ${NUM_USERS} users..."
for i in $(seq 1 ${NUM_USERS}); do
  USERNAME="user${i}"
  PASSWORD=$(generate_password)
  echo "${USERNAME}:${PASSWORD}" >> "${CREDENTIALS_FILE}"
  if [ "$i" -eq 1 ]; then
    htpasswd -cbB "${HTPASSWD_FILE}" "${USERNAME}" "${PASSWORD}"
  else
    htpasswd -bB "${HTPASSWD_FILE}" "${USERNAME}" "${PASSWORD}"
  fi
done

echo "Created $(wc -l < "${HTPASSWD_FILE}") users in htpasswd file"
echo "Credentials saved to ${CREDENTIALS_FILE}"

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
echo "Done. Users user1 through user${NUM_USERS} created."
echo "Credentials: ${CREDENTIALS_FILE}"
