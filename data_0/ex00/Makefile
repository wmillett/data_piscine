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

re: fclean all

psql: all
	docker run -it --rm --network host postgres psql -U wmillett -d piscineds -h localhost -W

.PHONY: all up down fclean psql re status
