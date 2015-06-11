emacs ?= emacs

BASEDIR := $(shell pwd)

profile:
	$(emacs) -Q -l git/profile-dotemacs/profile-dotemacs.el \
	--eval "(setq profile-dotemacs-file \
        (setq load-file-name \"$(abspath init.el)\"))" \
	-f profile-dotemacs

install: install-git upgrade
	cd $(BASEDIR) && mkdir -p oleh/personal
	yes n | cp -i etc/init-template.el oleh/personal/init.el
	yes n | cp -i etc/ispell_dict oleh/personal/ispell_dict
	yes n | cp -i etc/abbrev_defs oleh/personal/abbrev_defs
	yes n | cp -ri etc/org .
	make run

pull:
	> etc/log
	git pull 2>&1 | tee etc/log
	git submodule init 2>&1 | tee etc/log
	git submodule update 2>&1 | tee etc/log

install-git: pull
	cd git/cedet && make 2>&1 | tee etc/log
	cd git/org-mode && make compile 2>&1 | tee etc/log

upgrade: pull
	$(emacs) -batch -l packages.el 2>&1 | tee etc/log

up: upgrade
	$(emacs) -Q -l init.el

run:
	$(emacs) -Q -l init.el

.PHONY: profile install install-git upgrade run up pull
