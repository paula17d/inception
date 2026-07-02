# User Documentation

## What The Stack Provides

This project runs a small web stack with three services:

- Nginx is the public entry point and serves the site over HTTPS.
- WordPress runs on PHP-FPM and handles the website content and administration panel.
- MariaDB stores the WordPress database.

The services communicate through a private Docker network, while the WordPress files and the database data are kept on the host so they survive container restarts.

## Start And Stop

From the repository root:

```bash
make
```

This creates the host directories used by the persistent storage and starts the stack.

Useful commands:

```bash
make up
make down
make stop
make fclean
```

## Access The Website

Open the configured HTTPS address in your browser:

```text
https://pdrettas.42.fr
```

If your browser warns about the certificate, that is expected because the stack uses a self-signed certificate.

## Access The Administration Panel

The WordPress admin area is available at:

```text
https://pdrettas.42.fr/wp-admin
```

Use the administrator account defined in `src/.env`.

## Credentials

Credentials are configured in `src/.env` and are used when the stack initializes.

The main values are:

- Database name, user, and password.
- WordPress URL and site title.
- WordPress administrator username, password, and email.
- The additional WordPress user created by the setup script.

If you change credentials, update `src/.env` first and then recreate the containers so the scripts can apply the new values.

## Check That Services Are Running

To verify the stack:

```bash
docker compose -f src/docker-compose.yml ps
docker compose -f src/docker-compose.yml logs
```

You should see `nginx`, `wordpress`, and `mariadb` in an `Up` state.

You can also confirm the site is reachable with:

```bash
curl -k https://pdrettas.42.fr
```

## Useful Notes

- WordPress data is stored on the host path defined in `src/docker-compose.yml` and is mounted into `/var/www/html`.
- MariaDB data is stored on the host path defined in `src/docker-compose.yml` and is mounted into `/var/lib/mysql`.
- If you want a full reset, use `make fclean` to stop the stack and remove the persistent data used by the project.