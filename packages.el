;;* packages
(require 'cl-seq)

(defconst emacs-d
  (file-name-directory
   (file-chase-links load-file-name)))

(defconst ora-packages-alist
  '(("clojure"
     cider
     anakondo
     (clojure-semantic :host github :repo "abo-abo/clojure-semantic")
     clj-refactor
     flycheck-clj-kondo
     cljr-ivy)
    ("cpp"
     ccls
     (cc-chainsaw :host github :repo "abo-abo/cc-chainsaw")
     google-c-style
     cmake-mode
     elf-mode
     function-args)
    ("shell"
     bash-completion
     exec-path-from-shell
     vterm
     coterm)
    ("python"
     company-jedi
     jedi
     python-pytest
     pyimport
     (lpy :host github :repo "abo-abo/lpy"))
    ("elisp"
     auto-compile
     package-lint
     (profile-dotemacs :host github :repo "abo-abo/profile-dotemacs")
     use-package
     alert
     async
     request
     (whicher :host github :repo "abo-abo/whicher"))
    ("snippets"
     auto-yasnippet
     yasnippet
     emmet-mode)
    ("email"
     ;; bbdb
     )
    ("docker"
     docker
     docker-tramp
     dockerfile-mode)
    ("org"
     (orly :host github :repo "abo-abo/orly")
     orca
     org-bullets
     org-download
     org-parser
     org-present
     visual-fill-column
     (org-fu :host github :repo "abo-abo/org-fu")
     (org-pomodoro :host github :repo "abo-abo/org-pomodoro")
     org-ref
     ox-gfm
     ;; org-roam
     pamparam
     gtk-pomodoro-indicator
     ukrainian-holidays
     netherlands-holidays
     htmlize
     worf)
    ("avy"
     avy
     ace-link
     ace-popup-menu
     ace-window)
    ("look"
     all-the-icons
     eclipse-theme
     diminish
     powerline
     rainbow-mode
     which-key
     command-log-mode
     unicode-fonts)
    ("latex"
     auctex
     (eltex :host github :repo "abo-abo/eltex"))
    ("ivy"
     counsel
     flx
     ivy-avy
     ivy-bibtex
     ivy-posframe
     ivy-hydra
     ivy-xref
     ;; (smex :host github :repo "abo-abo/smex")
     smex)
    ("words"
     define-word
     flyspell-correct-ivy
     wucuo)
    ("ide"
     company
     eglot
     flycheck
     lsp-java
     lsp-mode
     lsp-ui
     geiser
     slime
     lispy
     (iedit :host github :repo "abo-abo/iedit")
     multiple-cursors
     helm-make)
    ("dired"
     (dired-guess :host github :repo "abo-abo/dired-guess")
     dired-rsync
     make-it-so
     ready-player)
    ("major-mode"
     abc-mode
     go-mode
     haskell-mode
     rjsx-mode
     rust-mode
     nginx-mode
     markdown-mode
     nov
     yaml-mode)
    ("keys"
     evil
     headlong
     (touchpad :host github :repo "abo-abo/touchpad")
     hydra)
    ("files"
     magit
     forge
     git-link
     find-file-in-project
     projectile
     wgrep
     super-save
     tramp-container)
    ("sql"
     sql-indent
     ejc-sql)
    ("misc"
     elfeed
     pass
     tea-time
     transpose-frame)))

(defconst ora-packages
  (apply #'append (mapcar #'cdr ora-packages-alist))
  "List of packages that I like.")

(let* ((all-pkgs (mapcar
                  (lambda (p) (if (consp p) (car p) p))
                  ora-packages))
       (git-dirs (mapcar
                  #'intern
                  (delete
                   "." (delete
                        ".." (directory-files (expand-file-name "git" emacs-d))))))
       (git-pkgs (cl-intersection git-dirs all-pkgs)))
  (setq straight-built-in-pseudo-packages
        (append
         '(emacs python uniquify dired dired-x cook org)
         (and (memq 'swiper git-dirs)
              '(swiper ivy ivy-hydra lv counsel))
         git-pkgs))
  (setq ora-packages
        (cl-set-difference ora-packages git-pkgs
                           :key (lambda (x) (if (consp x) (car x) x)))))

(defun straight-install-packages (packages)
  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

  (dolist (package packages)
    (straight-use-package package)))

(defun package-install-packages (packages)
  (setq melpa-stable (getenv "MELPA_STABLE"))
  (setq package-user-dir
        (expand-file-name
         (format "~/.elpa/%s/elpa"
                 (concat emacs-version (when melpa-stable "-stable")))))
  (message "installing in %s ...\n" package-user-dir)
  (package-initialize)
  (setq package-archives
        (list (if melpa-stable
                  '("melpa-stable" . "https://stable.melpa.org/packages/")
                '("melpa" . "http://melpa.org/packages/"))
              '("gnu" . "http://elpa.gnu.org/packages/")))
  (package-refresh-contents)

  (dolist (package packages)
    (cond
     ((consp package)
      (message "%S: SKIP" package))
     ((package-installed-p package)
      (message "%S: OK" package))
     (t
      (condition-case nil
          (progn
            (package-install package)
            (message "%S: OK" package))
        (error
         (message "%S: FAIL" package))))))

  (save-window-excursion
    (package-list-packages t)
    (condition-case nil
        (progn
          (package-menu-mark-upgrades)
          (package-menu-execute t))
      (error
       (message "All packages up to date")))))

(if nil
    (straight-install-packages ora-packages)
  (package-install-packages ora-packages))
