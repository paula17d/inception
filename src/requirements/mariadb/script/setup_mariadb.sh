#!/bin/bash

set -e

mkdir -p /run/mysqld

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql/wordpress" ]; then
    echo "Initializing MariaDB..."

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld_safe --user=mysql &

    until mariadb -e "SELECT 1;" >/dev/null 2>&1
    do
        sleep 1
    done

    echo "Creating database and user..."

    mariadb <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
EOF

    mysqladmin shutdown
fi

echo "Starting MariaDB..."

exec mariadbd --user=mysql