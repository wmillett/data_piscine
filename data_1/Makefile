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

remove_empty:
	docker container prune -f


setup:
	if [ ! -f ".env" ]; then \
		echo "Creating .env file..."; \
		touch .env; \
		cat ../env.txt > .env; \
	fi
	if [ ! -d "customer" ]; then \
		echo "Creating customer directory..."; \
		mkdir customer; \
	fi
	if [ ! -d "item" ]; then \
		echo "Creating item directory..."; \
		mkdir item; \
	fi
	if [ -f "../../too_big/subject.zip" ]; then \
		mkdir -p tmp_extract; \
		unzip ../../too_big/subject.zip "subject/customer/*" -d tmp_extract/; \
		mv tmp_extract/subject/customer/* customer/; \
		rm -rf tmp_extract/*; \
		unzip ../../too_big/subject.zip "subject/item/*" -d tmp_extract/; \
		mv tmp_extract/subject/item/* item/; \
		rm -rf tmp_extract; \
	fi
clear:
	rm -rf customer
	rm -rf item
	rm -rf .env

psql:
	$(DC) up -d --build
	docker exec -it db_container psql -U wmillett -d piscineds

import:
	python3 automatic_table.py

items:
	python3 items_table.py

combine_tables:
	$(DC) up -d --build
	docker exec -it db_container psql -U wmillett -d piscineds -f ex01/customers_table.sql

remove_duplicates:
	docker exec -it db_container psql -U wmillett -d piscineds -f ex02/remove_duplicates.sql

remove_tables:
	docker exec -it db_container psql -U wmillett -d piscineds -c "DROP TABLE IF EXISTS customers, items, orders, order_items CASCADE;"

order:
	docker exec -it db_container psql -U wmillett -d piscineds -f util/order_table.sql

fusion:
	docker exec -it db_container psql -U wmillett -d piscineds -f ex03/fusion.sql

destroy: fclean remove_empty clear


.PHONY: all up down fclean psql pgadmin re status import run remove_empty items combine_tables setup clear remove_duplicates remove_tables order fusion destroy
