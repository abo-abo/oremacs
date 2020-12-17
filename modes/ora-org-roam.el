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
         :file-name "%<%Y%m%d%H%M%S>-${slug}"
         :head "#+title: ${title}\n* Tasks\n"
         :unnarrowed t)))

(defhydra hydra-org-roam (:exit t :idle 0.8)
  "Launcher for `org-roam'."
  ("i" org-roam-insert "insert")
  ("f" org-roam-find-file "find-file"))

(org-roam-mode)

(provide 'ora-org-roam)
