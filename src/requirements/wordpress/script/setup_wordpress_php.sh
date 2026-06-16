#!/bin/bash

if [ ! -f /var/www/html/index.php ]
then
    cd /var/www/html

    wget https://wordpress.org/latest.tar.gz

    tar -xzf latest.tar.gz --strip-components=1

    rm latest.tar.gz
fi

exec php-fpm8.2 -F