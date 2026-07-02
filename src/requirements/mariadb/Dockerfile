FROM debian:bookworm

# update advanced packaging tool to have all apps available
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

# open corresponding port
EXPOSE 3306

# copy file/folder into docker image
# replace old server config w new one to override MariaDB settings
COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# copy script to docker image root folder
COPY ./script/setup_mariadb.sh /

# give permission to execute script
RUN chmod +x /setup_mariadb.sh

CMD ["/setup_mariadb.sh"]