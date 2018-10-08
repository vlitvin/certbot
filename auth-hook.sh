#!/bin/sh

cat <<EOF | kubectl -n ${KUBE_NAMESPACE} patch configmap ${KUBE_CONFIGMAP} --type json -p "$(cat)"
[{
  "op": "add",
  "path": "/data/${CERTBOT_TOKEN}",
  "value": "${CERTBOT_VALIDATION}"
}]
EOF
