;;; oremacs
;;* Base directory
(defvar emacs-d
  (file-name-directory
   (file-chase-links load-file-name))
  "The giant turtle on which the world rests.")
(setq package-user-dir
      (expand-file-name "elpa" emacs-d))
(package-initialize)
(let ((emacs-git (expand-file-name "git/" emacs-d)))
  (mapc (lambda (x)
          (add-to-list 'load-path (expand-file-name x emacs-git)))
        (delete ".." (directory-files emacs-git))))
(add-to-list 'load-path (expand-file-name "git/org-mode/lisp/" emacs-d))
(add-to-list 'load-path emacs-d)
(add-to-list 'load-path (expand-file-name "modes/" emacs-d))
(add-to-list 'load-path (expand-file-name "personal/" emacs-d))
;; (add-to-list 'load-path (expand-file-name "git/cedet/lisp/cedet/" emacs-d))
(setq enable-local-variables :safe)
;;* Theme
(if (display-graphic-p)
    (require 'eclipse-theme)
  (require 'eclipse-theme))
;;** Font
(condition-case nil
    (set-frame-font "DejaVu Sans Mono")
  (error
   (set-frame-font "Lucida Sans Typewriter")))
(set-face-attribute 'default (selected-frame) :height 113)
;; ;;* Customize
(defmacro csetq (variable value)
  `(funcall (or (get ',variable 'custom-set) 'set-default) ',variable ,value))
;;** decorations
(csetq tool-bar-mode nil)
(csetq menu-bar-mode nil)
(csetq scroll-bar-mode nil)
(csetq inhibit-startup-screen t)
(csetq initial-scratch-message "")
(setq text-quoting-style 'grave)
;;** navigation within buffer
(csetq next-screen-context-lines 5)
(csetq recenter-positions '(top middle bottom))
;;** finding files
(csetq vc-follow-symlinks t)
(csetq find-file-suppress-same-file-warnings t)
(csetq read-file-name-completion-ignore-case t)
(csetq read-buffer-completion-ignore-case t)
(prefer-coding-system 'utf-8)
;;** minibuffer interaction
(csetq enable-recursive-minibuffers t)
(setq minibuffer-message-timeout 1)
(minibuffer-depth-indicate-mode 1)
(csetq read-quoted-char-radix 16)
;;** editor behavior
(csetq default-input-method "ukrainian-computer")
(csetq indent-tabs-mode nil)
(csetq truncate-lines t)
(setq ring-bell-function 'ignore)
(csetq highlight-nonselected-windows nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq kill-buffer-query-functions nil)
(add-hook 'server-switch-hook 'raise-frame)
(defadvice set-window-dedicated-p (around no-dedicated-windows activate))
(remove-hook 'post-self-insert-hook 'blink-paren-post-self-insert-function)
(csetq eval-expression-print-length nil)
(csetq eval-expression-print-level nil)
(setq print-gensym nil)
(setq print-circle nil)
(setq byte-compile--use-old-handlers nil)
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737
(setq x-selection-timeout 10)
;; improves copying from a ssh -X Emacs.
(setq x-selection-timeout 100)
(csetq lpr-command "gtklp")
;;** internals
(csetq gc-cons-threshold (* 10 1024 1024))
(csetq ad-redefinition-action 'accept)
;; isn't needed in 24.5
(setq cache-long-scans t)
;;** time display
(csetq display-time-24hr-format t)
(csetq display-time-default-load-average nil)
(csetq display-time-format "")
;;** email
(csetq send-mail-function 'smtpmail-send-it)
(csetq smtpmail-auth-credendials (expand-file-name "~/.authinfo"))
(csetq smtpmail-smtp-server "smtp.gmail.com")
(csetq smtpmail-smtp-service 587)
;;** Rest
(csetq browse-url-browser-function 'browse-url-firefox)
(csetq browse-url-firefox-program "firefox")
;;*** Backups
(setq backup-by-copying t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions t)
(setq version-control t)
(setq create-lockfiles nil)
;;* Bootstrap
;;** autoloads
(load (concat emacs-d "loaddefs.el") nil t)
(load (concat emacs-d "personal/loaddefs.el") t t)
;;** enable features
(mapc (lambda (x) (put x 'disabled nil))
      '(erase-buffer upcase-region downcase-region
        dired-find-alternate-file narrow-to-region))
;;** package.el
(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")
        ;; ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))
(setq package-pinned-packages '((yasnippet . "gnu")))
(require 'use-package)
;;* Modes
;;** global minor modes
(global-auto-revert-mode 1)
(when (fboundp 'global-eldoc-mode) (global-eldoc-mode -1))
(show-paren-mode 1)
(winner-mode 1)
(require 'smex)
(use-package recentf
    :config
  (setq recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG" "github.*txt$"
                          ".*png$" ".*cache$"))
  (setq recentf-max-saved-items 60))
(eval-after-load 'xref
  '(progn
    (setq xref-pulse-on-jump nil)
    (setq xref-after-return-hook nil)))
(add-hook 'ido-setup-hook 'ora-ido-hook)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(require 'ora-ivy)
(ivy-mode 1)
(setq hippie-expand-verbose nil)
(blink-cursor-mode -1)
(add-to-list 'auto-mode-alist '("\\.tex\\'" . TeX-latex-mode))
(add-to-list 'auto-mode-alist '("\\.\\(?:a\\|so\\)\\'" . elf-mode))
(add-to-list 'auto-mode-alist '("\\.m\\'" . matlab-mode))
(autoload 'matlab-mode "matlab")
(autoload 'matlab-shell "matlab" nil t)
(autoload 'mu4e "ora-mu4e")
(add-to-list 'auto-mode-alist '("\\.cache\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.\\(h\\|inl\\)\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\(stack\\(exchange\\|overflow\\)\\|superuser\\|askubuntu\\|reddit\\|github\\)\\.com[a-z-._0-9]+\\.txt" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.org_archive\\'" . org-mode))
;;** major modes
(use-package cmake-mode
    :mode "CMakeLists\\.txt\\'")
(use-package clojure-mode
    :mode ("\\.clj\\'" . clojure-mode))
(use-package eltex
    :mode ("\\.elt\\'" . eltex-mode))
(use-package j-mode
    :mode ("\\.j\\'" . j-mode))
(use-package octave
    :interpreter ("octave" . octave-mode))
;;* Use Package
;;** expansion
(use-package tiny
    :commands tiny-expand)
(use-package yasnippet
    :diminish yas-minor-mode
    :config
    (progn
      (setq yas-after-exit-snippet-hook '((lambda () (yas-global-mode -1))))
      (setq yas-fallback-behavior 'return-nil)
      (setq yas-triggers-in-field t)
      (setq yas-verbosity 0)
      (setq yas-snippet-dirs (list (concat emacs-d "snippets/")))
      (define-key yas-minor-mode-map [(tab)] nil)
      (define-key yas-minor-mode-map (kbd "TAB") nil)))
(use-package auto-yasnippet
    :commands aya-create aya-open-line)
(use-package abel)
(use-package iedit
    :commands iedit-mode
    :config (progn
              (setq iedit-log-level 0)
              (define-key iedit-mode-keymap "\C-h" nil)
              (define-key iedit-lib-keymap "\C-s" 'iedit-next-occurrence)
              (define-key iedit-lib-keymap "\C-r" 'iedit-prev-occurrence))
    :init (setq iedit-toggle-key-default nil))
;;** completion
(use-package headlong
    :defer t)
(use-package auto-complete
    :commands auto-complete-mode
    :config
    (progn
      (require 'auto-complete-config)
      (setq ac-delay 0.4)
      (define-key ac-complete-mode-map "\C-j" 'newline-and-indent)
      (define-key ac-complete-mode-map [return] nil)))
(require 'ora-company)
;;** keys
(use-package centimacro
    :commands centi-assign)
(require 'keys)
;;** appearance
(when (image-type-available-p 'xpm)
  (use-package powerline
      :config
    (setq powerline-display-buffer-size nil)
    (setq powerline-display-mule-info nil)
    (setq powerline-display-hud nil)
    (when (display-graphic-p)
      (powerline-default-theme)
      (remove-hook 'focus-out-hook 'powerline-unset-selected-window))))
(use-package uniquify
    :init
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator "/")
  (setq uniquify-ignore-buffers-re "^\\*"))
;;** bookmarks
(require 'bookmark)
(setq bookmark-completion-ignore-case nil)
(bookmark-maybe-load-default-file)
;;** windows
(require 'ora-avy)
;;** rest
(require 'hydra)
(setq hydra--work-around-dedicated nil)
(hydra-add-font-lock)
(require 'hooks)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (lispy-flet (process-list ()) ad-do-it))
(defadvice custom-theme-load-confirm (around no-query-safe-thme activate)
  t)
(use-package dired
    :commands dired
    :init
    (setq dired-listing-switches
          "-laGh1v --group-directories-first"))
(use-package dired-x
    :commands dired-jump)
(use-package elfeed
    :commands elfeed)
(use-package helm-j-cheatsheet
    :commands helm-j-cheatsheet)
(use-package helm-make
    :commands (helm-make helm-make-projectile)
    :init (defalias 'hm 'helm-make)
    :config (setq helm-make-completion-method 'ivy))
(use-package ispell
    :config
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US,nl_NL")
  (setq ispell-personal-dictionary
        (concat emacs-d "personal/ispell_dict"))
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,nl_NL"))
(setq abbrev-file-name
      (concat emacs-d "personal/abbrev_defs"))
(use-package flyspell
    :commands flyspell-mode
    :config
    (progn
      (define-key flyspell-mode-map [(control ?\,)] nil)
      (define-key flyspell-mode-map [(control ?\;)] nil)
      (define-key flyspell-mode-map (kbd "C-.") nil)
      (define-key flyspell-mode-map (kbd "C-M-i") nil)
      (setq flyspell-auto-correct-binding (kbd "C-M-;"))))
(use-package projectile
    :diminish projectile-mode
    :init
    (setq projectile-mode-line nil)
    (projectile-global-mode)
    (setq projectile-project-root-files-bottom-up
          '(".git" ".projectile"))
    (setq projectile-completion-system 'ivy)
    (setq projectile-indexing-method 'alien)
    (setq projectile-enable-caching nil)
    (setq projectile-verbose nil)
    (setq projectile-do-log nil)
    (setq projectile-switch-project-action
          (lambda ()
            (dired (projectile-project-root)))))
(use-package find-file-in-project
    :commands find-file-in-project)
(use-package magit
    :commands magit-status
    :config
    (progn
      (ignore-errors
        (diminish 'magit-auto-revert-mode))
      (setq magit-completing-read-function 'ivy-completing-read)
      (setq magit-item-highlight-face 'bold)
      (setq magit-repo-dirs-depth 1)
      (setq magit-repo-dirs
            (mapcar
             (lambda (dir)
               (substring dir 0 -1))
             (cl-remove-if-not
              (lambda (project)
                (unless (file-remote-p project)
                  (file-directory-p (concat project "/.git/"))))
              (projectile-relevant-known-projects))))))
(use-package ace-link
    :config (ace-link-setup-default))
(use-package compile
    :diminish compilation-in-progress
    :config
    (setq compilation-ask-about-save nil)
    (setq compilation-scroll-output 'next-error)
    (setq compilation-skip-threshold 2))
(ace-popup-menu-mode)
(use-package htmlize
    :commands htmlize-buffer)
(lispy-mode)
(require 'personal-init nil t)
(unless (bound-and-true-p ora-barebones)
  (run-with-idle-timer
   3 nil
   (lambda () (require 'ora-org)))
  (require 'define-word)
  (use-package slime
      :commands slime
      :init
      (require 'slime-autoloads)
      (setq slime-contribs '(slime-fancy))
      (setq inferior-lisp-program "/usr/bin/sbcl")))
(use-package elf-mode
    :commands elf-mode
    :init
    (add-to-list 'magic-mode-alist (cons "ELF" 'elf-mode)))
(require 'server)
(or (server-running-p) (server-start))
