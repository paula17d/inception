FROM debian:bookworm

# install wordpress 
RUN apt-get update && \
    apt-get install -y wget tar php-fpm && \
    apt-get clean

    
EXPOSE 9000

COPY ./config/www.conf /etc/php/8.2/fpm/pool.d/www.conf
    
RUN mkdir -p /run/php

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz

# currently running in background
CMD ["php-fpm8.2", "-F"]
