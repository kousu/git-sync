SYSTEMD_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SYSTEM_PREFIX ?= /usr/local
PREFIX ?= $(if $(filter 0,$(shell id -u)),$(SYSTEM_PREFIX),$(HOME)/.local)

SYSTEMDS:=git-sync@.service git-sync@.timer user-service-alert@.service
SYSTEMDS:=$(patsubst %,$(SYSTEMD_DIR)%,$(SYSTEMDS))

# systemd is inconsistent because of course it is
SYSTEMD_TARGET ?= $(if $(filter 0,$(shell id -u)),\
    $(PREFIX)/lib/,\
    $(PREFIX)/share)/systemd/user

.PHONY: all
all: $(SYSTEMDS)

# systemd doesn't load /etc/profile so it doesn't pick up my nor probably your ~/.local/bin
# as a workaround, use a template file
# which uses $(PREFIX)
# also, to be nicer, replace $HOME with %h to avoid hard-coding absolute paths into built files
%.service: %.service.in
	sed 's|$$(PREFIX)|$(PREFIX)|g;s|$(HOME)|%h|' $< > $@

.PHONY: install-systemd-units
install-systemd-units: $(SYSTEMDS)
	install -d $(SYSTEMD_TARGET)
	install -m 644 $^ $(SYSTEMD_TARGET)

.PHONY: install-systemd-scripts
install-systemd-scripts: $(SYSTEMD_DIR)/user-service-alert.sh
	install -d $(PREFIX)/bin
	install -m 755 $< $(PREFIX)/bin/

.PHONY: install

.PHONY: install-systemd
install-systemd: install-systemd-units install-systemd-scripts install

.PHONY: clean-systemd
clean-systemd:
	git clean -Xfd $(SYSTEMD_DIR)

.PHONY: clean
clean: clean-systemd
