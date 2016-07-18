FROM centos:7
RUN yum -y update && yum clean all
RUN yum -y install epel-release
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUn rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

RUN yum -y install php70w php70w-devel
RUN yum install -y php70w-mysql php70w-xml php70w-soap php70w-xmlrpc
RUN yum install -y php70w-mbstring php70w-json php70w-gd php70w-mcrypt
RUN yum install -y php70w-fpm php70w-opcache
RUN sed -e 's/127.0.0.1:9000/9000/' \
        -e '/allowed_clients/d' \
        -e '/catch_workers_output/s/^;//' \
        -e '/error_log/d' \
        -i /etc/php-fpm.d/www.conf

RUN yum -y install nginx git gcc zlib-devel wget supervisor
RUN sed -i -e 's/apache/nginx/g' /etc/php-fpm.d/www.conf
RUN mkdir -p /var/www/html
RUN mkdir -p /home/vhosts
RUN ln -s /var/www/html /home/vhosts/techblogsearch.com

# Install memcached
RUN yum -y install memcached libmemcached-devel

# Install php memcache
RUN git clone -b php7 https://github.com/php-memcached-dev/php-memcached
RUN cd php-memcached && pwd && phpize && ./configure && make && make install
RUN echo "extension=memcached.so" > /etc/php.d/memcached.ini

# Install supervisord
COPY conf/supervisord.ini /etc/supervisord.d/

EXPOSE 9000
ENTRYPOINT /usr/bin/supervisord -n -c /etc/supervisord.conf 
