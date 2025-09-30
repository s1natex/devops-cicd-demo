# Hello World to Production: CI/CD + GitOps on AWS EKS

![MainCI](https://github.com/s1natex/my-devops-cicd-demo/actions/workflows/MainCI.yml/badge.svg?branch=main)

A "Hello World" app, containerized and deployed to AWS EKS via a CI/CD pipeline.
Pull requests to main must pass tests before merge, and Argo CD continuously syncs main to the cluster for secure, GitOps-driven delivery

## Features
- Python Flask “Hello World” app (+ `/healthz`)
- Containerized with Docker; local run via Docker Compose
- Automated tests: unit, integration, e2e (with Docker Compose)
- Docker Hub image publishing with versioned (`YYYYMMDD-<shortSHA>`) and `latest` tags
- Kubernetes manifests: Namespace, Deployment, Service, HPA, Probes
- EKS cluster provisioned via Terraform (VPC, Node group, IRSA, remote state in S3+DynamoDB, GitHub OIDC auth)
- GitHub Actions CI:
  - Sub-branch CI builds, pushes image, updates manifests, opens PR to `main`
  - PR CI runs tests on pull requests to `main`
  - Main CI runs full test suite after merges to `main`
- Argo CD:
  - Continuously syncs protected `main` branch to EKS
  - GitOps-driven, secure delivery
- Manual CI/CD workflow (`workflow_dispatch` + AWS OIDC) for on-demand build/deploy
- Monitoring: CloudWatch + Container Insights (logs + metrics)

## Instructions and Screenshots:
#### - [Screenshot Validations](./docs/ScreenshotValidation.md)
#### - [Running locally with Docker Compose](./docs/dockercompose.md)
#### - [Running locally with Kubernetes on Docker Desktop](./docs/localcluster.md)
#### - [Running on AWS EKS cluster with Terraform](./docs/ekscluster.md)
