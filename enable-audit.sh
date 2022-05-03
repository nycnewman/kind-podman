#!/bin/bash

mkdir -p /tmp/api/

cat <<EOF > /tmp/api/audit-policy.yaml
# Log all requests at the Metadata level.
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
EOF
