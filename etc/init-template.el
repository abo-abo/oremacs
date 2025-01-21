;;* Personal config
(csetq user-full-name "John Smith")
(csetq user-mail-address "john.smith@gnu.org")

;;* Org mode
(defvar ora-org-basedir
  (expand-file-name "org/" emacs-d)
  "Org dir should contain: gtd.org, inbox.org")

(defun ora-org-expand (file)
  (expand-file-name file ora-org-basedir))
(setq org-agenda-files
      (mapcar #'ora-org-expand '("gtd.org" "inbox.org")))


(provide 'personal-init)
