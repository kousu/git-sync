
# these Makefiles use this trick which allows them to run independently
# OR be included in parents: by each picking up their own path and then prefixing
# all their targets with it, everything stays coherent.
GITSYNC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SYSTEM_PREFIX ?= /usr/local
PREFIX ?= $(if $(filter 0,$(shell id -u)),$(SYSTEM_PREFIX),$(HOME)/.local)

include docs/Makefile
include contrib/Makefile

.PHONY: all
all: docs

.PHONY: install
install: git-sync docs
	install -d $(PREFIX)/bin
	install -m 755 git-sync $(PREFIX)/bin/git-sync
	install -d $(PREFIX)/share/man/man1/
	install -m 644 docs/man1/git-sync.1 $(PREFIX)/share/man/man1/

.PHONY: clean
clean:
	git clean -Xfd $(GITSYNC_DIR)

.PHONY: test
