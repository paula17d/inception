FROM debian:bookworm

# install wordpress (php-mysql is database)
RUN apt-get update && \
    apt-get install -y wget tar php-fpm php-mysql mariadb-client && \
    apt-get clean

    
EXPOSE 9000

COPY ./config/www.conf /etc/php/8.2/fpm/pool.d/www.conf
    
RUN mkdir -p /run/php

COPY ./script/setup_wordpress_php.sh /
RUN chmod +x /setup_wordpress_php.sh

CMD ["/setup_wordpress_php.sh"]