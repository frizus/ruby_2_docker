run:
	docker-compose up -d

build:
	cp -n .env.default .env || true
	docker-compose build

build-no-cache:
	cp -n .env.default .env || true
	docker-compose build --no-cache

download-app-and-run-setup:
	docker-compose run --rm ruby bash --login -c "\
	git clone https://github.com/frizus/ruby-test-work1.git ./; \
	make setup"

down:
	docker-compose stop || true

setup: down build download-app-and-run-setup

install: setup

start: run

launch: run

compose: run

force-setup: down build-no-cache download-app-and-run-setup
