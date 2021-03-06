export CGO_ENABLED=0
export GO111MODULE=on

DOCS_MANAGER_BUILD_VERSION := stable
DOCS_MANAGER_TEST_VERSION := latest

.PHONY: all docs docs-serve
docs: # @HELP Build documentation site
docs: clean deps build-docs-manager linters images
	make -C ./docs docs
docs-serve: # @HELP Serve the documentation site localy.
docs-serve: deps build-docs-manager images
	make -C ./docs docs-serve


build-docs-manager: # @HELP build docs-manager application
	go build -o build/_output/docs-manager ./cmd/docs-manager


atomix-docs-base-image:
	docker build . -f build/base/Dockerfile \
        		--build-arg DOCS_MANAGER_BUILD_VERSION=${DOCS_MANAGER_BUILD_VERSION} \
        		-t atomix/atomix-docs-base:${DOCS_MANAGER_TEST_VERSION}

atomix-docs-manager-image:
	@go mod vendor
	docker build . -f build/docs-manager/Dockerfile \
    		--build-arg DOCS_MANAGER_BUILD_VERSION=${DOCS_MANAGER_BUILD_VERSION} \
    		-t atomix/atomix-docs-manager:${DOCS_MANAGER_TEST_VERSION}
	@rm -rf vendor


images: # @HELP build docs-manager application image
images: atomix-docs-manager-image


linters: # @HELP examines Go source code and reports coding problems
	golangci-lint run


deps: # @HELP ensure that the required dependencies are in place
	go build -v ./...
	bash -c "diff -u <(echo -n) <(git diff go.mod)"
	bash -c "diff -u <(echo -n) <(git diff go.sum)"


clean: # @HELP remove all the build artifacts
	make -C ./docs docs-clean
	rm -rf ./build/_output ./vendor

help:
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST) \
    | sort \
    | awk ' \
        BEGIN {FS = ": *# *@HELP"}; \
        {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}; \
    '
