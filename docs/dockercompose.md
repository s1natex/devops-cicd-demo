# How to Run the Project with Docker Compose

### 1. Make sure Docker and Docker Compose are installed:
```
docker --version
docker compose version
```
### 2. Clone the repository:
```
git clone https://github.com/s1natex/devops-cicd-demo
cd <repo-path>
```
### 3. Build and start the services:
```
docker compose up -d --build
```
### 4. Verify the containers are running:
```
docker compose ps
```
### 5. Access the app:
```
http://localhost:8000
```
### 6. Check health endpoint:
```
curl http://localhost:8000/healthz
```
### 7. To view logs:
```
docker compose logs -f
```

### 8. To stop and remove containers, networks, volumes:
```
docker compose down -v
```
