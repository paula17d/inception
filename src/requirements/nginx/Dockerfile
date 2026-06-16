FROM debian:bookworm 
# is bookworm correct second-to-last version

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean
    # rm -rf /var/lib/apt/lists/*

EXPOSE 443

# send the adjusted default (left) to the og default (right) to overwrite
COPY ./config/default /etc/nginx/sites-enabled/default


# creates a folder where the ssl keys/certificates are (needed for https)
RUN mkdir -p /etc/nginx/ssl

# create and put certificates into folder above
RUN openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/key.key \
    -out /etc/nginx/ssl/cert.crt \
    -sha256 -days 3650 -nodes \
    -subj "/C=DE/ST=Baden-Wurttemberg/L=Heilbronn/O=42Heilbronn/OU=Paula Drettas ROOT CA/CN=Paula Drettas"

# start nginx in foreground
ENTRYPOINT ["nginx"] 
CMD ["-g", "daemon off;"] 
