app_slug := "${REPLICATED_APP}"
SHELL := /bin/bash -o pipefail

# Generate channel and release notes. We need to do this differently for github actions vs. command line because of how git works differently in GH actions.
ifeq ($(origin GITHUB_ACTIONS), undefined)
release_notes := "CLI release of $(shell git symbolic-ref HEAD) triggered by ${shell git config --global user.name}: $(shell basename $$(git remote get-url origin) .git) [SHA: $(shell git rev-parse HEAD)]"
channel := $(shell git rev-parse --abbrev-ref HEAD)
else
release_notes := "GitHub Action release of ${GITHUB_REF} triggered by ${GITHUB_ACTOR}: [$(shell echo $${GITHUB_SHA::7})](https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA})"
channel := ${GITHUB_BRANCH_NAME}
endif


# If we're on the master channel, translate that to the "Beta" channel
ifeq ($(channel), master)
channel := Beta
endif
#
# If we're on the main channel, translate that to the "Beta" channel
ifeq ($(channel), main)
channel := Beta
endif
#
# If we're on the unstable channel, translate that to the "Unstable" channel
ifeq ($(channel), unstable)
channel := Unstable
endif

# version based on branch/channel
version := $(channel)-$(shell git rev-parse HEAD | head -c7)$(shell git diff --no-ext-diff --quiet --exit-code || echo "-dirty")


.PHONY: deps-vendor-cli
deps-vendor-cli: dist = $(shell echo `uname` | tr '[:upper:]' '[:lower:]')
deps-vendor-cli: cli_version = ""
deps-vendor-cli: cli_version = $(shell [[ -x deps/replicated ]] && deps/replicated version | grep version | head -n1 | cut -d: -f2 | tr -d , )

deps-vendor-cli:
	@if [[ -n "$(cli_version)" ]]; then \
	  echo "CLI version $(cli_version) already downloaded, to download a newer version, run 'make upgrade-cli'"; \
	  exit 0; \
	else \
	  echo '-> Downloading Replicated CLI to ./deps '; \
	  mkdir -p deps/; \
	  curl -s https://api.github.com/repos/replicatedhq/replicated/releases/latest \
	  | grep "browser_download_url.*$(dist)_amd64.tar.gz" \
	  | cut -d : -f 2,3 \
	  | tr -d \" \
	  | xargs curl -L \
	  | tar xvz -C deps; \
	fi

.PHONY: upgrade-cli
upgrade-cli:
	rm -rf deps
	@$(MAKE) deps-vendor-cli


.PHONY: check-api-token
check-api-token:
	@if [ -z "${REPLICATED_API_TOKEN}" ]; then echo "Missing REPLICATED_API_TOKEN"; exit 1; fi

.PHONY: check-app
check-app:
	@if [ -z "$(app_slug)" ]; then echo "Missing REPLICATED_APP"; exit 1; fi

.PHONY: lint
lint: check-api-token check-app deps-vendor-cli
	deps/replicated release lint --app $(app_slug) --yaml-dir manifests

.PHONY: list-releases
list-releases: check-api-token check-app deps-vendor-cli
	deps/replicated release ls --app $(app_slug)

.PHONY: release
release: check-api-token check-app deps-vendor-cli lint
	deps/replicated release create \
		--app $(app_slug) \
		--yaml-dir manifests \
		--promote $(channel) \
		--version $(version) \
		--release-notes $(release_notes) \
		--ensure-channel

.PHONY: kurl
kurl: check-api-token check-app deps-vendor-cli lint
	deps/replicated installer create \
		--app ${app_slug} \
		--auto -y
