#!/bin/sh

cat <<EOF | kubectl -n ${KUBE_NAMESPACE} patch configmap ${KUBE_CONFIGMAP} --type json -p "$(cat)"
[{
  "op": "add",
  "path": "/data/${CERTBOT_TOKEN}",
  "value": "${CERTBOT_VALIDATION}"
}]
EOF

URL="https://${CERTBOT_DOMAIN}/.well-known/acme-challenge/${CERTBOT_TOKEN}

until $(curl --output /dev/null --silent --head --fail ${URL}); do
    printf '.'
    sleep 5
done
