DOCS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SYSTEM_PREFIX ?= /usr/local
PREFIX ?= $(if $(filter 0,$(shell id -u)),$(SYSTEM_PREFIX),$(HOME)/.local)

.PHONY: all
all: docs

DOCS:=git-sync.md
DOCS:=$(patsubst %.md,man1/%.1,$(DOCS))
DOCS:=$(patsubst %,$(DOCS_DIR)%,$(DOCS))

.PHONY: docs
docs: $(DOCS)

$(DOCS_DIR)man1/git-sync.1: $(DOCS_DIR)git-sync.md
	mkdir -p $(dir $@)
	go-md2man <$< >$@

.PHONY: clean-docs
clean-docs:
	git clean -Xfd $(DOCS_DIR)

.PHONY: clean
clean: clean-docs
