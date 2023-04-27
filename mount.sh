#!/bin/sh

# data
mkdir "/data"
mkdir "/data/www"

# log
mkdir "/data/log"
mkdir "/data/log/www"
mkdir "/data/log/apache"
mkdir "/data/log/www/app-php8"

# app
mkdir "/data/www/app-php8"
mkdir "/data/www/app-php8/log"

# drop
docker rmi -f "alpine-apache-php8"

# build
docker build --no-cache -t "alpine-apache-php8" "/data/container/alpine-apache-php8/."

# test
rm -rfv "/data/www/app-php8"
cp -rfv "/data/container/alpine-apache-php8/_app/" "/data/www/app-php8"

# drop
docker rm -f "app-php8"

# run -> app
docker run --name "app-php8" \
	-p 7003:80 \
	-v "/etc/hosts":"/etc/hosts" \
	-v "/data/log/apache/app-php8":"/var/log/apache2" \
	-v "/data/log/www/app-php8":"/data/log" \
	-v "/data/www/app-php8":"/data" \
	--restart=always \
	-d "alpine-apache-php8":"latest"

# attach
docker attach "app-php8"
docker exec -it "app-php8" "/bin/bash"

# start
docker start "app-php8"

# app

docker exec -d "app-php8" "/bin/bash" php -v

#
