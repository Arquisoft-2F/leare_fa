FROM nginx:latest

RUN rm -rf /usr/share/nginx/html/*

COPY ./build/web /usr/share/nginx/html

COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 7777
