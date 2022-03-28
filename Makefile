# Docker
build:
	docker-compose build

up:
	docker-compose up

down:
	docker-compose down

# Vue
yarninstall:
	docker-compose run front yarn install

lint:
	docker-compose run front yarn lint

# Rails 
migrate:
	docker-compose run api rails db:migrate

rollback:
	docker-compose run api rails db:rollback

migratereset:
	docker-compose run api rails db:migrate:reset

seed:
	docker-compose run api rails db:seed

seedreset:
	docker-compose run api rails db:reset

bundleinstall:
	docker-compose run api bundle install