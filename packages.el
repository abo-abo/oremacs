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
     (google-c-style :host github :repo "google/styleguide" :branch "gh-pages")
     cmake-mode
     elf-mode
     function-args)
    ("shell"
     bash-completion
     exec-path-from-shell)
    ("python"
     company-jedi
     jedi
     (lpy :host github :repo "abo-abo/lpy"))
    ("elisp"
     auto-compile
     package-lint)
    ("snippets"
     auto-yasnippet)
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
     (org-fu :host github :repo "abo-abo/org-fu")
     (org-pomodoro :host github :repo "abo-abo/org-pomodoro")
     org-ref
     ;; org-roam
     pamparam
     plain-org-wiki)
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
     rainbow-mode)
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
     (smex :host github :repo "abo-abo/smex"))
    ("words"
     define-word
     flyspell-correct-ivy)
    ("ide"
     eglot
     flycheck
     lsp-java
     lsp-mode
     geiser)
    ("dired"
     (dired-guess :host github :repo "abo-abo/dired-guess")
     dired-rsync)
    ("major-mode"
     abc-mode
     go-mode
     haskell-mode
     rjsx-mode
     rust-mode
     markdown-mode)))

(defconst ora-packages
  (append
   '(alert
     async
     command-log-mode
     company
     elfeed
     evil
     find-file-in-project
     gtk-pomodoro-indicator
     headlong
     helm-make
     (htmlize :host github :repo "abo-abo/htmlize")
     hydra
     (iedit :host github :repo "abo-abo/iedit")
     lispy
     (magit :host github :repo "abo-abo/magit")
     make-it-so
     multiple-cursors
     netherlands-holidays
     pass
     (profile-dotemacs :host github :repo "abo-abo/profile-dotemacs")
     projectile
     request
     slime
     super-save
     tea-time
     (touchpad :host github :repo "abo-abo/touchpad")
     transpose-frame
     ukrainian-holidays
     unicode-fonts
     use-package
     wgrep
     (whicher :host github :repo "abo-abo/whicher")
     which-key
     worf
     wucuo
     yaml-mode
     yasnippet)
   (apply #'append (mapcar #'cdr ora-packages-alist)))
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
         '(emacs python uniquify dired dired-x magit cook org)
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

(straight-install-packages ora-packages)
