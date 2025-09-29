# How to Run the Project with Kubernetes (Docker Desktop) + Argo CD

### 1. Enable Kubernetes in Docker Desktop
- Open Docker Desktop settings → **Kubernetes**
- Check **Enable Kubernetes** and apply changes
- Wait until the status bar shows Kubernetes is running

### 2. Verify kubectl is available
```
kubectl version --client
kubectl config current-context
```
### 3. Clone the repository
```
git clone https://github.com/s1natex/devops-cicd-demo
cd devops-cicd-demo
```
### 4. Apply Kubernetes app manifests
```
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```
### 5. Wait for app resources to be ready
```
kubectl -n app rollout status deploy/hello
kubectl -n app get pods -o wide
kubectl -n app get svc hello-svc
```
### 6. Access the app
#### Port-forward
```
kubectl -n app port-forward svc/hello-svc 8080:80 &
```
#### App URL:
```
http://localhost:8080
```
#### Health check:
```
curl http://localhost:8080/healthz
```
### 7. Install Argo CD
```
kubectl create namespace argocd
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
### 8. Wait until Argo CD pods are ready
```
kubectl -n argocd rollout status deploy/argocd-server
kubectl -n argocd rollout status deploy/argocd-repo-server
kubectl -n argocd rollout status statefulset/argocd-application-controller
```
### 9. Troubleshooting Argo CD startup
#### If "argocd-application-controller not found"
```
kubectl -n argocd get pods
kubectl -n argocd get statefulsets
kubectl -n argocd rollout status statefulset/argocd-application-controller
kubectl -n argocd describe statefulset argocd-application-controller
kubectl -n argocd logs statefulset/argocd-application-controller -c argocd-application-controller
```
### 10. Port-forward Argo CD UI
```
kubectl -n argocd port-forward svc/argocd-server 8081:443 &
```
#### Argo CD URL:
```
https://localhost:8081
```
### Default login:
```
# username: admin
# password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
```
### 11. Bootstrap apps with App-of-Apps pattern
```
kubectl apply -f argo/app-of-apps.yaml
```
### 12. Update and apply example app
```
kubectl apply -f argo/apps/hello.yaml
```
### 13. Watch Argo CD sync status
```
kubectl -n argocd get applications
kubectl -n argocd get pods -n app
```
### 14. Commit manifest changes to dev branch and open PR to main
```
git checkout dev
git add k8s/deployment.yaml
git commit -m "chore: bump image version for hello app"
git push origin dev

# Then create a Pull Request from dev → main
# The CI workflow will validate and Argo CD will sync after merge
```

### 15. Clean up
```
kubectl -n argocd delete application --all || true
kubectl -n argocd delete -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || true
kubectl delete namespace argocd --wait=false || true
kubectl delete namespace app --wait=false || true
```
