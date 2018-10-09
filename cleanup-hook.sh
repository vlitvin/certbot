#!/bin/sh

cat <<EOF | kubectl -n ${KUBE_NAMESPACE} patch configmap ${KUBE_CONFIGMAP} --type json -p "$(cat)"
[{
  "op": "remove",
  "path": "/data/${CERTBOT_TOKEN}"
}]
EOF
