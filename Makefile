.PHONY: up
up:
	@docker-compose up -d --build

.PHONY: down
down:
	@docker-compose down --rmi all

.PHONY: restart
restart:
	@docker-compose restart

.PHONY: clean-restart
clean-restart:
	@make down && make up

.PHONY: in
in:
	@docker-compose exec -it web /bin/bash

.PHONY: status
status:
	@docker exec web sh -c "service apache2 status"

.PHONY: apache-status
apache-status:
	@docker exec web sh -c "service apache2 status"

.PHONY: apache-reload
apache-reload:
	@docker exec web sh -c "service apache2 reload; service apache2 status"

.PHONY: apache-force-reload
apache-force-reload:
	@docker exec web sh -c "service apache2 force-reload; service apache2 status"

.PHONY: test
test:
	@docker exec web sh -c "cd /var/www/html && php tileserver.php"
