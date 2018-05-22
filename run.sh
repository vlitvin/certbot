#!/bin/sh

echo "Starting webserver"
cd /le
python -m SimpleHTTPServer 80

echo "Waiting for k8s do its service and ingress job"
sleep 30

echo "Obtaining cert"
certbot certonly \
        --webroot \
        -w /le
        --non-interactive \
        --agree-tos \
        --domains ${DOMAINS} \
        --cert-name ${CERTNAME} \
        -m ${EMAIL}

echo "Deploying secret"
echo "
kind: Secret
apiVersion: v1
type: Opaque
metadata:
  name: $CERTNAME
  namespace: ${KUBE_NAMESPACE}
data:
  tls.crt:`cat /etc/letsencrypt/live/${CERTNAME}/fullchain.pem | base64 -w 0`
  tls.key:`cat /etc/letsencrypt/live/${CERTNAME}/privkey.pem | base64 -w 0`
" | kubectl apply --force -f - 
