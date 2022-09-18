# Docker
build:
	docker-compose build

up:
	docker-compose up

down:
	docker-compose down

# Rails 
migrate:
	docker-compose run api rails db:migrate

migratetest:
	docker-compose run api rails db:migrate RAILS_ENV=test

rollback:
	docker-compose run api rails db:rollback

rollbacktest:
	docker-compose run api rails db:rollback RAILS_ENV=test

migratereset:
	docker-compose run api rails db:migrate:reset

migrateresettest:
	docker-compose run api rails db:migrate:reset RAILS_ENV=test

seed:
	docker-compose run api rails db:seed

seedreset:
	docker-compose run api rails db:reset

bundleinstall:
	docker-compose run api bundle install

rspec:
	docker-compose run api rspec

railsc:
	docker-compose run api rails c