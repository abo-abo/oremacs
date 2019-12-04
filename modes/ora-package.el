(defconst emacs-d
  (file-name-directory
   (file-chase-links load-file-name))
  "The giant turtle on which the world rests.")
(message "emacs-d: %S" emacs-d)


;; (setq package-user-dir
;;       (expand-file-name "elpa" emacs-d))
;; (package-initialize)
;; (setq package-archives
;;       '(("melpa" . "https://melpa.org/packages/")
;;         ("gnu" . "http://elpa.gnu.org/packages/")))
;; (package-refresh-contents)

;; (dolist (package ora-packages)
;;   (unless (package-installed-p package)
;;     (ignore-errors
;;       (package-install package))))

;; (let ((org-version '(9 2 6)))
;;   (unless (file-exists-p
;;            (concat
;;             "elpa/org-"
;;             (mapconcat #'number-to-string org-version ".")))
;;     (package-install
;;      (package-desc-create
;;       :name 'org
;;       :version org-version
;;       :archive "gnu"
;;       :kind 'tar))))

;; ;; upgrade installed
;; (save-window-excursion
;;   (package-list-packages t)
;;   (package-menu-mark-upgrades)
;;   (condition-case nil
;;       (package-menu-execute t)
;;     (error
;;      (package-menu-execute))))
