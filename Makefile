OS = $(shell uname -s)

AWK = awk
CURL = curl
DATE = date
DOCKER = docker
ECHO = echo
GIT = git
HEAD = head
PRINTF = printf
SED = sed

ifeq ($(OS),Darwin)
GREP = ggrep
SORT = gsort
else
GREP = grep
SORT = sort
endif

PUREPROXY_RELEASE ?= $(shell $(CURL) -s https://api.github.com/repos/dex4er/pureproxy/tags | $(GREP) -oE 'name": ".{1,15}",' | $(SED) 's/name\": \"//;s/\",//' | $(SORT) -V -r | $(HEAD) -n1)
ALPINE_TAG ?= $(shell $(DOCKER) run --rm gcr.io/go-containerregistry/crane ls alpine | $(GREP) -P '^[0-9]+\.' | $(SORT) -V -r | $(HEAD) -n1)
PERL_VERSION ?= $(shell $(DOCKER) run --rm alpine:${ALPINE_TAG} apk --no-cache search -x perl | $(GREP) -v ^fetch | $(SED) 's/^perl-//')
VERSION ?= $(PUREPROXY_RELEASE)-alpine-$(ALPINE_TAG)-perl-$(PERL_VERSION)

REVISION ?= $(shell $(GIT) rev-parse HEAD 2>/dev/null)
BUILDDATE ?= $(shell TZ=GMT $(DATE) '+%Y-%m-%dT%R:%S.%03NZ')

IMAGE_NAME ?= pureproxy
LOCAL_REPO ?= localhost:5000/$(IMAGE_NAME)
DOCKER_REPO ?= localhost:5000/$(IMAGE_NAME)

ifeq ($(PROCESSOR_ARCHITECTURE),ARM64)
PLATFORM = linux/arm64
else ifeq ($(shell uname -m),arm64)
PLATFORM = linux/arm64
else ifeq ($(shell uname -m),aarch64)
PLATFORM = linux/arm64
else ifeq ($(findstring ARM64, $(shell uname -s)),ARM64)
PLATFORM = linux/arm64
else
PLATFORM = linux/amd64
endif

.PHONY: help
help:
	@$(ECHO) "$(IMAGE_NAME)"
	@$(ECHO)
	@$(ECHO) Targets:
	@$(AWK) 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9._-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST) | $(SORT)

define print-target
	@$(PRINTF) "Executing target: \033[36m$@\033[0m\n"
endef

.PHONY: all
all: build push
all: ## Build and push.

.PHONY: build
build: ## Build a local image without publishing artifacts.
	$(call print-target)
	$(DOCKER) buildx build --platform=$(PLATFORM) \
	--build-arg ALPINE_TAG=$(ALPINE_TAG) \
	--build-arg PERL_VERSION=$(PERL_VERSION) \
	--build-arg PUREPROXY_RELEASE=$(PUREPROXY_RELEASE) \
	--build-arg VERSION=$(VERSION) \
	--build-arg REVISION=$(REVISION) \
	--build-arg BUILDDATE=$(BUILDDATE) \
	--tag $(LOCAL_REPO) \
	.

.PHONY: push
push: ## Publish to container registry.
	$(call print-target)
	$(DOCKER) tag $(LOCAL_REPO) $(DOCKER_REPO):$(VERSION)-$(subst /,-,$(PLATFORM))
	$(DOCKER) push $(DOCKER_REPO):$(VERSION)-$(subst /,-,$(PLATFORM))

.PHONY: test
test: ## Test local image
	$(call print-target)
	$(DOCKER) run --platform=$(PLATFORM) --rm -t $(LOCAL_REPO) -v | $(GREP) ^PureProxy/

.PHONY: info
info: ## Show information about version
	@echo "Version:           ${VERSION}"
	@echo "Revision:          ${REVISION}"
	@echo "Build date:        ${BUILDDATE}"
