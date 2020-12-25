;;* packages
(require 'cl-seq)

(defconst emacs-d
  (file-name-directory
   (file-chase-links load-file-name)))

(defconst ora-packages
  ;; (cl-sort . #'string< :key (lambda (x) (symbol-name (if (consp x) (car x) x))))
  '((orly :host github :repo "abo-abo/orly")
    abc-mode
    ace-link
    ace-popup-menu
    ace-window
    alert
    all-the-icons
    anakondo
    async
    auctex
    auto-compile
    auto-yasnippet
    avy
    bash-completion
    ;; bbdb
    ccls
    cider
    (clojure-semantic :host github :repo "abo-abo/clojure-semantic")
    cmake-mode
    command-log-mode
    company
    company-jedi
    counsel
    (counsel-keepassxc :host github :repo "tangxinfa/counsel-keepassxc")
    define-word
    diminish
    (dired-guess :host github :repo "abo-abo/dired-guess")
    dired-rsync
    docker
    docker-tramp
    dockerfile-mode
    eclipse-theme
    eglot
    elf-mode
    elfeed
    (eltex :host github :repo "abo-abo/eltex")
    evil
    exec-path-from-shell
    find-file-in-project
    flx
    flycheck
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
    ivy-avy
    ivy-posframe
    ivy-hydra
    j-mode
    jedi
    lispy
    (lpy :host github :repo "abo-abo/lpy")
    lsp-java
    lsp-mode
    magit
    make-it-so
    markdown-mode
    multiple-cursors
    netherlands-holidays
    orca
    org-bullets
    org-download
    org-journal
    org-parser
    (org-pomodoro :host github :repo "abo-abo/org-pomodoro")
    org-roam
    package-lint
    pamparam
    plain-org-wiki
    powerline
    projectile
    rainbow-mode
    request
    rust-mode
    slime
    (smex :host github :repo "abo-abo/smex")
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
    yaml-mode
    yasnippet)
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
;; (save-buffers-kill-emacs)
