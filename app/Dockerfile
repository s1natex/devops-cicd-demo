FROM python:3.12-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
RUN adduser --disabled-password --gecos '' appuser
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD python - <<'PY'\nimport sys,urllib.request\nurllib.request.urlopen('http://127.0.0.1:8000/healthz',timeout=2).read()\nPY
CMD ["gunicorn","-b","0.0.0.0:8000","app:app"]
