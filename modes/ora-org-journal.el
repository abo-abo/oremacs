(use-package org-journal
  :config
  (setq org-journal-dir (expand-file-name "../journal/" plain-org-wiki-directory))
  (setq org-journal-file-format "%Y-%m-%d"))

(defhydra hydra-org-journal (:exit t :idle 0.8)
  "Launcher for `org-journal'."
  ("j" org-journal-new-entry "new")
  ("f" org-journal-open-current-journal-file "today"))

(provide 'ora-org-journal)
