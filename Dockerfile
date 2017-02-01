FROM nginx:1.11-alpine

COPY nginx.conf /etc/nginx/
COPY site.template /tmp/

ARG PHP_UPSTREAM=php-fpm

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && adduser -D -H -u 1000 -s /bin/bash www-data \
    && rm /etc/nginx/conf.d/default.conf \
    && echo "upstream php-upstream { server ${PHP_UPSTREAM}:9000; }" > /etc/nginx/conf.d/upstream.conf

## Set Timezone

ARG TZ=Australia/Sydney
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /etc/nginx/sites-enabled

WORKDIR /var/www

#using envsubs allows us to write the site config at run time, based on the env vars at that moment
CMD ["/bin/bash","-c","envsubst '$$SERVER_NAME $$SERVER_ROOT' < /tmp/site.template > /etc/nginx/sites-enabled/${SERVER_NAME}.conf && nginx"]

EXPOSE 80
