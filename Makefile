DOCKER_COMPOSE := docker-compose
EXEC_SERVICE := mongo

.DEFAULT_GOAL := help

ifeq (manage,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif


help:  ## print this help
	@# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
.PHONY: help

build:  ## build a Docker image of this project
	$(DOCKER_COMPOSE) build
.PHONY: build

up:    ## run a dev site via docker-compose
	$(DOCKER_COMPOSE) up
.PHONY: up

down:  ## tear down and delete the docker-compose dev site
	$(DOCKER_COMPOSE) down -v
.PHONY: down

start: up
.PHONY: start

stop: down
.PHONY: stop

restart: stop start  ## restart docker-compose dev site
.PHONY: restart

ps: ## print docker-compose dev site container status
	$(DOCKER_COMPOSE) ps
.PHONY: ps

logs: ## print logs from docker-compose dev site
	$(DOCKER_COMPOSE) logs
.PHONY: logs

tail:  ## tail logs from docker-compose dev site
	$(DOCKER_COMPOSE) logs -f
.PHONY: tail

exec:  ## exec bash into the service
	${DOCKER_COMPOSE} exec ${EXEC_SERVICE} bash
.PHONY: exec

shell:  ## run a bash shell using the image
	${DOCKER_COMPOSE} run --entrypoint "bash" ${EXEC_SERVICE}
.PHONY: shell

debug:  ## make pdb work in container
	${DOCKER_COMPOSE} run --service-ports ${EXEC_SERVICE}

clean: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
.PHONY: clean
