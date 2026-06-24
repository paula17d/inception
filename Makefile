all: create-volumes up

create-volumes:
	@sudo mkdir -p /home/paula/data/wordpress_volume /home/paula/data/mariadb_volume

up:
	docker compose -f ./src/docker-compose.yml up

# for folders
clean: 
	sudo rm -r -f rm -rf /home/paula/data

# for containers
fclean: clean
	docker compose -f ./src/docker-compose.yml down --volumes --rmi all

re: fclean all

.PHONY: all create-volumes up clean fclean
