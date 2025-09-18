# DevOps CI/CD Demo
A demo deployment of a dockerized app to aws
Features a full cicd from commit to deployment using OIDC to AWS
---

## Prerequisites
- **Accounts:** Docker Hub (`s1natex/my-devops-cicd-demo`), GitHub (`s1natex/my-devops-cicd-demo`), AWS
- **Tools:** Git, Docker, Python 3.12, Terraform ≥ 1.5, AWS CLI v2
- **AWS profile**:
```
  export AWS_PROFILE=devops-demo
  aws configure --profile devops-demo
```
## How to Run local:
- **Pre commit**:
```
pip install pre-commit detect-secrets
pre-commit install
pre-commit run --all-files
```
- **Run Locally via Docker Desktop**:
```
docker compose up -d --build
# API: http://localhost:8000/tasks
# Web: http://localhost:8080
```
## How to Run AWS:
- Create terraform.tfvars
- Deploy terraform bootstrap:
```
cd terraform/bootstrap
terraform init
terraform apply -auto-approve
```
- Deploy terraform ec2:
```
cd terraform/ec2
terraform init -backend-config=backend.hcl
terraform apply -auto-approve
```
## Test connection:
```
curl http://<public-ip>:8000/tasks
curl -I http://<public-ip>:8080/
```
