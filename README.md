# docker-php-fpm-7
Native docker php-fpm 7 with memcached, opcache

# How to start
docker run -d -v /home/vhosts/domain.com:/var/www/html -p 127.0.0.1:9900:9000 thuannvn/php-fpm-7

# Nginx host reverse proxy to docker container
See conf/domain.conf
