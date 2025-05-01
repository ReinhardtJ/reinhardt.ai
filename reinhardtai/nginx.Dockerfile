FROM nginx:alpine
COPY .htpasswd /etc/nginx/.htpasswd
