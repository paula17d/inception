FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

# copy file/folder into docker image
# TODO: replace old server config w new one to override MariaDB settings
COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf