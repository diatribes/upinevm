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

clean:
	rm -rf $(ACT)
	rm -rf $(ACT_ARTIFACTS)
	sudo rm -rf ./build/*
	rm -rf ./images/*
	rm -f src/carl-exit/carl-exit
	rm -f src/carl-exit/carl-exit.o
	rm -f src/dumb-init/dumb-init

