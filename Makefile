.DEFAULT_GOAL := help

IMG ?= ghcr.io/neteye-platform/neteye-catalog:latest
OPM_IMAGE ?= quay.io/operator-framework/opm:v1.73.0@sha256:e5a6220603fb4504d58c6e3e488386b817e3695c906a62ee0370b5faedc3799a

.PHONY: build
build: ## Build the catalog image locally.
	docker build -t $(IMG) .

.PHONY: validate
validate: ## Validate the file-based catalog manifest.
	docker run --rm -v "$(CURDIR)/catalog:/configs:ro" $(OPM_IMAGE) validate /configs

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  %-18s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
