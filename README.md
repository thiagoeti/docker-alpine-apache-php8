# Docker - Alpine - Apache / PHP

Container to run PHP.

Create **data**.

```console
mkdir "/data"
mkdir "/data/www"
```

Create **log**.

```console
mkdir "/data/log"
mkdir "/data/log/www"
mkdir "/data/log/apache"
mkdir "/data/log/www/app-php8"
```

Create repository for **app**.

```console
mkdir "/data/www/app-php8"
mkdir "/data/www/app-php8/log"
```

#### Dockerfile

File *dockerfile* for mount machine.

```dockerfile
# so
FROM alpine:latest

# by
MAINTAINER Thiago Silva - thiagoeti@gmail.com

# repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> "/etc/apk/repositories"

# update
RUN apk --no-cache update && apk --no-cache upgrade

# bash
RUN apk add bash

# apache
RUN apk add apache2 && \
	apk add apache2-utils && \
	apk add libxml2-dev && \
	sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf && \
	sed -i '/LoadModule expires_module/s/^#//g' /etc/apache2/httpd.conf && \
	sed -i '/LoadModule deflate_module/s/^#//g' /etc/apache2/httpd.conf && \
	sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/httpd.conf && \
	sed -i 's#Options Indexes FollowSymLinks#Options -Indexes#' /etc/apache2/httpd.conf && \
	sed -i 's#ServerAdmin you@example.com#ServerAdmin thiagoeti@gmail.com#' /etc/apache2/httpd.conf
COPY ./apache/git.conf /etc/apache2/conf.d/git.conf
COPY ./apache/general.conf /etc/apache2/conf.d/general.conf

# php
RUN apk add php8 && \
	apk add php8-apache2 && \
	apk add php8-common && \
	apk add php8-opcache && \
	apk add php8-fpm && \
	apk add php8-session && \
	apk add php8-openssl && \
	apk add php8-mysqli && \
	apk add php8-mysqlnd && \
	apk add php8-pgsql && \
	apk add php8-pdo && \
	apk add php8-pdo_mysql && \
	apk add php8-pdo_pgsql && \
	apk add php8-pdo_sqlite && \
	apk add php8-sockets && \
	apk add php8-curl && \
	apk add php8-ftp && \
	apk add php8-json && \
	apk add php8-gd && \
	apk add php8-iconv && \
	apk add php8-soap && \
	apk add php8-xml && \
	apk add php8-xmlwriter && \
	apk add php8-xmlreader && \
	apk add php8-simplexml && \
	apk add php8-dom && \
	apk add php8-xsl && \
	apk add php8-fileinfo && \
	apk add php8-zip && \
	apk add php8-zlib && \
	apk add php8-mbstring && \
	apk add php8-tokenizer && \
	apk add php8-ctype && \
	apk add php8-phar

# clear
RUN rm -rfv /var/cache/apk/*

# ports
EXPOSE 80 443

# www
RUN mkdir /data && \
	mkdir /data/log && \
	mkdir /data/public && \
	rm -rfv /var/www/localhost/htdocs && \
	ln -fs /data/public /var/www/localhost/htdocs

# work
WORKDIR /data

# start httpd
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```

## Build Machine

```console
docker build --no-cache -t "alpine-apache-php8" "/data/container/alpine-apache-php8/."
```

### APP

Copy script for test APP.

```console
cp -rfv "/data/container/alpine-apache-php8/_app/" "/data/www/app-php8"
```

Run container APP.

```console
docker run --name "app-php8" \
	-p 7001:80 \
	-v "/etc/hosts":"/etc/hosts" \
	-v "/data/log/apache/app-php8":"/var/log/apache2" \
	-v "/data/log/www/app-php8":"/data/log" \
	-v "/data/www/app-php8":"/data" \
	--restart=always \
	-d "alpine-apache-php8":"latest"
```

> Important: **/etc/hosts** shared to configuration all server.

Attach container.

```console
docker attach "app-php8"
docker exec -it "app-php8" "/bin/bash"
```

Run in container.

```console
docker exec -d "app-php8" "/bin/bash" php -v
```
