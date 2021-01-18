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

(ivy-define-key ivy-occur-grep-mode-map "d" 'ora-roam-todo-delay)

(defun ora-roam-todo ()
  "An ad-hoc agenda for `org-roam'."
  (interactive)
  (let* ((win (selected-window))
         (buf (current-buffer))
         (bname "*roam-todo*")
         (b (get-buffer bname)))
    (if b
        (progn
          (switch-to-buffer b)
          (ivy-occur-revert-buffer))
      (setq b (get-buffer-create bname))
      (pop-to-buffer b)
      (ora-roam-occur)
      (setq ivy-occur-last (make-ivy-state
                            :action #'counsel-git-grep-action
                            :buffer buf
                            :caller 'ora-roam-todo
                            :directory default-directory
                            :re-builder #'ivy--regex-plus
                            :text ivy-text
                            :window win)))))

(ivy-configure 'ora-roam-todo
  :occur #'ora-roam-occur
  :parent 'counsel-rg)

(defun ora-roam-occur (&optional _cands)
  (unless (eq major-mode 'ivy-occur-grep-mode)
    (ivy-occur-grep-mode))
  (setq default-directory org-roam-directory)
  (setq-local counsel-ag-command
              '("rg" "--no-heading" "--line-number" "--sort" "modified" "--color" "never" "-s" "%s"))
  (ivy-set-text "^\\*+  TODO")
  (let ((cands (counsel--split-string
                (counsel--call
                 (cl-subst ivy-regex "%s" counsel-ag-command :test #'equal))))
        (today (format-time-string "%Y_%m_%d")))
    (setq cands
          (cl-remove-if
           (lambda (s)
             (and (string-match ":\\([0-9]+_[0-9]+_[0-9]+\\):" s)
                  (not (string= (match-string 1 s) today))))
           cands))
    (swiper--occur-insert-lines (mapcar #'counsel--normalize-grep-match cands))))

(defun ora-roam-read-stats (beg end)
  (save-excursion
    (goto-char beg)
    (if (re-search-forward "(setq stats '\\((.*)\\))" end t)
        (read
         (match-string-no-properties 1))
      (goto-char end)
      (insert "(setq stats '(2.5))\n")
      (list 2.5))))

(defun ora-roam-write-stats (beg end stats)
  (save-excursion
    (goto-char beg)
    (when (re-search-forward "(setq stats '\\((.*)\\))" (min (+ end 20) (point-max)) t)
      (replace-match (prin1-to-string stats) nil t nil 1))))

(defun ora-roam-todo-delay ()
  (interactive)
  (save-selected-window
    (ivy-occur-press-and-switch)
    (org-back-to-heading)
    (let* ((el (org-element-at-point))
           (beg (org-element-property :begin el))
           (end (org-element-property :end el))
           (stats (ora-roam-read-stats beg end))
           (new-stats (pamparam-sm2 stats 4))
           (interval (nth 1 new-stats))
           (new-tag (format-time-string "%Y_%m_%d" (time-add nil (* 3600 24 interval))))
           (tags (org-element-property :tags el)))
      (ora-roam-write-stats beg end new-stats)
      (org-set-tags
       (cons new-tag (cl-remove-if
                      (lambda (tag) (string-match "\\([0-9]+\\)_\\([0-9]+\\)_\\([0-9]+\\)" tag))
                      tags))))
    (save-buffer))
  (ivy-occur-delete-candidate))

(provide 'ora-org-roam)
