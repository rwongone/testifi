# Prologue from http://clarkgrubb.com/makefile-style-guide.
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
UID=$(shell id -u)
GID=$(shell id -g)
RUNTIME_ENV ?= DEV
DOCKER_DIR=docker/sys


# When a phony target is declared, make will execute the recipe regardless of whether a file with the same name exists.
.PHONY: all deploy deploy_build deploy_run stop bootstrap build run client_build node console c test attach


# default `all` target to run backend and client development server from testifi_deploy.
# `make install` to deploy backend and generate static client assets.
all: bootstrap
install: deploy


# deploy the application, and forcefully stop its execution.
deploy: copy_secret deploy_build deploy_run
copy_secret:
	cp -n config/secrets.yml{.base,}
deploy_build:
	docker build -f $(DOCKER_DIR)/Dockerfile.testifi -t testifi_deploy .
deploy_run:
	docker run --rm -it \
		--name testifi_deploy \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e PROJECT_DIR=$(PWD) \
		-e HOST_UID=$(UID) \
		-e HOST_GID=$(GID) \
		-e RUNTIME_ENV=$(RUNTIME_ENV) \
		testifi_deploy:latest \
		sh -c "make bootstrap"
stop:
	echo "Force stopping all containers";
	-docker rm -f testifi_app testifi_db client_dev testifi_caddy testifi_redis;
	sudo rm -rf tmp
clean: stop


# bootstrap, build, run are to be executed from a testifi_deploy container,
# as `make deploy` would create.
bootstrap: build run
build:
	docker build -f $(DOCKER_DIR)/Dockerfile.rails -t testifi_app .
	docker build -f $(DOCKER_DIR)/Dockerfile.caddy -t testifi_caddy .
run:
	docker-compose -f $(DOCKER_DIR)/docker-compose.yml -f $(DOCKER_DIR)/docker-compose.client.yml up --scale app=1 -d


# for installing node packages
node:
	docker container run --rm -it \
		-v $(PWD)/client:/usr/src/app \
		-w /usr/src/app \
		-u $(UID):$(GID) \
		node \
		bash


console:
	docker exec -it testifi_app bash
c: console


# for running tests without entering container
test:
	docker exec -it testifi_app bash -c 'rspec -fd'


# attach to Docker process running Rails so we can use byebug.
# ctrl-P, ctrl-Q to detach.
attach:
	docker container attach --sig-proxy=false testifi_app
