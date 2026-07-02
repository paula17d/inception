*This project has been created as part of the 42 curriculum by pdrettas.*

# Description

Inception is a Docker-based infrastructure project that deploys a small web stack made of Nginx, WordPress, PHP-FPM, and MariaDB.

The goal is to understand how services are isolated in containers, how they communicate through a Docker network, how persistent data is handled with volumes, and how a secure HTTPS entry point is configured. In this repository, Nginx acts as the public-facing reverse proxy, WordPress runs behind PHP-FPM, and MariaDB stores the application data. The WordPress and database data are persisted outside the containers so the environment can be rebuilt without losing content.

## Project Description

The project is organized around three custom images and one Docker Compose stack:

- Nginx is built from a Debian base image, installs Nginx and OpenSSL, generates a self-signed certificate, and serves the WordPress site over HTTPS on port 443.
- WordPress is built from a Debian base image, installs PHP-FPM, PHP extensions, MariaDB client tools, and wp-cli, then boots WordPress and configures the site automatically once MariaDB is reachable.
- MariaDB is built from a Debian base image, installs the database server, initializes the data directory, creates the database and user, and keeps the database running in the foreground.
- Docker Compose connects the three services on a dedicated bridge network named `inception` and exposes only the Nginx HTTPS port to the host.

The repository also includes the configuration files and shell scripts required to customize each service:

- `src/requirements/nginx/config/default` configures the HTTPS virtual host and forwards PHP requests to the WordPress container.
- `src/requirements/wordpress/config/www.conf` configures PHP-FPM to listen on port 9000.
- `src/requirements/wordpress/script/setup_wordpress_php.sh` downloads WordPress, installs it with wp-cli, waits for MariaDB, and creates the admin and secondary user.
- `src/requirements/mariadb/script/setup_mariadb.sh` initializes the database and grants the WordPress user access.

## Technical Choices

### Virtual Machines vs Docker

Virtual machines emulate a full operating system for each environment, which gives strong isolation but uses more memory, disk space, and boot time. Docker shares the host kernel and packages only the dependencies needed by each service, which makes the stack lighter and easier to rebuild. For this project, Docker is the better fit because the infrastructure is split into a few small services that need fast startup, reproducibility, and easy teardown.

### Secrets vs Environment Variables

Environment variables are convenient for passing configuration values such as database names, usernames, passwords, and the public URL. They are simple to wire into Docker Compose, but they are not a secure secret store. Secrets are better when values must be protected more strictly and managed separately from application config. In this project, environment variables are used for the setup workflow because the stack is small and the subject focuses on container orchestration, but real production credentials should be managed as secrets instead.

### Docker Network vs Host Network

The compose file uses a dedicated bridge network rather than the host network. That keeps the containers isolated from the host network stack while still allowing them to resolve each other by service name. It also keeps only the Nginx port exposed to the outside world. Host networking would remove that isolation and make the setup less controlled, which is not desirable here.

### Docker Volumes vs Bind Mounts

Volumes are the right choice for portable application data managed by Docker, while bind mounts are useful when you want to map a specific host path directly into a container. This project uses bind-mounted volume paths under `/home/paula/data` so the persistent data is stored on the host filesystem and survives container recreation. The shared WordPress files and the MariaDB data directory are therefore preserved independently of the container lifecycle.

## Instructions

### Prerequisites

- Docker Engine and Docker Compose must be installed.
- The user running the project must be allowed to use `sudo`, because the Makefile creates the host directories used by the persistent volumes.
- The environment file must exist at `src/.env` and provide the variables used by the WordPress and MariaDB containers.

### Environment Variables

The stack expects values for at least the following variables:

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

### Build and Run

From the repository root:

```bash
make
```

This command creates the host directories used by the volumes and then starts the stack with Docker Compose.

Useful targets:

```bash
make up
make down
make stop
make fclean
```

### Access

Once the stack is running, open the configured URL over HTTPS, for example:

```text
https://pdrettas.42.fr
```

If you are testing locally, make sure the domain in `src/requirements/nginx/config/default` matches your environment and resolves to your machine.

## Resources

### References

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Nginx documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- WP-CLI documentation: https://wp-cli.org/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php

### How AI Was Used

AI was used to help draft and organize this README, and clarify any questions in regards to the subject requirements.