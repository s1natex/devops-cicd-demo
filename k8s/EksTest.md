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
### Clean Up
```
kubectl delete namespace app
terraform destroy
```
