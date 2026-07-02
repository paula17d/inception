# How To

1. Set up the environment from scratch (prerequisites, configuration files, secrets).

2. Build and launch the project using the Makefile and Docker Compose.

3. Use relevant commands to manage the containers and volumes.

4. Identify where the project data is stored and how it persists


# Developer Documentation

## Prerequisites

Before starting, install:

- Docker Engine
- Docker Compose
- `make`

The project also expects permission to run `sudo`, because the Makefile creates the host directories used by the persistent storage.

## Configuration Files

The main configuration is split across these files:

- `src/.env` for the values used by WordPress and MariaDB.
- `src/docker-compose.yml` for the services, network, ports, and persistent storage.
- `src/requirements/nginx/config/default` for the HTTPS Nginx virtual host.
- `src/requirements/wordpress/config/www.conf` for the PHP-FPM pool configuration.
- `src/requirements/mariadb/config/50-server.cnf` for MariaDB server settings.
- `src/requirements/wordpress/script/setup_wordpress_php.sh` for the WordPress bootstrap.
- `src/requirements/mariadb/script/setup_mariadb.sh` for the MariaDB initialization.

## Environment Setup

Create `src/.env` with the variables used by the bootstrap scripts and Compose file.

At minimum, define:

- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
- `DB_HOST`
- `WP_URL`
- `WP_TITLE`
- `WP_ADMIN_USER`
- `WP_ADMIN_PASSWORD`
- `WP_ADMIN_EMAIL`
- `WP_SECOND_USER`
- `WP_SECOND_USER_EMAIL`
- `WP_SECOND_USER_PASSWORD`
- `WP_SECOND_USER_ROLE`

These values are consumed when the WordPress and MariaDB containers start, so changing them usually requires recreating the stack.

## Build And Launch

From the repository root, the standard workflow is:

```bash
make
```

This runs the volume directory creation step and then starts the stack with Docker Compose.

Other useful commands are:

```bash
make up
make down
make stop
make fclean
make re
```

If you modify Dockerfiles or service configuration, `make re` is the cleanest way to rebuild the stack from scratch.

## Managing Containers

Useful Docker Compose commands:

```bash
docker compose -f src/docker-compose.yml ps
docker compose -f src/docker-compose.yml logs
docker compose -f src/docker-compose.yml logs -f wordpress
docker compose -f src/docker-compose.yml exec wordpress bash
docker compose -f src/docker-compose.yml exec mariadb bash
```

The Makefile contains the most common actions:

- `make up` starts the services.
- `make stop` stops the containers without removing them.
- `make down` stops and removes the containers.
- `make fclean` removes the containers, images, and persistent project data.

## Data Storage And Persistence

The project uses bind-mounted named volumes defined in `src/docker-compose.yml`:

- WordPress data is mounted into `/var/www/html` inside the container.
- MariaDB data is mounted into `/var/lib/mysql` inside the container.

The host paths used by the bind mounts are:

- `/home/paula/data/wordpress_volume`
- `/home/paula/data/mariadb_volume`

Because the data lives on the host filesystem, WordPress content and the MariaDB database survive container recreation. Removing those host directories, or running the full cleanup target, resets the stack data.