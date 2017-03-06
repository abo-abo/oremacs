emacs ?= emacs

BASEDIR := $(shell pwd)

profile:
	$(emacs) -Q -l git/profile-dotemacs/profile-dotemacs.el \
	--eval "(setq profile-dotemacs-file \
        (setq load-file-name \"$(abspath init.el)\"))" \
	-f profile-dotemacs

install: upgrade
	cd git/cedet && make 2>&1 | tee -a ../../etc/log
	cd git/org-mode && make compile 2>&1 | tee -a ../../etc/log
	cd $(BASEDIR) && mkdir -p personal
	yes n | cp -i etc/init-template.el personal/personal-init.el
	yes n | cp -i etc/ispell_dict personal/ispell_dict
	yes n | cp -i etc/abbrev_defs personal/abbrev_defs
	yes n | cp -ri etc/org .
	make run

bare:
	$(emacs) -Q -l etc/bareinit.el


pull:
	echo "-*- mode: compilation -*-" > etc/log
	git pull 2>&1 | tee -a etc/log
	git submodule init 2>&1 | tee -a etc/log
	git submodule update 2>&1 | tee -a etc/log

upgrade: pull
	cd $(BASEDIR) && $(emacs) -batch -l packages.el 2>&1 | tee -a etc/log

up: upgrade
	$(emacs) -Q -l init.el

run:
	$(emacs) -Q -l init.el

.PHONY: profile install install-git upgrade run up pull
