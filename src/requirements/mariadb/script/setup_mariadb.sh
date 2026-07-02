#!/bin/bash

# entire script initializes MariaDB and creates database and user for WordPress.  

# if any command fails, script is stopped
set -e

# create directory for MariaDB to run in
mkdir -p /run/mysqld

# give MariaDB permission to read/write/create files it needs there
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# check if database already exists
# if not, initialize MariaDB and create database and user for WordPress
if [ ! -d "/var/lib/mysql/mysql/wordpress" ]; then
    echo "Initializing MariaDB..."

    # creates MariaDB data directory and system tables (tables like user, db with rows like username, password, etc)
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # starts MariaDB in background (&) to allow for database and user creation (cannot run in foreground bc script still going)
    # shell would wait here for MariaDB to finish running in foreground before continuing script 
    mysqld_safe --user=mysql &

    # wordpress needs to wait for mariadb to be fully initialized or else fail connecting to early
    until mariadb -e "SELECT 1;" >/dev/null 2>&1
    do
        sleep 1
    done

    echo "Creating database and user..."

# creates Wordpress database, adds a user (allowed to connect from any host), grants that user full access to database 
# then reloads the privilege tables to have changes right in without needing to restart MariaDB
    mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    # stops temporary MariaDB process  
    mysqladmin shutdown
fi

echo "Starting MariaDB..."

# run in foreground
exec mariadbd --user=mysql