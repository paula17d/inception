all: create-volumes up

create-volumes:
	@sudo mkdir -p /home/paula/data/wordpress_volume /home/paula/data/mariadb_volume

up:
	docker compose -f ./src/docker-compose.yml up

delete: 
	docker compose -f ./src/docker-compose.yml down --volumes --rmi all

delete-volumes-localhost:
	sudo rm -r -f rm -rf /home/paula/data

clean: delete delete-volumes-localhost

.PHONY: all create-volumes up delete delete-volumes-localhost clean
