# Hello World to Production: CI/CD + GitOps on AWS EKS

A "Hello World" app, containerized and deployed to an AWS EKS cluster through an automated CI/CD pipeline
The pipeline enforces **main branch protection** with a **CI gate on pull requests**, ensuring all tests pass before merge
Argo CD continuously syncs the protected `main` branch to the cluster, providing secure and reliable GitOps-driven delivery

## Features
- Python Flask “Hello World” app (+ /healthz)
- Dockerized app + Docker Compose for local run
- Tests: unit + integration + e2e (via Docker Compose)
- Image publishing to Docker Hub with tags:
  - `YYYYMMDD-<shortSHA>`
  - latest
- Kubernetes manifests:
  - Namespace
  - Deployment
  - Service
  - HPA
  - Readiness + Liveness probes
- Local Kubernetes run with Docker Desktop
- Scalable deploy: replicas=9 (EKS: 3 nodes × ~3 pods)
- EKS cluster provisioned via Terraform:
  - VPC
  - Node group
  - IRSA enabled
- Remote Terraform state:
  - S3 backend
  - DynamoDB lock
  - GitHub OIDC role for auth
- CI (GitHub Actions):
  - Runs on pull requests to main (from any branch)
  - Executes unit, integration, and e2e tests
  - Branch protection with required checks
- Argo-CI (GitHub Actions):
  - Runs build + push of Docker image
  - Bumps image tag in Kubernetes manifests
  - Commits changes back to PR branch
- CD (ArgoCD):
  - Syncs main branch into the cluster
  - Supports App-of-Apps bootstrap pattern
- Manual CI/CD (workflow_dispatch with AWS OIDC):
  - Build → Test → Push image to Docker Hub
  - Apply Kubernetes manifests (Namespace, Deployment, Service)
  - Update Deployment image with new tag
  - Wait for rollout to complete
  - Output Service LoadBalancer hostname
- Monitoring:
  - CloudWatch
  - Container Insights addon (logs + metrics)

## Instructions and Screenshots:
#### - [Screenshot Validations](./docs/ScreenshotValidation.md)
#### - [Running locally with Docker Compose](./docs/dockercompose.md)
#### - [Running locally with Kubernetes on Docker Desktop](./docs/localcluster.md)
#### - [Running on AWS EKS cluster with Terraform](./docs/ekscluster.md)
