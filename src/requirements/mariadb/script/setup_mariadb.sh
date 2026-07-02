#!/bin/bash

set -e

mkdir -p /run/mysqld

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# wordpress (l18) needs to wait for mariadb to be fully initialized or else fail connecting to early
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
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    mysqladmin shutdown
fi

echo "Starting MariaDB..."

# runs in foreground
exec mariadbd --user=mysql