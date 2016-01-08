;;* Customs
(require 'magit)
;; (csetq magit-log-margin-spec '(30 nil magit-duration-spec))
(csetq magit-status-buffer-name-format "*magit: %b*")
(csetq magit-revert-buffers t)
(setq git-commit-finish-query-functions nil)

(csetq magit-status-sections-hook
       '(magit-insert-status-headers
         magit-insert-merge-log
         magit-insert-rebase-sequence
         magit-insert-am-sequence
         magit-insert-sequencer-sequence
         magit-insert-bisect-output
         magit-insert-bisect-rest
         magit-insert-bisect-log
         magit-insert-stashes
         magit-insert-untracked-files
         magit-insert-unstaged-changes
         magit-insert-staged-changes
         magit-insert-unpulled-from-upstream
         magit-insert-unpushed-to-upstream))

(setq magit-status-headers-hook
      '(magit-insert-repo-header
        magit-insert-remote-header
        magit-insert-head-header
        magit-insert-tags-header))

(eval-after-load 'magit-blame
  '(progn
    (define-key magit-blame-mode-map "n" nil)
    (define-key magit-blame-mode-map "p" nil)
    (define-key magit-blame-mode-map "j" 'magit-blame-next-chunk)
    (define-key magit-blame-mode-map "k" 'magit-blame-previous-chunk)))

(define-key magit-refs-mode-map "j" 'magit-section-forward)
(define-key magit-refs-mode-map "k" 'magit-section-backward)
(define-key magit-refs-mode-map "i" 'magit-section-toggle)

(defun ora-move-key (key-from key-to keymap)
  "Move the command bound to KEY-FROM to KEY-TO in KEYMAP."
  (if (null key-to)
      (define-key keymap (kbd key-from) nil)
    (let* ((key-from (kbd key-from))
           (key-to (kbd key-to))
           (cmd (lookup-key keymap key-from)))
      (when cmd
        (define-key keymap key-to cmd)
        (define-key keymap key-from nil)))))

(ora-move-key "k" "C-k" magit-file-section-map)
(ora-move-key "k" "C-k" magit-untracked-section-map)
(ora-move-key "k" "C-k" magit-tag-section-map)
(ora-move-key "k" "C-k" magit-stash-section-map)
(ora-move-key "k" "C-k" magit-stashes-section-map)
(ora-move-key "k" "C-k" magit-unstaged-section-map)
(ora-move-key "k" "C-k" magit-hunk-section-map)
(ora-move-key "k" "C-k" magit-branch-section-map)
(ora-move-key "<C-tab>" nil magit-log-mode-map)
(ora-move-key "<C-tab>" nil magit-revision-mode-map)
(ora-move-key "<C-tab>" nil magit-status-mode-map)
(define-key magit-hunk-section-map (kbd "RET") 'magit-diff-visit-file-worktree)

(dolist (map (list magit-status-mode-map
                   magit-log-mode-map
                   magit-diff-mode-map
                   magit-staged-section-map))
  (define-key map "j" 'magit-section-forward)
  (define-key map "k" 'magit-section-backward)
  (define-key map "n" nil)
  (define-key map "p" nil)
  (define-key map "v" 'recenter-top-bottom)
  (define-key map "i" 'magit-section-toggle))

(ora-move-key "v" nil magit-file-section-map)
(ora-move-key "v" nil magit-hunk-section-map)
(define-key magit-log-mode-map "n" 'ora-magit-copy-item-as-kill)
(setq magit-remote-section-map (make-sparse-keymap))


(define-key magit-status-mode-map (kbd "M-m") 'lispy-mark-symbol)
(define-key magit-hunk-section-map "C" 'magit-commit-add-log)
(defvar ora-magit-commit-nodefun nil)
(define-key magit-status-mode-map "C"
  (lambda ()
    (interactive)
    (setq ora-magit-commit-nodefun t)
    (magit-commit-add-log)))
(define-key magit-status-mode-map "h" 'ora-magit-find-main-file)
(define-key magit-status-mode-map "d" 'magit-discard)
(setq magit-commit-add-log-insert-function 'ora-magit-commit-add-log-insert)
(defun ora-magit-commit-add-log-insert (buffer file defun)
  (with-current-buffer buffer
    (goto-char (point-min))
    (cond ((not (re-search-forward (format "^\\* %s" (regexp-quote file))
                                   nil t))
           ;; No entry for file, create it.
           (if (eolp)
               ;; Nothing on the first line
               nil
             (re-search-forward "^#")
             (backward-char 1)
             (if (looking-back "\n\n\n")
                 (backward-char 2)
               (backward-char 1)
               (insert "\n\n")
               (backward-char 1)))
           (if (bobp)
               (insert file)
             (insert (format "* %s" file)))
           (unless ora-magit-commit-nodefun
             (when defun
               (insert (format " (%s)" defun))))
           (setq ora-magit-commit-nodefun nil)
           (insert ": "))
          (defun
              ;; found entry for file, look for defun
              (let ((limit (save-excursion
                             (or (and (re-search-forward "^\\* " nil t)
                                      (match-beginning 0))
                                 (progn (goto-char (point-max))
                                        (forward-comment -1000)
                                        (point))))))
                (cond ((re-search-forward
                        (format "(.*\\_<%s\\_>.*):" (regexp-quote defun))
                        limit t)
                       ;; found it, goto end of current entry
                       (if (re-search-forward "^(" limit t)
                           (backward-char 2)
                         (goto-char limit)))
                      (t
                       ;; not found, insert new entry
                       (goto-char limit)
                       (if (bolp)
                           (open-line 1)
                         (newline))
                       (insert (format "(%s): " defun))))))
          (t
           ;; found entry for file, look for its beginning
           (when (looking-at ":")
             (forward-char 2))))))

(define-key magit-log-mode-map "o" 'ora-magit-visit-item-other-window)
(define-key magit-diff-mode-map "o"
  (lambda () (interactive) (magit-visit-item t)))
;; (define-key magit-branch-manager-mode-map "j" 'magit-goto-next-section)
;; (define-key magit-branch-manager-mode-map "k" 'magit-goto-previous-section)
;; (define-key magit-branch-manager-mode-map "d" 'magit-discard-item)
;; (define-key magit-branch-manager-mode-map "u" 'magit-diff-working-tree)

;;;###autoload
(defun ora-magit-status-hook ()
  (yas-minor-mode 0))
;;;###autoload
(defun ora-magit-log-hook ())
;;;###autoload
(defun ora-magit-commit-hook ())
;;;###autoload
(defun ora-magit-diff-hook ())
;;;###autoload
(defun ora-magit-branch-manager-hook ())
;;* Functions
(defun ora-magit-find-main-file ()
  "Open the main file of the repo."
  (interactive)
  (let* ((dirname (car (last (split-string default-directory "/" t))))
         (fname (format "%s.el" dirname)))
    (when (file-exists-p fname)
      (find-file fname))))

(defun ora-magit-copy-item-as-kill ()
  (interactive)
  (let ((section (magit-current-section)))
    (if (eq (magit-section-type section) 'message)
        (let* ((basestr (buffer-substring-no-properties
                         (magit-section-beginning section)
                         (magit-section-end section)))
               (newstr
                (mapconcat
                 (lambda (x)
                   (if (> (length x) 4)
                       (substring x 4)
                     x))
                 (split-string basestr "\n")
                 "\n")))
          (kill-new newstr)
          (message "COMMIT_MSG"))
      (magit-copy-item-as-kill))))

(defun ora-magit-visit ()
  (interactive)
  (magit-section-action visit (info parent-info)
    ((diff diffstat [file untracked])
     (magit-visit-file-item info nil))
    (hunk (magit-visit-file-item parent-info nil
                                 (magit-hunk-item-target-line it)
                                 (current-column)))
    (commit (ora-magit-show-commit info))
    (stash (magit-diff-stash info))
    (branch (magit-checkout info))))

(defun ora-magit-show-commit (commit)
  "Show information about COMMIT."
  (interactive (list (magit-read-rev-with-default
                      "Show commit (hash or ref)")))
  (when (magit-git-failure "cat-file" "commit" commit)
    (user-error "%s is not a commit" commit))
  (magit-mode-setup magit-commit-buffer-name
                    #'switch-to-buffer
                    #'magit-commit-mode
                    #'magit-refresh-commit-buffer
                    commit))

(defun ora-magit-commit-add-log ()
  (interactive)
  (let* ((section (magit-current-section))
         (fun (cond ((region-active-p)
                     (prog1 (lispy--string-dwim)
                       (deactivate-mark)))
                    ((eq (magit-section-type section) 'hunk)
                     (save-window-excursion
                       (save-excursion
                         (magit-visit-item)
                         (add-log-current-defun))))))
         (file (magit-section-info
                (cl-case (magit-section-type section)
                  (hunk (magit-section-parent section))
                  (diff section)
                  (t (user-error "No change at point")))))
         (locate-buffer (lambda ()
                          (cl-find-if
                           (lambda (buf)
                             (with-current-buffer buf
                               (derived-mode-p 'git-commit-mode)))
                           (append (buffer-list (selected-frame))
                                   (buffer-list)))))
         (buffer (funcall locate-buffer)))
    (unless buffer
      (magit-commit)
      (while (not (setq buffer (funcall locate-buffer)))
        (sit-for 0.01)))
    (pop-to-buffer buffer)
    (goto-char (point-min))
    (cond ((not (re-search-forward (format "^\\* %s" (regexp-quote file))
                                   nil t))
           ;; No entry for file, create it.
           (goto-char (point-max))
           (forward-comment -1000)
           (if (= (point) 1)
               (insert file)
             (insert (format "\n\n* %s" file)))
           (when fun
             (insert (format " (%s)" fun)))
           (insert ": "))
          (fun
           ;; found entry for file, look for fun
           (let ((limit (or (save-excursion
                              (and (re-search-forward "^\\* " nil t)
                                   (match-beginning 0)))
                            (point-max))))
             (cond ((re-search-forward
                     (format "(.*\\<%s\\>.*):" (regexp-quote fun))
                     limit t)
                    ;; found it, goto end of current entry
                    (if (re-search-forward "^(" limit t)
                        (backward-char 2)
                      (goto-char limit))
                    (forward-comment -1000))
                   (t
                    ;; not found, insert new entry
                    (goto-char limit)
                    (forward-comment -1000)
                    (if (bolp)
                        (open-line 1)
                      (newline))
                    (insert (format "(%s): " fun))))))
          (t
           ;; found entry for file, look for beginning  it
           (when (looking-at ":")
             (forward-char 2))))))

(defun endless/add-PR-fetch ()
  "If refs/pull is not defined on a GH repo, define it."
  (interactive)
  (let ((fetch-address "+refs/pull/*/head:refs/pull/origin/*"))
    (unless (member fetch-address
                    (magit-get-all "remote" "origin" "fetch"))
      (when (string-match
             "github" (magit-get "remote" "origin" "url"))
        (magit-git-string
         "config" "--add" "remote.origin.fetch"
         fetch-address)))))

(defun ora-magit-visit-item-other-window ()
  (interactive)
  (magit-diff-visit-file-worktree (magit-file-at-point)))

(provide 'ora-nextmagit)
