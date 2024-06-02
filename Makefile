run:
	docker-compose up -d

build:
	cp -n .env.default .env || true
	docker-compose build

build-no-cache:
	cp -n .env.default .env || true
	docker-compose build --no-cache

install:
	docker-compose run --rm ruby "bash | git clone https://github.com/frizus/ruby-test-work1.git ./ && make setup"

install:
	docker-compose run --rm ruby bash --login -c "\
	git clone https://github.com/frizus/ruby-test-work1.git ./; \
	make setup"

down:
	docker-compose stop || true

setup: down build install

start: run

launch: run

compose: run

force-setup: down build-no-cache install