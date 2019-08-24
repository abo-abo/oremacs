;;* Personal config
(csetq user-full-name "John Smith")
(csetq user-mail-address "john.smith@gnu.org")

;;* Org mode
(defvar ora-org-basedir
  (expand-file-name "org/" emacs-d)
  "Org dir should contain: gtd.org, ent.org, diary, and wiki/.")

(defun ora-org-expand (file)
  (expand-file-name file ora-org-basedir))
(setq org-agenda-files
      (mapcar #'ora-org-expand '("gtd.org" "ent.org")))

(setq diary-file (ora-org-expand "diary"))
(setq org-agenda-include-diary t)

;; org-mode wiki
(use-package plain-org-wiki
  :commands plain-org-wiki plain-org-wiki-helm
  :config
  (setq plain-org-wiki-directory
        (ora-org-expand "wiki/")))

(provide 'personal-init)
