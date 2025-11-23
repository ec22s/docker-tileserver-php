SHELL=/bin/bash

.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9_-]+: $(MAKEFILE_LIST) | sed 's/://')

up:
	@docker compose up -d --build

down:
	@docker compose down --rmi all

restart:
	@docker compose restart

clean-restart:
	@make down && make up

in:
	@docker compose exec -it web /bin/bash

status:
	@docker exec web sh -c "service apache2 status"

apache-status:
	@docker exec web sh -c "service apache2 status"

apache-reload:
	@docker exec web sh -c "service apache2 reload; service apache2 status"

apache-force-reload:
	@docker exec web sh -c "service apache2 force-reload; service apache2 status"

test:
	@docker exec web sh -c "cd /var/www/html && php tileserver.php"
