### use docker-desktop context
```
kubectl config use-context docker-desktop
```
### apply manifests
```
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```
### wait for ready
```
kubectl -n app rollout status deploy/hello
kubectl -n app get pods -o wide
kubectl -n app get svc hello-svc
```
### get URL
```
LB_PORT=$(kubectl -n app get svc hello-svc -o jsonpath='{.spec.ports[0].nodePort}')
# If NodePort fallback is needed:
# kubectl -n app patch svc hello-svc -p '{"spec":{"type":"NodePort"}}'
```
### try service ClusterIP via port-forward (works everywhere)
```
kubectl -n app port-forward svc/hello-svc 8080:80 &
curl -s http://127.0.0.1:8080/        # expect "Hello, World!"
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/healthz  # expect 200
```
### Local testing extra
```
# URL: http://localhost:8080
# Health: http://localhost:8080/healthz
# If Docker Desktop assigns a LoadBalancer/NodePort:
kubectl -n app get svc hello-svc
# URL: http://localhost:<nodePort>
```
### Clean Up
```
kubectl delete namespace app
```
