# How to Run the Project on EKS (AWS) with Terraform + Argo CD

### 1. Prerequisites
- AWS CLI configured with correct credentials
- Terraform installed
- kubectl installed
- Docker installed (for building images)

### 2. Clone the repository
```
git clone https://github.com/s1natex/devops-cicd-demo
cd devops-cicd-demo
```
### 3. Bootstrap Terraform backend (remote state + OIDC role)
```
cd terraform/bootstrap
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply
```
### 4. Deploy EKS cluster with Terraform
```
cd ../eks
terraform init -backend-config=../../envs/dev/backend.hcl
terraform plan
terraform apply
```
### 5. Configure kubectl to use the EKS cluster
```
aws eks update-kubeconfig --name my-devops-cicd-demo-eks --region eu-north-1
kubectl config current-context
```
### 6. Verify cluster
```
kubectl get --raw='/readyz?verbose'
kubectl get nodes
kubectl get svc -A
```
### 7. Deploy the app to EKS
```
kubectl apply -f ../../k8s/namespace.yaml
kubectl apply -f ../../k8s/deployment.yaml
kubectl apply -f ../../k8s/service.yaml
kubectl apply -f ../../k8s/hpa.yaml
```
### 8. Scale the app
```
kubectl -n app scale deploy/hello --replicas=9
kubectl -n app rollout status deploy/hello
```
### 9. Get the AWS Load Balancer DNS and test
```
EXTERNAL_DNS=$(kubectl -n app get svc hello-svc -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo $EXTERNAL_DNS
```
# Test endpoints
```
curl -s "http://$EXTERNAL_DNS/"
curl -s -o /dev/null -w "%{http_code}\n" "http://$EXTERNAL_DNS/healthz"
```
### 10. Verify CloudWatch logs and Container Insights
```
# Generate traffic
for i in {1..50}; do curl -s "http://$EXTERNAL_DNS/healthz" >/dev/null; done

# Confirm log groups exist
aws logs describe-log-groups --log-group-name-prefix "/aws/containerinsights/my-devops-cicd-demo-eks" --region eu-north-1

# List metrics
aws cloudwatch list-metrics --namespace "ContainerInsights" --region eu-north-1 --max-items 5
```
### 11. Install Argo CD on EKS
```
kubectl create namespace argocd
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
### 12. Wait for Argo CD to be ready
```
kubectl -n argocd rollout status deploy/argocd-server
kubectl -n argocd rollout status deploy/argocd-repo-server
kubectl -n argocd rollout status statefulset/argocd-application-controller
```
### 13. Troubleshoot if needed
```
kubectl -n argocd get pods
kubectl -n argocd get statefulsets
kubectl -n argocd rollout status statefulset/argocd-application-controller
kubectl -n argocd describe statefulset argocd-application-controller
kubectl -n argocd logs statefulset/argocd-application-controller -c argocd-application-controller
```
### 14. Expose Argo CD server on EKS
```
kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "LoadBalancer"}}'
kubectl -n argocd get svc argocd-server

# Get EXTERNAL-IP / Hostname from AWS
# Argo CD URL: https://<EXTERNAL-IP>
# Default login:
# username: admin
# password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
```
### 15. Bootstrap apps with App-of-Apps pattern
```
kubectl apply -f argo/app-of-apps.yaml
```
### 16. Update and apply example app
```
kubectl apply -f argo/apps/hello.yaml
```
### 17. Watch Argo CD sync status
```
kubectl -n argocd get applications
kubectl -n argocd get pods -n app
```
### 18. Commit manifest changes to dev branch and open PR to main
```
git checkout dev
git add k8s/deployment.yaml
git commit -m "chore: bump image version for hello app"
git push origin dev

# Then create a Pull Request from dev → main
# The CI workflow will validate and Argo CD will sync after merge
```

### For Rollback if smoke-job fails after ArgoCD deployment
```
kubectl -n app rollout undo deployment/hello
```

### 19. Clean up app and Argo CD
```
kubectl delete namespace app --wait=false || true
kubectl -n argocd delete application --all || true
kubectl -n argocd delete -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || true
kubectl delete namespace argocd --wait=false || true
```
### 20. Destroy EKS cluster with Terraform
```
cd terraform/eks
terraform destroy
```
### 21. Destroy bootstrap resources
```
cd ../bootstrap
terraform destroy
```

For addresses
# ArgoCD dashboard
kubectl -n argocd get ingress argocd \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}{.status.loadBalancer.ingress[0].ip}{"\n"}'

# App root
kubectl -n app get ingress hello \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}{.status.loadBalancer.ingress[0].ip}{"\n"}'

# Healthz (same ingress, just append /healthz)
kubectl -n app get ingress hello \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}{.status.loadBalancer.ingress[0].ip}{"\n"}'
