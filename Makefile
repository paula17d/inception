all: create-volumes up

create-volumes:
	@sudo mkdir -p /home/paula/inception_final/wordpress_volume /home/paula/inception_final/mariadb_volume

up:
	docker compose -f ./src/docker-compose.yml up

delete: 
	docker compose -f ./src/docker-compose.yml down --volumes --rmi all

delete-volumes-localhost:
	sudo rm -rf /home/paula/inception_final/wordpress_volume /home/paula/inception_final/mariadb_volume 

clean: delete delete-volumes-localhost

.PHONY: all create-volumes up delete delete-volumes-localhost clean
