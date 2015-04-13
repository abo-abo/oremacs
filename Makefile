emacs ?= emacs

BASEDIR := $(shell pwd)

profile:
	$(emacs) -Q -l git/profile-dotemacs/profile-dotemacs.el \
	--eval "(setq profile-dotemacs-file \
        (setq load-file-name \"$(abspath init.el)\"))" \
	-f profile-dotemacs

install: install-git upgrade run
	cd $(BASEDIR) && mkdir -p oleh/personal
	test -d "oleh/personal" || mkdir -p "oleh/personal"
	yes n | cp -i etc/init-template.el oleh/personal/init.el
	yes n | cp -i etc/ispell_dict oleh/personal/ispell_dict
	yes n | cp -i etc/abbrev_defs oleh/personal/abbrev_defs

pull:
	git pull
	git submodule init
	git submodule update

install-git: pull
	cd git/cedet && make
	cd git/org-mode && make compile

upgrade: pull
	$(emacs) -batch -l packages.el

up: upgrade
	$(emacs) -Q -l init.el

run:
	$(emacs) -Q -l init.el

.PHONY: profile install install-git upgrade run up pull
