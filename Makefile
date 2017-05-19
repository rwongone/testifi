# Prologue from http://clarkgrubb.com/makefile-style-guide.
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
UID=$(shell id -u)
GID=$(shell id -g)

# When a phony target is declared, make will execute the recipe regardless of whether a file with the same name exists.
.PHONY: all install dev build run console c stop deploy deploy_build deploy_run

all: dev

install: build create_db

dev: build run

build:
	docker build -f Dockerfile.rails -t testifi_app .

# If we get a reverse proxy going, we can scale the app to 2 instances.
run:
	docker-compose up --scale app=1 -d

console:
	docker exec -it testifi_app sh

c: console

stop:
	docker kill testifi_app testifi_db

deploy: deploy_build deploy_run

deploy_build:
	docker build -f Dockerfile.testifi -t testifi_deploy .

deploy_run:
	docker run --rm -it \
		--name testifi_deploy \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e PROJECT_DIR=$(PWD) \
		testifi_deploy:latest \
		sh -c make dev

client_dev:
	docker container run --rm -it \
		-v $(PWD)/client:/usr/src/app \
		-w /usr/src/app \
		-u $(UID):$(GID) \
		-p 3001:3001 \
		-e PORT=3001 \
		node \
		npm start

node:
	docker container run --rm -it \
		-v $(PWD):/usr/src/app \
		-w /usr/src/app \
		-u $(UID):$(GID) \
		node \
		bash
