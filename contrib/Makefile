CONTRIB_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SYSTEM_PREFIX ?= /usr/local
PREFIX ?= $(if $(filter 0,$(shell id -u)),$(SYSTEM_PREFIX),$(HOME)/.local)

include $(CONTRIB_DIR)systemd/Makefile

CONTRIBS:=$(SYSTEMDS)

### the dependencies are backwards here
# the deeper Makefiles should include the higher ones
# because that's the direction of depedence
# ..but then you can't 'make install' from the top and get everything nicely.

.PHONY: all
all: $(CONTRIBS)

.PHONY: clean-contrib
clean-contrib:
	git clean -Xfd $(CONTRIB_DIR)

.PHONY: clean
clean: clean-contrib

.PHONY: install-contrib
install-contrib: $(CONTRIB_DIR)git-sync-inotify
	install -d $(PREFIX)/bin
	install -m 755 $< $(PREFIX)/bin/

install-contrib: install-systemd
