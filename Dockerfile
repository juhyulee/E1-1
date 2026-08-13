FROM nginx:alpine

LABEL org.opencontainers.image.title="E1 Docker Workstation Web"
LABEL org.opencontainers.image.description="Static NGINX service for the Docker workstation mission"

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY app/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=3s --start-period=3s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/health || exit 1
