(use-package org-roam
  :diminish org-roam-mode
  :config
  (org-roam-mode)
  (require 'org-roam-protocol))

(setq org-roam-graph-extra-config '(("overlap" . "prism")
                                    ("color" . "skyblue")))

(setq org-roam-directory
      (expand-file-name
       "roam"
       (file-name-directory
        (directory-file-name
         plain-org-wiki-directory))))
(setq org-roam-buffer-position 'bottom)
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
  ("f" ora-org-roam-find-file "find-file")
  ("r" org-roam-random-note "random")
  ("v" org-roam-buffer-activate "view backlinks")
  ("b" ora-org-roam-find-backlink "find backlink")
  ("t" ora-roam-todo "todo"))

(defun ora-org-roam-find-backlink-action (x)
  (let ((fname (nth 0 x))
        (plist (nth 2 x)))
    (find-file fname)
    (goto-char (plist-get plist :point))))

(defun ora-org-roam-find-backlink-transformer (x)
  (org-roam-db--get-title (substring-no-properties x)))

(defun ora-org-roam-find-backlink ()
  (interactive)
  (let* ((file-path (buffer-file-name))
         (titles (org-roam--extract-titles))
         (backlinks (org-roam--get-backlinks (cons file-path titles))))
    (ivy-read "backlinks: " backlinks
              :action #'ora-org-roam-find-backlink-action
              :caller 'ora-org-roam-find-backlink)))

(ivy-configure 'ora-org-roam-find-backlink
  :display-transformer-fn #'ora-org-roam-find-backlink-transformer)

(defun ora-org-roam-find-file-action (x)
  (if (consp x)
      (let ((file-path (plist-get (cdr x) :path)))
        (org-roam--find-file file-path))
    (let* ((title-with-tags x)
           (org-roam-capture--info
            `((title . ,title-with-tags)
              (slug . ,(funcall org-roam-title-to-slug-function title-with-tags))))
           (org-roam-capture--context 'title))
      (setq org-roam-capture-additional-template-props (list :finalize 'find-file))
      (org-roam-capture--capture))))

(defun ora-org-roam-find-file ()
  (interactive)
  (unless org-roam-mode (org-roam-mode))
  (ivy-read "File: " (org-roam--get-title-path-completions)
            :action #'ora-org-roam-find-file-action
            :caller 'ora-org-roam-find-file))

(defun ora-roam-todo ()
  "An ad-hoc agenda for `org-roam'."
  (interactive)
  (let* ((regex "^\\* TODO")
         (b (get-buffer (concat "*ivy-occur counsel-rg \"" regex "\"*"))))
    (if b
        (progn
          (switch-to-buffer b)
          (ivy-occur-revert-buffer))
      (setq unread-command-events (listify-key-sequence (kbd "C-c C-o M->")))
      (counsel-rg regex org-roam-directory "--sort modified"))))

(provide 'ora-org-roam)
