FROM nginx:latest

RUN rm -rf /usr/share/nginx/html/*

COPY ./build/web /usr/share/nginx/html

COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf

COPY ./leare_proxy_web/certs/ /etc/nginx/ssl/

EXPOSE 80 433
