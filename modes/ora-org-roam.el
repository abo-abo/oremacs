(require 'pora-org nil t)
(use-package org-roam
  :diminish org-roam-mode)
(require 'pamparam)
(setq wgrep-colon-file-separator-header-regexp "\\(?1:[^\n]+?[^\n/:]\\):\\(?3:[1-9][0-9]*\\)[	 ]*:")

(setq org-roam-verbose nil)
(setq org-roam-directory
      (expand-file-name
       "roam"
       (file-name-directory
        (directory-file-name
         plain-org-wiki-directory))))

;; (org-roam-mode)
(require 'org-roam-protocol)
(setq org-roam-buffer-position 'bottom)
(setq org-roam-completion-system 'ivy)
(whicher "dot")
(setq org-roam-graph-extra-config '(("overlap" . "prism")
                                    ("color" . "skyblue")))
(setq org-roam-capture-templates
      '(("d"
         "default"
         plain
         #'org-roam-capture--get-point
         "%?"
         :file-name "%<%Y-%m-%d_%H:%M>-${slug}"
         :head "#+title: ${title}\n* Tasks\n"
         :unnarrowed t)))

(setq org-roam-capture-ref-templates
      '(("r"
         "ref"
         plain
         #'org-roam-capture--get-point
         "%?"
         :file-name "%<%Y-%m-%d_%H:%M>-${slug}"
         :head "#+title: ${title}\n* Tasks\n** TODO [[${ref}][${title}]]\nAdded: %T\n"
         :unnarrowed t
         :immediate-finish t
         :jump-to-captured t)))

(defhydra hydra-org-roam (:exit t :idle 0.8)
  "Launcher for `org-roam'."
  ("i" ora-roam-insert "insert")
  ("f" ora-org-roam-find-file "find-file")
  ("r" org-roam-random-note "random")
  ("b" ora-org-roam-find-backlink "find backlink")
  ("t" ora-roam-todo "todo")
  ("j" org-roam-find-index "index"))

(defun ora-roam-insert (&optional arg)
  (interactive "P")
  (if arg
      (org-roam-db-build-cache)
    (worf-maybe-rebuild-roam-cache))
  (org-roam-insert))

(defun worf-maybe-rebuild-roam-cache ()
  (let ((n1 (length (org-roam--get-title-path-completions)))
        (n2 (length (directory-files org-roam-directory nil "org$"))))
    (unless (= n1 n2)
      (org-roam-db-build-cache))))

(defun ora-org-roam-find-backlink-action (x)
  (let ((fname (nth 0 x))
        (plist (nth 2 x)))
    (find-file fname)
    (goto-char (plist-get plist :point))))

(defun ora-org-roam-find-backlink-transformer (x)
  (org-roam-db--get-title (substring-no-properties x)))

(defun ora-org-roam-find-backlink (&optional arg)
  (interactive "P")
  (if arg
      (org-roam-db-build-cache)
    (worf-maybe-rebuild-roam-cache))
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
  ;; (unless org-roam-mode (org-roam-mode))
  (ivy-read "File: " (org-roam--get-title-path-completions)
            :action #'ora-org-roam-find-file-action
            :caller 'ora-org-roam-find-file))

(defun ora-check-org-roam-db ()
  (interactive)
  (let* ((fs1 (directory-files org-roam-directory nil "org$"))
         (fs2
          (mapcar (lambda (x) (file-name-nondirectory (plist-get (cdr x) :path)))
                  (org-roam--get-title-path-completions)))
         (diff (cl-set-difference fs1 fs2 :test 'equal)))
    (if (= 0 (length diff))
        (message "OK")
      (message "Db invalid %S" diff))))

(require 'pora-org-roam nil t)
(provide 'ora-org-roam)
