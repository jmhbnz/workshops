#!/usr/bin/env bash
set -eo pipefail

REAL_OC="/usr/bin/oc.real"
MOCK_LOG="/opt/workshop/audit.log"

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
            sed "s/__NAMESPACE__/${CURRENT_NS}/g" "$MOCK_LOG"
            exit 0
        fi
    fi
fi

# Fallback to the authentic oc binary for all other commands
exec "$REAL_OC" "$@"
