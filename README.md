# Hello World to Production: CI/CD + GitOps on AWS EKS
[![CI](https://github.com/s1natex/devops-cicd-demo/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/s1natex/devops-cicd-demo/actions/workflows/ci.yml)
```
A "Hello World" app, containerized and deployed to an AWS EKS cluster through an automated CI/CD pipeline
The pipeline enforces **main branch protection** with a **CI gate on pull requests**, ensuring all tests pass before merge
Argo CD continuously syncs the protected `main` branch to the cluster, providing secure and reliable GitOps-driven delivery
```
## Features
- Python Flask “Hello World” app (+ /healthz)
- Dockerized app + Docker Compose for local run
- Tests: unit + integration (+ e2e via Docker Compose)
- Image publishing to Docker Hub with `YYYYMMDD-<shortSHA>` and `latest`
- Kubernetes manifests (Namespace, Deployment, Service, HPA, readiness/liveness)
- Local Kubernetes run with Docker Desktop
- Scalable deploy: replicas=9 (EKS 3 nodes × ~3 pods)
- EKS cluster via Terraform (VPC, nodegroup, IRSA enabled)
- Remote Terraform state (S3 + DynamoDB lock) and GitHub OIDC role
- CI (GitHub Actions):
  - Runs on **pull requests to main** (from any branch)
  - Executes unit, integration, and e2e tests
  - Branch protection with required checks
- CD (Argo CD):
  - Syncs main branch into the cluster
  - Supports App-of-Apps bootstrap pattern
- Manual CD (alternative via workflow_dispatch with AWS OIDC):
  - Build → Test → Push → Deploy to EKS
  - Rollout status check included
- Monitoring: CloudWatch + Container Insights addon (logs + metrics)

## Instructions and Screenshots:
#### [Screenshot Validations](./docs/ScreenshotValidation.md)
#### [Running locally with Docker Compose](./docs/dockercompose.md)
#### [Running locally with Kubernetes on Docker Desktop](./docs/localcluster.md)
#### [Running on AWS EKS cluster with Terraform](./docs/ekscluster.md)
