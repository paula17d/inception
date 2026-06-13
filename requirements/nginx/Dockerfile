FROM debian:bookworm 
# is bookworm correct second-to-last version

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean
    # rm -rf /var/lib/apt/lists/*

COPY ./config/default /etc/nginx/sites-enabled/default

EXPOSE 443

# start nginx in foreground
ENTRYPOINT ["nginx"] 
CMD ["-g", "daemon off;"] 

