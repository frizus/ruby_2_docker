run:
	docker-compose up -d

build:
	cp -n .env.default .env || true
	docker-compose build

build-no-cache:
	cp -n .env.default .env || true
	docker-compose build --no-cache

down:
	docker-compose stop || true

setup: down build

start: run

launch: run

compose: run

force-setup: down build-no-cache