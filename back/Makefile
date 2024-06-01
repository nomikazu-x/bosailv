# Docker
build:
	docker compose build

up:
	docker compose up

down:
	docker compose down

# Rails 
create:
	docker compose run app rails db:create

migrate:
	docker compose run app rails db:migrate

migratetest:
	docker compose run app rails db:migrate RAILS_ENV=test

rollback:
	docker compose run app rails db:rollback

rollbacktest:
	docker compose run app rails db:rollback RAILS_ENV=test

migratereset:
	docker compose run app rails db:migrate:reset

migrateresettest:
	docker compose run app rails db:migrate:reset RAILS_ENV=test

seed:
	docker compose run app rails db:seed

seedtest:
	docker compose run app rails db:seed RAILS_ENV=test

seedreset:
	docker compose run app rails db:reset

bundleinstall:
	docker compose run app bundle install

rspec:
	docker compose run app rspec

railsc:
	docker compose run app rails c