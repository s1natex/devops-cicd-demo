## [k8s LOCAL testing via Docker Desktop](./k8s/LocalTest.md)
## [K8s EKS LOCAL testing via AWS](./k8s/EksTest.md)
## Local testing via docker compose
```
docker compose up --build

# URL: http://localhost:8000
# Health: http://localhost:8000/healthz

# Clean Up
docker compose down
```
## Terraform Bootstrap Local
- Run Bootstrap before using AWS
```
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply

# Clean Up
terraform destroy
# Check AWS user
```
## EKS Clean Up
```
cd terraform/eks
kubectl delete namespace app
terraform destroy

cd terraform/bootstrap
terraform destroy
```
