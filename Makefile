SHELL := /bin/sh
.SHELLFLAGS := -ec

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

GITHUB_TOKEN := $(shell gh auth token)
ACT := ./bin/act
ACTCMD := $(ACT)
#  -s GITHUB_TOKEN=$(GITHUB_TOKEN)
ACT_URL := https://raw.githubusercontent.com/nektos/act/master/install.sh
# ACT_ARTIFACTS := /tmp/act_artifacts/1
# TIMESTAMP := $(shell date +%Y%m%d%H%M%S)
TIMESTAMP := 'v0.1.0'

all: build

.PHONY: all clean build

$(ACT):
	if [ ! -f $(ACT) ]; then curl --proto '=https' --tlsv1.2 -sSf ${ACT_URL} | bash; fi


ci: $(ACT)
	$(ACTCMD)

build:
	./build.sh

boot:
	./scripts/boot.sh

menuconfig:
	./scripts/menuconfig.sh

release:
	git tag -d $(TIMESTAMP) || true
	git push origin :refs/tags/$(TIMESTAMP) || true
	git commit --allow-empty -m "Build $(TIMESTAMP)"
	git tag -a $(TIMESTAMP) -m "Release Tag $(TIMESTAMP)"
	git push origin $(TIMESTAMP)
	# gh release create $(TIMESTAMP) -t $(TIMESTAMP) -n "Release $(TIMESTAMP)"

clean:
	rm -rf $(ACT)
	rm -rf $(ACT_ARTIFACTS)
	sudo rm -rf ./build/*
	rm -rf ./images/*
	rm -f src/carl-exit/carl-exit
	rm -f src/carl-exit/carl-exit.o
	rm -f src/dumb-init/dumb-init

