#!/bin/bash

# make sure the words admin & administrator are not allowed as username
if [[ $WP_ADMIN_USER =~ [Aa]dmin|[Aa]dministrator ]];
then
    echo "Error: Admin username cannot contain 'A/admin' or 'A/administrator."
    exit 1
fi

if [ ! -f /var/www/html/index.php ]
then
    cd /var/www/html
    # download wordpress
    wget https://wordpress.org/latest.tar.gz

    tar -xzf latest.tar.gz --strip-components=1

    rm latest.tar.gz
    echo "wordpress downloaded."
fi

    # download wp-cli
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    sleep 2
    echo "wp-cli downloaded."
    # give execution permissions
    chmod +x wp-cli.phar
    # download core files
    ./wp-cli.phar core download --allow-root

# start mariadb to execute the cmd that gives wordpress access to the mariadb database 
while ! mariadb -h${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} -e "SELECT 1;" >/dev/null 2>&1
do
    # sleep 2
    echo "Waiting..."
done
echo "Connected to the database."

# create database
# configure env variables (the left side ones are in the core files)
./wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=${DB_HOST} --allow-root
# send core files
./wp-cli.phar core install --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --allow-root

# create second user (check whether it already exists or not)
if ./wp-cli.phar user list --field=user_login --allow-root | grep -q "^${WP_SECOND_USER}$";
then
    echo "Second user already exists."
else
    echo "Creating second user..."

    if ./wp-cli.phar user create "$WP_SECOND_USER" "$WP_SECOND_USER_EMAIL" \
        --user_pass="$WP_SECOND_USER_PASSWORD" \
        --role="$WP_SECOND_USER_ROLE" \
        --allow-root; 
    then
        echo "Second user created successfully."
    else
        echo "Failed to create a second user."
        exit 1
    fi
fi

exec php-fpm8.2 -F