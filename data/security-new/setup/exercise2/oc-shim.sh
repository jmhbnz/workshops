#!/usr/bin/env bash
set -eo pipefail

REAL_OC="/usr/bin/oc.real"
MOCK_LOG="/opt/workshop/audit.log"
MOCK_TAR="/opt/workshop/must-gather.tar.gz"

# Check if the command is 'oc adm node-logs'
if [[ "$1" == "adm" && "$2" == "node-logs" ]]; then
    is_path_listing=false
    is_audit_fetch=false

    for arg in "$@"; do
        # 1. Matches: --path=kube-apiserver/ or --path=kube-apiserver
        if [[ "$arg" == "--path=kube-apiserver/" || "$arg" == "--path=kube-apiserver" ]]; then
            is_path_listing=true
            break
        # 2. Matches: --path=kube-apiserver/audit*
        elif [[ "$arg" =~ ^--path=kube-apiserver/audit.* ]]; then
            is_audit_fetch=true
            break
        fi
    done

    # Handle directory listing
    if [[ "$is_path_listing" == true ]]; then
        echo "audit.log"
        echo "audit-2026-11-05T00-00-00.000.log"
        exit 0
    fi

    # Handle log file read
    if [[ "$is_audit_fetch" == true ]]; then
        if [[ -f "$MOCK_LOG" ]]; then
            # Resolve current active project to dynamically match the jq filter
            CURRENT_NS=$("$REAL_OC" project --short 2>/dev/null || echo "default")
            sed "s/payment-gateway-1/${CURRENT_NS}/g" "$MOCK_LOG"
            exit 0
        fi
    fi
fi

# Shim oc adm must-gather so we don't blow up apiserver
if [[ "$1" == "adm" && "$2" == "must-gather" ]]; then
    # Extract destination directory from arguments
    dest_dir=""
    skip_next=false
    for arg in "$@"; do
        if [[ "$skip_next" == true ]]; then
            dest_dir="$arg"
            skip_next=false
            continue
        fi
        if [[ "$arg" == "--dest-dir" ]]; then
            skip_next=true
        elif [[ "$arg" =~ ^--dest-dir=(.*)$ ]]; then
            dest_dir="${BASH_REMATCH[1]}"
        fi
    done

    # Default to standard must-gather directory if omitted
    if [[ -z "$dest_dir" ]]; then
        dest_dir="./must-gather.local.$(date +%s)"
    fi

    mkdir -p "$dest_dir"

    CURRENT_NS=$("$REAL_OC" project --short 2>/dev/null || cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null || echo "default")
    POD_ID="must-gather-$RANDOM"
    ts() { date -u +"%Y-%m-%dT%H:%M:%S.%9NZ"; }

    # Burst 1: Initialization & cluster metadata
    echo "[must-gather      ] OUT $(ts) Using must-gather plug-in image: quay.io/openshift/origin-must-gather:latest"
    cat << 'EOF'
When opening a support case, bugzilla, or issue please include the following summary data along with any other requested information:
ClusterID: e3e49f9b-5e9f-46f1-ae96-b0f1c36e0a04
ClientVersion: 4.22.0-202609170632.p2.gd0f23b1.assembly.stream-d0f23b1
ClusterVersion: Stable at "4.22.18"
ClusterOperators:
        clusteroperator/cloud-credential is not upgradeable because Parent credentials secret must be restored prior to upgrade: kube-system/aws-creds
        clusteroperator/kube-apiserver is not upgradeable because UnsupportedConfigOverridesUpgradeable: setting: [apiServerArguments.audit-log-maxbackup.0 apiServerArguments.audit-log-maxsize.0]

EOF
    sleep 1

    # Burst 2: Pod creation & worker checks
    echo "[must-gather      ] OUT $(ts) pod for plug-in image quay.io/openshift/origin-must-gather:latest created"
    sleep 1
    echo "[$POD_ID] POD $(ts) [disk usage checker] Started"
    echo "[$POD_ID] POD $(ts) [disk usage checker] Volume usage percentage: current = 39 ; allowed = 70"
    echo "[$POD_ID] POD $(ts) WARNING: Collecting one or more audit logs on ALL masters in your cluster. This could take a large amount of time."
    sleep 1

    # Burst 3: Node downloads begin
    cat << EOF
[$POD_ID] POD $(ts) INFO: Started  downloading openshift-apiserver/audit.log from ip-10-0-11-235.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Started  downloading openshift-apiserver/audit.log from ip-10-0-50-248.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Started  downloading openshift-apiserver/audit.log from ip-10-0-82-189.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Started  downloading kube-apiserver/audit-2026-11-03T01-38-21.772.log from ip-10-0-11-235.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Started  downloading kube-apiserver/audit-2026-11-05T02-03-21.875.log from ip-10-0-11-235.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Started  downloading kube-apiserver/audit.log from ip-10-0-11-235.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Started  downloading kube-apiserver/audit.log from ip-10-0-50-248.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Started  downloading kube-apiserver/audit.log from ip-10-0-82-189.us-east-2.compute.internal
EOF
    sleep 2

    # Burst 4: Intermediate completion
    cat << EOF
[$POD_ID] POD $(ts) INFO: Finished downloading openshift-apiserver/audit.log from ip-10-0-82-189.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Finished downloading openshift-apiserver/audit.log from ip-10-0-11-235.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Finished downloading openshift-apiserver/audit.log from ip-10-0-50-248.us-east-2.compute.internal
[$POD_ID] POD $(ts) [disk usage checker] Volume usage percentage: current = 40 ; allowed = 70
[$POD_ID] POD $(ts) INFO: Finished downloading kube-apiserver/audit.log from ip-10-0-50-248.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Finished downloading kube-apiserver/audit.log from ip-10-0-11-235.us-east-2.compute.internal
[$POD_ID] POD $(ts) INFO: Finished downloading kube-apiserver/audit.log from ip-10-0-82-189.us-east-2.compute.internal
EOF
    sleep 2

    # Burst 5: RBAC warnings & completion
    cat << EOF
[$POD_ID] POD $(ts) Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:${CURRENT_NS}:default" cannot list resource "pods" in API group "" in the namespace "openshift-monitoring"
[$POD_ID] POD $(ts) Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:${CURRENT_NS}:default" cannot list resource "pods" in API group "" in the namespace "openshift-monitoring"
[$POD_ID] POD $(ts) INFO: Audit logs collected.
[$POD_ID] POD $(ts) Caches written to disk
[$POD_ID] OUT $(ts) waiting for gather to complete
[$POD_ID] OUT $(ts) downloading gather output
WARNING: rsync command not found in path. Please use your package manager to install it.
EOF
    sleep 1

    # Unpack the mock payload directly into the destination directory
    if [[ -f "$MOCK_TAR" ]]; then
        tar -xzf "$MOCK_TAR" -C "$dest_dir"
    fi

    # Burst 6: Extracted manifest & trailing cluster summary
    cat << EOF
[$POD_ID] OUT $(ts) ./audit_logs/openshift-apiserver/ip-10-0-11-235.us-east-2.compute.internal-audit.log.gz
[$POD_ID] OUT $(ts) ./audit_logs/openshift-apiserver/ip-10-0-50-248.us-east-2.compute.internal-audit.log.gz
[$POD_ID] OUT $(ts) ./audit_logs/openshift-apiserver/ip-10-0-82-189.us-east-2.compute.internal-audit.log.gz
[$POD_ID] OUT $(ts) ./audit_logs/kube-apiserver/ip-10-0-11-235.us-east-2.compute.internal-audit.log.gz
[$POD_ID] OUT $(ts) ./audit_logs/kube-apiserver/ip-10-0-50-248.us-east-2.compute.internal-audit.log.gz
[$POD_ID] OUT $(ts) ./audit_logs/kube-apiserver/ip-10-0-82-189.us-east-2.compute.internal-audit.log.gz
Ignoring the following flags because they only apply to rsync: -z


Reprinting Cluster State:
When opening a support case, bugzilla, or issue please include the following summary data along with any other requested information:
ClusterID: e3e49f9b-5e9f-46f1-ae96-b0f1c36e0a04
ClientVersion: 4.22.0-202609170632.p2.gd0f23b1.assembly.stream-d0f23b1
ClusterVersion: Stable at "4.22.18"
ClusterOperators:
        clusteroperator/cloud-credential is not upgradeable because Parent credentials secret must be restored prior to upgrade: kube-system/aws-creds
        clusteroperator/kube-apiserver is not upgradeable because UnsupportedConfigOverridesUpgradeable: setting: [apiServerArguments.audit-log-maxbackup.0 apiServerArguments.audit-log-maxsize.0]
EOF
    exit 0
fi


# Fallback to the authentic oc binary for all other commands
exec "$REAL_OC" "$@"
