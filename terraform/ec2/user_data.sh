#!/usr/bin/env bash
set -euxo pipefail

# ---- Configuration ----
IMAGE_REPO="s1natex/my-devops-cicd-demo"
API_TAG="api-latest"
WEB_TAG="web-latest"

# -------- EBS mount at /data --------
DEV_GUESS="/dev/xvdf"
NVME_DEV=$(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print "/dev/"$1}' | grep -v nvme0n1 | head -n1 || true)
DEV="${NVME_DEV:-$DEV_GUESS}"

mkdir -p /data
if ! blkid "$DEV" >/dev/null 2>&1; then
  mkfs.xfs -f "$DEV"
fi
grep -q "$DEV /data" /etc/fstab || echo "$DEV /data xfs defaults,nofail 0 2" >> /etc/fstab
mount -a

mkdir -p /data/tasks
chown -R ec2-user:ec2-user /data

# -------- Docker install --------
dnf update -y
dnf install -y docker docker-compose-plugin
systemctl enable --now docker
usermod -aG docker ec2-user

# -------- Compose up (web + api), bound to /data/tasks --------
install -d -m 0755 /opt/compose
cat >/opt/compose/docker-compose.yml <<COMPOSE
services:
  api:
    image: ${IMAGE_REPO}:${API_TAG}
    container_name: api
    restart: unless-stopped
    ports:
      - "8000:8000"
    volumes:
      - /data/tasks:/data/tasks

  web:
    image: ${IMAGE_REPO}:${WEB_TAG}
    container_name: web
    restart: unless-stopped
    ports:
      - "8080:8080"
    depends_on:
      - api
COMPOSE

docker compose -f /opt/compose/docker-compose.yml up -d
