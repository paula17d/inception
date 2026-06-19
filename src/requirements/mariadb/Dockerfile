FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

# open corresponding port
EXPOSE 3306

# copy file/folder into docker image
# TODO: replace old server config w new one to override MariaDB settings
COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./script/setup_mariadb.sh /
RUN chmod +x /setup_mariadb.sh

CMD ["/setup_mariadb.sh"]