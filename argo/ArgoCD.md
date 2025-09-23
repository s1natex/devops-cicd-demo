## Install Argo CD
```
kubectl create namespace argocd
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait until all core pods are ready
kubectl -n argocd rollout status deploy/argocd-server
kubectl -n argocd rollout status deploy/argocd-repo-server
kubectl -n argocd rollout status deploy/argocd-application-controller
```
#### IF "Error from server (NotFound): deployments.apps "argocd-application-controller" not found"
```
# See what’s running
kubectl -n argocd get pods
kubectl -n argocd get statefulsets

# Wait for the controller
kubectl -n argocd rollout status statefulset/argocd-application-controller

kubectl -n argocd describe statefulset argocd-application-controller
kubectl -n argocd logs statefulset/argocd-application-controller -c argocd-application-controller
```

## Bootstrap apps with the “App of Apps”
```
kubectl apply -f argo/app-of-apps.yaml
```
## Watch sync
```
kubectl -n argocd get pods

# UI (Desktop):
kubectl -n argocd port-forward svc/argocd-server <port>:443
# Docker Desktop: http://localhost:<port>
# login: admin / $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)

# UI (EKS):
kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "LoadBalancer"}}'
kubectl -n argocd get svc argocd-server # Get EXTERNAL-IP / Hostname from AWS
# login: admin / $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
```
