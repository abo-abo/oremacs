;;* packages
(require 'cl-seq)

(defconst emacs-d
  (file-name-directory
   (file-chase-links load-file-name)))

(defconst ora-packages
  '(avy
    ace-link
    ace-popup-menu
    ace-window
    async
    alert
    auctex
    auto-compile
    auto-yasnippet
    bash-completion
    bbdb
    elf-mode
    elfeed
    (eltex :host github :repo "abo-abo/eltex")
    eglot
    evil
    exec-path-from-shell
    cmake-mode
    cider
    command-log-mode
    company
    company-jedi
    counsel
    (counsel-keepassxc :host github :repo "tangxinfa/counsel-keepassxc")
    ccls
    (clojure-semantic :host github :repo "abo-abo/clojure-semantic")
    define-word
    diminish
    dired-rsync
    dockerfile-mode
    docker
    docker-tramp
    eclipse-theme
    find-file-in-project
    flycheck
    flx
    function-args
    geiser
    (google-c-style :host github :repo "google/styleguide" :branch "gh-pages")
    gtk-pomodoro-indicator
    haskell-mode
    headlong
    helm-make
    (htmlize :host github :repo "abo-abo/htmlize")
    hydra
    (iedit :host github :repo "abo-abo/iedit")
    ivy-hydra
    j-mode
    jedi
    lispy
    lsp-mode
    lsp-java
    magit
    make-it-so
    markdown-mode
    multiple-cursors
    netherlands-holidays
    orca
    org-bullets
    org-download
    org-parser
    (org-pomodoro :host github :repo "abo-abo/org-pomodoro")
    package-lint
    projectile
    plain-org-wiki
    posframe
    powerline
    rainbow-mode
    request
    rust-mode
    slime
    (smex :host github :repo "abo-abo/smex")
    tea-time
    transpose-frame
    ukrainian-holidays
    unicode-fonts
    use-package
    wgrep
    which-key
    worf
    yaml-mode
    yasnippet
    (lpy :host github :repo "abo-abo/lpy"))
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
         '(emacs python uniquify dired dired-x magit cook)
         (and (memq 'swiper git-dirs)
              '(swiper ivy ivy-hydra lv counsel))
         git-pkgs))
  (setq ora-packages
        (cl-set-difference ora-packages git-pkgs
                           :key (lambda (x) (if (consp x) (car x) x)))))

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

(dolist (package ora-packages)
  (straight-use-package package))
