DC = docker compose

all: up

status:
	$(DC) ps

up:
	$(DC) up -d --build

down:
	$(DC) down

fclean:
	$(DC) down --rmi all -v --remove-orphans
	$(DC) rm -f
#Yes | $(DC) system prune -a --volumes

re: fclean all

run: all
	docker exec -it db_container bash

remove:
	docker container prune -f


psql:
	$(DC) up -d --build
	docker exec -it db_container psql -U wmillett -d piscineds

import:
	python3 automatic_table.py

items:
	python3 items_table.py

.PHONY: all up down fclean psql pgadmin re status import run remove items
