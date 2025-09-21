### Initialize backend and eks
```
cd terraform/eks
terraform init -backend-config=../../envs/dev/backend.hcl
```
### Deploy eks cluster
```
terraform plan
terraform apply
```
### Configure kubectl
```
aws eks update-kubeconfig --name my-devops-cicd-demo-eks --region eu-north-1
kubectl config current-context

# Verify
kubectl get --raw='/readyz?verbose'
kubectl get nodes
kubectl get svc -A
```
### Deploy the app to EKS and scale to 9 pods (≈3 per node)
```
kubectl apply -f ../../k8s/namespace.yaml
kubectl apply -f ../../k8s/deployment.yaml
kubectl apply -f ../../k8s/service.yaml
kubectl -n app scale deploy/hello --replicas=9
kubectl -n app rollout status deploy/hello
```
### Get the AWS Load Balancer DNS and test:
```
EXTERNAL_DNS=$(kubectl -n app get svc hello-svc -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo $EXTERNAL_DNS
curl -s "http://$EXTERNAL_DNS/"
curl -s -o /dev/null -w "%{http_code}\n" "http://$EXTERNAL_DNS/healthz"
```
### Verify CloudWatch & Container Insights
```
# generate some traffic
for i in {1..50}; do curl -s "http://$EXTERNAL_DNS/healthz" >/dev/null; done

# confirm log groups exist
aws logs describe-log-groups --log-group-name-prefix "/aws/containerinsights/my-devops-cicd-demo-eks" --region eu-north-1

# list metrics namespace
aws cloudwatch list-metrics --namespace "ContainerInsights" --region eu-north-1 --max-items 5
```
### Clean Up
```
kubectl delete namespace app
terraform destroy
```

- If AWS shows no addons:
```
# 1) Re-init
terraform init -reconfigure -backend-config=../../envs/dev/backend.hcl

# 2) Remove any stale addon resources from state (if present)
terraform state list | grep aws_eks_addon || true
terraform state rm 'module.eks.aws_eks_addon.this["amazon-cloudwatch-observability"]' || true
terraform state rm 'aws_eks_addon.cloudwatch_observability' || true

# 3) Apply – Terraform should now CREATE the addon
terraform apply -auto-approve
```
