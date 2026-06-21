#!/bin/bash

if [ ! -f /var/www/html/index.php ]
then
    cd /var/www/html

    wget https://wordpress.org/latest.tar.gz

    tar -xzf latest.tar.gz --strip-components=1

    rm latest.tar.gz
fi

# start mariadb to execute the cmd that gives wordpress access to the mariadb database 
while ! mariadb -hmariadb -uwpuser -psecret -e "SELECT 1;" >/dev/null 2>&1
do
    # sleep 2
    echo "Waiting..."
done

echo "Connected to the database."

exec php-fpm8.2 -F