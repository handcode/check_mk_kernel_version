# Makefile for check_mk pkg dev

.PHONY: install purge package pkg release

# --------------------
# Defines
# --------------------
# check user and decided wether we should execute commands with sudo prefix?
user = $(shell whoami)
PWD ?= $(shell pwd)
OMD_SITE = cfa

ifneq ($(user),root)
$(error You must be root to run this.)
endif

CMK_CHECK_DIR = /omd/sites/$(OMD_SITE)/local/share/check_mk/checks/
CMK_PLUGIN_DIR = /omd/sites/$(OMD_SITE)/local/share/check_mk/agents/plugins/
CMK_PKG_DIR = /omd/sites/$(OMD_SITE)/var/check_mk/packages/
CMK_REL_TMP_DIR = /omd/sites/$(OMD_SITE)/release-tmp

# --------------------
# Targets
# --------------------
default: help

install:   ##@dev install check_mk plugin, optional OMD_SITE=cfa can be overwritten
	test -d $(CMK_CHECK_DIR) && cp checks/kernel_version_compare  $(CMK_CHECK_DIR)
	test -d $(CMK_PLUGIN_DIR) && cp plugins/kernel_version_compare  $(CMK_PLUGIN_DIR)
	test -d $(CMK_PKG_DIR) && cp packages/kernel_version_compare  $(CMK_PKG_DIR)

purge:   ##@dev purge check_mk plugin files, optional OMD_SITE=cfa can be overwritten
	test -f $(CMK_CHECK_DIR)/kernel_version_compare && rm $(CMK_CHECK_DIR)/kernel_version_compare
	test -f $(CMK_PLUGIN_DIR)/kernel_version_compare && rm $(CMK_PLUGIN_DIR)/kernel_version_compare
	test -f $(CMK_PKG_DIR)/kernel_version_compare && rm $(CMK_PKG_DIR)/kernel_version_compare

pkg: ##@pkg alias for package
pkg: package

package: ##@pkg build check_mk package from installed repo files
package: install
	echo "build check_mk package from installed repo files"
	su - $(OMD_SITE) -c 'mkdir -p release-tmp && cd release-tmp && cmk -vP pack kernel_version_compare && pwd'

release: ##@pkg build check_mk package and copy *.mkp file to repo
release: package
	echo "move created package file to repo"
	test -d $(CMK_REL_TMP_DIR) && test -f $(CMK_REL_TMP_DIR)/kernel_version_compare-*.mkp && chown root:root $(CMK_REL_TMP_DIR)/kernel_version_compare-*.mkp && mkdir -p ./releases/ && mv $(CMK_REL_TMP_DIR)/kernel_version_compare-*.mkp ./releases/ && rmdir $(CMK_REL_TMP_DIR)
	echo "DONE, if you wish, please commit created mkp file to repo"
	ls -latr ./releases/*.mkp

# --------------------
# Thanks to dmstr:
# --------------------
# Help based on https://gist.github.com/prwhite/8168133 thanks to @nowox and @prwhite
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
# -----------------------------------
HELP_FUN = \
                %help; \
                while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([\w-]+)\s*:.*\#\#(?:@([\w-]+))?\s(.*)$$/ }; \
                print "\nusage: make [target ...]\n\n"; \
        for (keys %help) { \
                print "$$_:\n"; \
                for (@{$$help{$$_}}) { \
                        $$sep = "." x (25 - length $$_->[0]); \
                        print "  $$_->[0]$$sep$$_->[1]\n"; \
                } \
                print "\n"; }

help:   ##@system show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

