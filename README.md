# Hello World to Production: CI/CD + GitOps on AWS EKS

A "Hello World" app, containerized and deployed to AWS EKS via a GitOps Driven CI/CD pipeline
Pull requests to main must pass tests before merge, and Argo CD continuously syncs main to the cluster for secure, GitOps-driven delivery

## Features
- Python Flask “Hello World” app with `/healthz` endpoint
- Containerized with Docker; runnable locally via Docker Compose
- Automated tests: unit, integration, end-to-end (Docker Compose for e2e)
- Docker Hub publishing: versioned tags (YYYYMMDD-<shortSHA>) + latest
- Kubernetes manifests (flat in k8s/): Namespace, Deployment, Service, HPA, readiness/liveness probes
- Terraform:
  - Bootstrap: S3 bucket + DynamoDB for remote state
  - EKS cluster: VPC, node group, IRSA
  - GitHub OIDC removed (not needed for current workflow)
- GitHub Actions CI/CD:
  - SubBranchCI:
    - Runs tests when app/, tests/, docker-compose.yml change
    - Runs Terraform fmt/validate/plan when terraform/ changes
    - Builds & pushes image only if app/ or docker-compose.yml changed
    - Updates k8s manifest with new tag and commits back when Build & push job succeeds
  - PRCI: on PRs to main → runs unit/integration tests + security scans (Gitleaks, pip-audit, Bandit, Trivy)
- GitOps with Argo CD:
  - App-of-Apps pattern (root + hello application)
  - Automated sync (prune + self-heal) of main branch to EKS or Docker Desktop(local)
  - PostSync smoke-test Job probes `/healthz` via Service to gate rollouts
  - Rollback: `kubectl rollout undo` or `argocd app rollback`
- Ingress:
  - `argocd` Ingress → Argo CD dashboard
  - `hello` Ingress → app root `/` and `/healthz`
  - `kubectl get ingress` commands print external addresses for both
- Monitoring:
  - AWS CloudWatch + Container Insights (logs + metrics)

# CICD Diagram
![CICD](./media/CICD.drawio.png)

## Instructions and Screenshots:
#### - [Screenshot Validations](./docs/ScreenshotValidation.md)
#### - [Running locally with Docker Compose](./docs/dockercompose.md)
#### - [Running locally with Kubernetes on Docker Desktop](./docs/localcluster.md)
#### - [Running on AWS EKS cluster with Terraform](./docs/ekscluster.md)
