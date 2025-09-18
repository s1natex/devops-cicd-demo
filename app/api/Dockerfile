FROM python:3.12-slim AS base

# Prevent .pyc, ensure unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System deps andcurl for healthchecks
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

ARG APP_USER=appuser
RUN useradd --create-home --shell /usr/sbin/nologin ${APP_USER}
WORKDIR /app

COPY app/api/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY app /app/app

# Set ownership and drop privileges
RUN chown -R ${APP_USER}:${APP_USER} /app
USER ${APP_USER}

EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -fsS http://127.0.0.1:8000/tasks || exit 1

CMD ["uvicorn", "app.api.api:app", "--host", "0.0.0.0", "--port", "8000"]
