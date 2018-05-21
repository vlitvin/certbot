# certbot
Easy-peasy certbot for your ingress

# howto

Modify ingress and direct traffic to this container
```
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: <yourIngress>
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
kubectl run -n <yourNamespace> certbot --image=valitvin/certbot -l 'run=certbot'
```
