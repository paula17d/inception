#!/bin/bash

# ??
mkdir -p /run/mysqld

# ??
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# check if maria db's database is empty
if [ ! -d "/var/lib/mysql/wordpress" ]
then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    # start mariadb temporarily
    service mariadb start

    # wait until mariadb is completely ready and started
    sleep 5

    # create database
    mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"

    # create user
    mysql -e "CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'secret';"

    # give permissions
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"

    # take over changes
    mysql -e "FLUSH PRIVILEGES;"

    # shut down mariadb to then run it in the foreground later
    mysqladmin shutdown
fi

# execute mariadb in foreground, so container will stay active
exec mariadbd --user=mysql

# check if maria db's database is empty
#if [ ! -d "/var/lib/mysql/mysql" ];

#then
#    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

#fi



# When the MariaDB container starts, it should:
# 1. initialize the database directory if needed
# 2. start MariaDB temporarily
# 3. create the WordPress database
# 4. create a WordPress database user
# 5. give that user permissions
# 6. shut down the temporary server
# 7. restart MariaDB in the foreground so the container stays alive
# 8. call in dockerfile
