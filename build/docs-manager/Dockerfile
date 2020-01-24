ARG DOCS_MANAGER_BUILD_VERSION=stable

FROM onosproject/golang-build:$DOCS_MANAGER_BUILD_VERSION AS build
ENV GO111MODULE=on
COPY . /go/src/github.com/atomix/docs
RUN cd /go/src/github.com/atomix/docs && GOFLAGS=-mod=vendor make build-docs-manager

FROM atomix/atomix-docs-base:latest

COPY --from=build /go/src/github.com/atomix/docs/build/_output/docs-manager /usr/local/bin/docs-manager

