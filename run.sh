#!/bin/sh

# Environmentals
# KUBE_CONFIGMAP
# KUBE_NAMESPACE
# DOMAINS
# CERTNAME
# EMAIL
# OPS

echo "Obtaining cert"
certbot certonly \
        --manual \
        --non-interactive \
        --agree-tos \
        --manual-public-ip-logging-ok \
        --domains ${DOMAINS} \
        --cert-name ${CERTNAME} \
        -m ${EMAIL} \
        --manual-auth-hook /auth-hook.sh \
        --manual-cleanup-hook /cleanup-hook.sh
        ${OPS}

echo "Deploying secret"
cat <<< EOF | kubectl apply --force -f -
kind: Secret
apiVersion: v1
type: Opaque
metadata:
  name: $CERTNAME
  namespace: ${KUBE_NAMESPACE}
data:
  tls.crt: `cat /etc/letsencrypt/live/${CERTNAME}/fullchain.pem | base64 -w 0`
  tls.key: `cat /etc/letsencrypt/live/${CERTNAME}/privkey.pem | base64 -w 0`
EOF
