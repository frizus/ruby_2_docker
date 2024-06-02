run:
	docker-compose up -d

install:
	cp -n .env.default .env || true
	docker-compose run --rm ruby-work-test1-ruby make setup

build:
	docker-compose build

down:
	docker-compose stop || true

setup: down build install

start: run

launch: run

compose: run