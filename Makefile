#
# Variables
#
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Before we start test that we have the mandatory executables available
	EXECUTABLES = git docker
	K := $(foreach exec,$(EXECUTABLES),\
		$(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, consider installing $(exec)")))


.PHONY: help up down status post bake push registry docker-up docker-down

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

registry-up: ## start the local docker registry
	@docker ps | grep -q 'registry\:2' || docker service create --name registry --publish published=5000,target=5000 --mount type=bind,source=$(ROOT_DIR)/registry_root,destination=/var/lib/registry registry:2

registry-down: ## stop the local docker registry
	@echo "removing docker registry"
	@docker service rm registry

