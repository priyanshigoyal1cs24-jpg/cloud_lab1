FROM nginx:alpine
COPY application/ /usr/share/nginx/html/
EXPOSE 80
