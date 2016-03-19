(defconst emacs-d
  (file-name-directory
   (file-chase-links load-file-name))
  "The giant turtle on which the world rests.")

(setq package-user-dir
      (expand-file-name "elpa" emacs-d))
(package-initialize)
(setq package-archives
      '(("melpa" . "http://melpa.milkbox.net/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))
(package-refresh-contents)

(defconst ora-packages
  '(ac-cider
    ace-link
    ace-window
    ace-popup-menu
    auto-compile
    auto-yasnippet
    auctex
    cmake-mode
    company
    counsel
    define-word
    eclipse-theme
    elfeed
    function-args
    geiser
    google-c-style
    which-key
    headlong
    helm-make
    ido-vertical-mode
    j-mode
    jedi
    lispy
    magit
    make-it-so
    markdown-mode
    netherlands-holidays
    org-bullets
    org-download
    powerline
    projectile
    find-file-in-project
    rainbow-mode
    request
    slime
    smex
    swiper
    ukrainian-holidays
    use-package
    wgrep
    worf
    yaml-mode)
  "List of packages that I like.")

;; install required
(dolist (package ora-packages)
  (unless (package-installed-p package)
    (ignore-errors
      (package-install package))))

;; upgrade installed
(save-window-excursion
  (package-list-packages t)
  (package-menu-mark-upgrades)
  (condition-case nil
      (package-menu-execute t)
    (error
     (package-menu-execute))))
