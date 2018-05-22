#!/bin/sh

certbot certonly \
        --standalone
        --non-interactive
        --domains ${DOMAINS}
        --certname ${CERTNAME}
        -m ${EMAIL}
 
echo "
kind: Secret
apiVersion: v1
type: Opaque
metadata:
  name: $CERTNAME
  namespace: ${KUBE_NAMESPACE}
data:
  tls.crt:`cat /etc/letsencrypt/live/k8s-certbot/fullchain.pem | base64 -w 0`
  tls.key:`cat /etc/letsencrypt/live/k8s-certbot/privkey.pem | base64 -w 0`
" | kubectl apply --force -f - 
