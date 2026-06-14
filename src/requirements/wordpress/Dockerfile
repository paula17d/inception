FROM debian:bookworm

# install wordpress 
RUN apt-get update && \
    apt-get install -y wordpress curl wget tar php-fpm && \
    apt-get clean

RUN mkdir -p /run/php

WORKDIR /var/www

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz

# currently running in background
CMD ["php-fpm8.2", "-F"]
