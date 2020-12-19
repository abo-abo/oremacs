(use-package org-roam
  :diminish org-roam-mode)

(setq org-roam-directory
      (expand-file-name
       "roam"
       (file-name-directory
        (directory-file-name
         plain-org-wiki-directory))))

(setq org-roam-completion-system 'ivy)

(whicher "dot")

(setq org-roam-capture-templates
      '(("d"
         "default"
         plain
         #'org-roam-capture--get-point
         "%?"
         :file-name "%<%Y-%m-%d_%H:%M>-${slug}"
         :head "#+title: ${title}\n* Tasks\n"
         :unnarrowed t)))

(defhydra hydra-org-roam (:exit t :idle 0.8)
  "Launcher for `org-roam'."
  ("i" org-roam-insert "insert")
  ("f" ora-org-roam-find-file "find-file"))

(org-roam-mode)

(defun ora-org-roam-find-file-action (x)
  (let ((title-with-tags (car x))
        (file-path (plist-get (cdr x) :path)))
    (if file-path
        (org-roam--find-file file-path)
      (let ((org-roam-capture--info
             `((title . ,title-with-tags)
               (slug . ,(funcall org-roam-title-to-slug-function title-with-tags))))
            (org-roam-capture--context 'title))
        (setq org-roam-capture-additional-template-props (list :finalize 'find-file))
        (org-roam-capture--capture))))
  (message "%S" x))

(defun ora-org-roam-find-file ()
  (interactive)
  (unless org-roam-mode (org-roam-mode))
  (ivy-read "File: " (org-roam--get-title-path-completions)
            :action #'ora-org-roam-find-file-action
            :caller 'ora-org-roam-find-file))

(provide 'ora-org-roam)
