;;; oremacs
;;* Base directory and load-path
(defvar emacs-d
  (file-name-directory
   (file-chase-links load-file-name))
  "The giant turtle on which the world rests.")
(setq ora-startup-time-tic (current-time))
(setq byte-compile-warnings '(cl-functions))
(let ((emacs-git (expand-file-name "git/" emacs-d)))
  (mapc (lambda (x)
          (add-to-list 'load-path (expand-file-name x emacs-git)))
        (delete "." (delete ".." (directory-files emacs-git)))))
(add-to-list 'load-path (expand-file-name "git/org-mode/lisp/" emacs-d))
(add-to-list 'load-path emacs-d)
(add-to-list 'load-path (expand-file-name "modes/" emacs-d))
(add-to-list 'load-path (expand-file-name "personal/" emacs-d))
(add-to-list 'load-path (expand-file-name "personal/modes/" emacs-d))
(setq enable-local-variables :all)
(require 'pora-base nil t)
;;* straight.el
(if t
    (require 'ora-straight)
  (setq package-user-dir (expand-file-name "elpa" emacs-d))
  (when (< emacs-major-version 27)
    (package-initialize)))

(defmacro csetq (variable value)
  `(funcall (or (get ',variable 'custom-set) 'set-default) ',variable ,value))
(defun ora-advice-add (&rest args)
  (when (fboundp 'advice-add)
    (apply #'advice-add args)))

(require 'ora-visuals)

;;* Customize
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
(csetq load-prefer-newer t)
(csetq indent-tabs-mode nil)
(csetq ring-bell-function 'ignore)
(csetq highlight-nonselected-windows nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq kill-buffer-query-functions nil)
(add-hook 'server-switch-hook 'raise-frame)
(defadvice set-window-dedicated-p (around no-dedicated-windows activate))
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737
(setq x-selection-timeout 10)
;; improves copying from a ssh -X Emacs.
(setq x-selection-timeout 100)
(require 'whicher)
(csetq lpr-command (whicher "gtklp"))
;;** internals
(csetq gc-cons-threshold (* 10 1024 1024))
(csetq ad-redefinition-action 'accept)

;;** Rest
(csetq browse-url-browser-function 'browse-url-firefox)
(csetq browse-url-firefox-program (whicher "firefox"))
;;*** Backups
(setq backup-by-copying t)
(setq backup-directory-alist `(
                               (,tramp-file-name-regexp . "/tmp/")
                               ("." . "~/.emacs.d/backups")))
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
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))
(setq package-pinned-packages '((yasnippet . "gnu")))
(let ((file-name-handler-alist nil))
  (require 'eclipse-theme)
  (load-theme 'eclipse t)
  (require 'use-package)
  (require 'smex)
  (require 'warnings))
;;* Modes
;;** global minor modes
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(winner-mode 1)
(remove-hook 'minibuffer-setup-hook 'winner-save-unconditionally)
(use-package recentf
  :config
  (setq recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG" "github.*txt$"
                          "[0-9a-f]\\{32\\}-[0-9a-f]\\{32\\}\\.org"
                          ".*png$" ".*cache$"))
  (setq recentf-max-saved-items 600))
(eval-after-load 'xref
  '(progn
    (setq xref-pulse-on-jump nil)
    (setq xref-after-return-hook nil)))
(use-package diminish)
(require 'ora-ivy)
(setq hippie-expand-verbose nil)
(blink-cursor-mode -1)
(require 'ora-auto)
(autoload 'mu4e "ora-mu4e")
(autoload 'mu4e-compose-new "ora-mu4e")
(autoload 'pass "ora-pass")
(eval-after-load 'slime '(require 'ora-lisp))

;;** major modes
(use-package cmake-mode
  :mode "CMakeLists\\.txt\\'")
(use-package clojure-mode
  :mode ("\\.clj\\'" . clojure-mode))
(use-package eltex
  :mode ("\\.elt\\'" . eltex-mode))
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
    (setq yas-fallback-behavior 'return-nil)
    (setq yas-triggers-in-field t)
    (setq yas-verbosity 0)
    (setq yas-snippet-dirs (list (concat emacs-d "snippets/")))
    (define-key yas-minor-mode-map [(tab)] nil)
    (define-key yas-minor-mode-map (kbd "TAB") nil)
    (add-to-list 'warning-suppress-types '(yasnippet backquote-change))))
(use-package auto-yasnippet
  :commands aya-create aya-open-line)
(use-package iedit
  :commands iedit-mode
  :config (progn
            (setq iedit-log-level 0)
            (define-key iedit-mode-keymap "\C-h" nil)
            (define-key iedit-lib-keymap "\C-s" 'iedit-next-occurrence)
            (define-key iedit-lib-keymap "\C-r" 'iedit-prev-occurrence))
  :init (setq iedit-toggle-key-default nil))
;;** completion
(use-package auto-complete
  :commands auto-complete-mode
  :config
  (progn
    (require 'auto-complete-config)
    (setq ac-delay 0.4)
    (define-key ac-complete-mode-map "\C-j" 'newline-and-indent)
    (define-key ac-complete-mode-map [return] nil)
    (define-key ac-complete-mode-map (kbd "M-TAB") nil)))
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
    (setq powerline-display-mule-info t)
    (setq powerline-display-hud nil)
    (when (display-graphic-p)
      (powerline-default-theme)
      (remove-hook 'focus-out-hook 'powerline-unset-selected-window))))
(use-package uniquify
  :init
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator "/")
  (setq uniquify-ignore-buffers-re "^\\*"))
;;** rest
(require 'ora-avy)
(require 'ora-bookmark)
(require 'ora-hydra)
(require 'hooks)
(require 'ora-elisp)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (lispy-flet (process-list ()) ad-do-it))
(setq confirm-kill-processes nil)
(defadvice custom-theme-load-confirm (around no-query-safe-thme activate)
  t)
(use-package dired
  :commands dired
  :config (setq dired-listing-switches
                (if (memq system-type '(windows-nt darwin))
                    "-alh"
                  "-laGh1v --group-directories-first")))
(use-package helm-j-cheatsheet
  :commands helm-j-cheatsheet)
(use-package pamparam
  :commands pamparam-drill)
(use-package helm-make
  :commands (helm-make helm-make-projectile)
  :config (setq helm-make-completion-method 'ivy))
(setq abbrev-file-name (expand-file-name "personal/lists/abbrev_defs" emacs-d))
(use-package flyspell
  :commands flyspell-mode
  :config (require 'ora-flyspell))
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
          (dired (projectile-project-root))))
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))
(use-package find-file-in-project
  :commands find-file-in-project)
(require 'pora-magit nil t)
(use-package compile
  :diminish compilation-in-progress
  :config
  (setq compilation-ask-about-save nil)
  (assq-delete-all 'compilation-in-progress mode-line-modes))
(use-package htmlize
  :commands htmlize-buffer)

(use-package super-save
  :diminish super-save-mode
  :config
  (setq super-save-auto-save-when-idle t)
  ;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (super-save-mode))

(eval-after-load 'lsp
  '(require 'ora-lsp))

(eval-after-load 'flycheck
  '(progn
     (setq flycheck-check-syntax-automatically '(save mode-enabled))))
(require 'ora-pass)

(lispy-mode)
(require 'personal-init nil t)
(unless (bound-and-true-p ora-barebones)
  (run-with-idle-timer
   3 nil
   (lambda () (require 'ora-org))))
(add-to-list 'warning-suppress-types '(undo discard-info))
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(ora-advice-add 'semantic-idle-scheduler-function :around #'ignore)
(require 'server)
(setq ora-startup-time-toc (current-time))
(or (server-running-p) (server-start))
(setq ora-startup-time-seconds
      (time-to-seconds (time-subtract ora-startup-time-toc ora-startup-time-tic)))
