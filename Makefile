VERSION    :=$(shell cat .version)

all: help

.PHONY: tag
tag: ## Creates release tag 
	git tag -s -m "version bump to $(VERSION)" $(VERSION)
	git push origin $(VERSION)

.PHONY: tagless
tagless: ## Delete the current release tag 
	git tag -d $(VERSION)
	git push --delete origin $(VERSION)


.PHONY: setup
setup: ## Creates the GCP resources 
	terraform -chdir=./setup init
	terraform -chdir=./setup apply -auto-approve

.PHONY: apply
apply: ## Applies Terraform
	terraform -chdir=./setup apply -auto-approve

.PHONY: destroy
destroy: ## Destroy all resources created by Terraform
	terraform -chdir=./setup destroy

.PHONY: help
help: ## Display available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk \
		'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

