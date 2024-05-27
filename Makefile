install:
	docker-compose build

build: install
compile: install

reinstall:
	docker-compose build --no-cache

rebuild: reinstall
recompile: reinstall

run:
	docker-compose up -d

start: run
launch: run