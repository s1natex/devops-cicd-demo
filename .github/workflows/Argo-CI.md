# CI Workflow for `dev` Branch

## Trigger
- Runs automatically on **push to `dev`** branch
- Can also be started manually with **workflow_dispatch**

---

## Jobs Overview

### 1. Unit & Integration Tests
- Checkout repository
- Setup Python 3.12 with pip cache
- Install dependencies
- Run **unit** and **integration** tests

### 2. End-to-End Tests (E2E)
- Runs after unit & integration tests
- Spin up services with **Docker Compose**
- Wait until app health endpoint responds
- Run **E2E test suite** against running services
- Always collect container logs
- Tear down Docker Compose stack

### 3. Build & Push Image
- Runs only if all tests pass
- Compute unique Docker tag (`YYYYMMDD-<shortSHA>`)
- Build Docker image of the app
- Push image to Docker Hub with computed tag

### 4. Open Pull Request to `main`
- Create or update PR from **`dev` → `main`**
- PR title includes Docker image tag
- PR body lists pushed image reference
- Requires **manual reviewer approval** before merge

---

## Flow Summary
1. Developer pushes to **`dev`**
2. CI runs **unit, integration, and E2E tests**
3. If successful, CI **builds & pushes image** to Docker Hub
4. CI **opens PR** to `main` with the new tag
5. Reviewer approves & merges PR
6. **ArgoCD syncs** `main` branch to target cluster (Desktop or EKS)
