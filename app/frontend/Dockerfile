FROM nginx:alpine

# non-root user
ARG APP_USER=appuser
RUN adduser -D -g '' ${APP_USER}

COPY app/frontend/index.html /usr/share/nginx/html/index.html
COPY app/frontend/nginx.conf /etc/nginx/conf.d/default.conf

RUN chown -R ${APP_USER}:${APP_USER} /usr/share/nginx/html /var/cache/nginx /var/run

USER ${APP_USER}

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1:8080/ >/dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
