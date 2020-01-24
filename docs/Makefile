# This Makefile contains all targets related to building atomix docs website

ATOMIX_DOCS_BUILD_IMAGE ?= atomix-docs
ATOMIX_DOCS_CHECK_IMAGE ?= $(ATOMIX_DOCS_BUILD_IMAGE)-check

SITE_DIR := $(CURDIR)/site

DOCKER_RUN_DOC_PORT := 8000
DOCKER_RUN_DOC_MOUNTS := -v $(CURDIR):/mkdocs 
DOCKER_RUN_DOC_OPTS := --rm $(DOCKER_RUN_DOC_MOUNTS) -p $(DOCKER_RUN_DOC_PORT):8000


# Default: generates the documentation into $(SITE_DIR)
docs: docs-build 

# Writer Mode: build and serve docs on http://localhost:8000 with livereload
docs-serve: docs-build 
	docker run -it  $(DOCKER_RUN_DOC_OPTS) $(ATOMIX_DOCS_BUILD_IMAGE) /bin/sh -c "cd "site" && python3 -m http.server 8000"


# Build atomix docs related images
docs-image:
	docker build -t $(ATOMIX_DOCS_BUILD_IMAGE) -f docs.Dockerfile ./

docs-check:
	docker run --rm -v $(DOCKER_RUN_DOC_OPTS) $(ATOMIX_DOCS_BUILD_IMAGE) mdl $(MDL_DIRs) -s md.style.rb

docs-build: docs-clean docs-image
	docker run -it  $(DOCKER_RUN_DOC_OPTS) $(ATOMIX_DOCS_BUILD_IMAGE) docs-manager ./configs/versions.yml ./content/ ./mkdocs.yml ./configs/menu/atomix-menu.js.gotmpl ./configs/menu/atomix-menu.css

docs-clean:
	rm -rf $(SITE_DIR) 
	rm -rf content/master
	rm -rf content/atomix-api
	rm -rf content/v*
	rm -rf content/theme
	rm -rf content/experimental


.PHONY: all docs docs-clean docs-build docs-lint
