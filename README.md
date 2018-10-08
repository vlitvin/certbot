# certbot
Easy-peasy certbot for your ingress

# howto

Create web listener and redirect letsencrypt auth traffic to it. See ./examples/

Modify ingress and direct traffic to this container
```
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: certbot
  namespace: <yourNamespace>
spec:
  rules:
  - host: <yourHost>
    http:
      paths:
      - paths: /.well-known/acme-challenge
        backend:
          serviceName: certbot
          servicePort: 80
      - <yourRules>
```

Create service to receive traffic from ingress
```
kind: Service
apiVersion: v1
metadata:
  name: certbot
  namespace: <yourNamespace>
spec:
  selector:
    run: certbot
  ports:
  - name: certbot
    port: 80
    targetPort: 80
```

Run this image
```
kubectl run -n <yourNamespace> certbot --image=valitvin/certbot -l 'run=certbot' --env="DOMAINS=<domain_list>" --env="EMAIL=<importantEmail>" --env="KUBE_NAMESPACE=<yourNamespace>" --env="CERTNAME=<secret_with_cert_name>"
```

# RBAC notes
If you are using RBAC (you are using it). Service account witch runs certbot image should be able to create secrets in ${KUBE_NAMESPACE}

# Known issues
- Service and Ingress does not react quickly enough to forward traffic to pod.
