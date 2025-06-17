DC = docker compose

all: setup up

status:
	$(DC) ps

up:
	$(DC) up -d --build

down:
	$(DC) down

fclean:
	$(DC) down --rmi all -v --remove-orphans
	$(DC) rm -f


re: fclean all

run: all
	docker exec -it db_container bash

remove_empty:
	docker container prune -f


setup:
	if [ ! -f ".env" ]; then \
		echo "Creating .env file..."; \
		touch .env; \
		cat ../env.txt > .env; \
	fi
clear:
	rm -rf .env

psql:
	$(DC) up -d --build
	docker exec -it db_container psql -U wmillett -d piscineds

space:
	../docker_space.sh wmillett

show:
	docker exec -it db_container psql -U wmillett -d piscineds -f util/showcustomertable.sql

destroy: fclean remove_empty clear

test_removed_duplicates:
	docker exec -it db_container psql -U wmillett -d piscineds -f util/test_duplicates.sql

.PHONY: all up down fclean psql re status run remove_empty space items combine_tables setup clear destroy
