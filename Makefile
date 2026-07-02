all: create-volumes up

# create folders where volumes will be
create-volumes:
	@sudo mkdir -p /home/paula/data/wordpress_volume /home/paula/data/mariadb_volume

# execute docker-compose.yml 
up:
	docker compose -f ./src/docker-compose.yml up

# delete volumes
clean: 
	sudo rm -r -f rm -rf /home/paula/data

# stop and remove containers, images, and volumes
fclean: clean
	docker compose -f ./src/docker-compose.yml down --volumes --rmi all

# stop and remove containers
down:
	docker compose -f ./src/docker-compose.yml down

# stop containers (without removing them)
stop: 
	docker compose -f ./src/docker-compose.yml stop

re: fclean all

.PHONY: all create-volumes up clean fclean stop
