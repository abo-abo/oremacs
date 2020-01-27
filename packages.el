;;* packages
(defconst ora-packages
  '(ace-link
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
    function-args
    geiser
    (google-c-style :host github :repo "google/styleguide" :branch "gh-pages")
    gtk-pomodoro-indicator
    haskell-mode
    headlong
    helm-make
    hideshowvis
    (htmlize :host github :repo "abo-abo/htmlize")
    (iedit :host github :repo "abo-abo/iedit")
    ivy-hydra
    j-mode
    jedi
    lispy
    lsp-mode
    magit
    make-it-so
    markdown-mode
    netherlands-holidays
    orca
    org-bullets
    org-download
    org-parser
    (org-pomodoro :host github :repo "abo-abo/org-pomodoro")
    projectile
    plain-org-wiki
    posframe
    powerline
    rainbow-mode
    request
    rust-mode
    slime
    (smex :host github :repo "abo-abo/smex")
    swiper
    tea-time
    transpose-frame
    ukrainian-holidays
    unicode-fonts
    use-package
    wgrep
    which-key
    worf
    yaml-mode
    yasnippet)
  "List of packages that I like.")

(setq straight-built-in-pseudo-packages
      '(emacs python uniquify dired dired-x magit cook
        ivy swiper counsel lispy avy ace-window ace-link auto-yasnippet elf-mode
        eltex tiny centimacro helm-j-cheatsheet pamparam
        define-word eclipse-theme function-args gtk-pomodoro-indicator headlong
        ivy-hydra make-it-so orca org-download plain-org-wiki worf))

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
