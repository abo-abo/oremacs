;;;  -*- lexical-binding:t -*-

;;* Customs
(require 'magit)
(require 'magit-ediff)
(setq-default git-commit-summary-max-length 80)
;; (csetq magit-log-margin-spec '(30 nil magit-duration-spec))
(csetq magit-status-buffer-name-format "*magit: %b*")
(setq magit-revision-insert-related-refs nil)
(csetq magit-revert-buffers t)
(setq git-commit-finish-query-functions nil)
(setq magit-status-headers-hook
      '(magit-insert-error-header
        magit-insert-repo-header
        magit-insert-remote-header
        ;; magit-insert-diff-filter-header
        magit-insert-head-branch-header
        ;; magit-insert-upstream-branch-header
        magit-insert-push-branch-header
        magit-insert-tags-header))

(csetq magit-status-sections-hook
       '(magit-insert-status-headers
         magit-insert-merge-log
         magit-insert-rebase-sequence
         magit-insert-am-sequence
         magit-insert-sequencer-sequence
         magit-insert-bisect-output
         magit-insert-bisect-rest
         magit-insert-bisect-log
         magit-insert-untracked-files
         magit-insert-unstaged-changes
         magit-insert-staged-changes
         magit-insert-stashes
         magit-insert-unpushed-to-pushremote
         magit-insert-unpushed-to-upstream
         ;; magit-insert-unpushed-to-upstream-or-recent
         magit-insert-unpulled-from-pushremote
         magit-insert-unpulled-from-upstream))
(csetq magit-revision-headers-format
       "Author:     %aN <%aE>
AuthorDate: %ad")

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
(define-key magit-hunk-section-map (kbd "RET") 'magit-diff-visit-worktree-file)

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
(define-key magit-status-mode-map (kbd "C-M-p") #'ora-magit-force-push)

(define-key magit-status-mode-map "I"
  (lambda () (interactive)
    (magit-gitignore-in-gitdir (magit-current-file))))
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
(define-key magit-diff-mode-map "o" 'magit-diff-visit-file)
;; (define-key magit-branch-manager-mode-map "j" 'magit-goto-next-section)
;; (define-key magit-branch-manager-mode-map "k" 'magit-goto-previous-section)
;; (define-key magit-branch-manager-mode-map "d" 'magit-discard-item)
;; (define-key magit-branch-manager-mode-map "u" 'magit-diff-working-tree)

;;;###autoload
(defun ora-nextmagit-status-hook ()
  (yas-minor-mode 0))
;;;###autoload
(defun ora-nextmagit-log-hook ())
;;;###autoload
(defun ora-nextmagit-commit-hook ())
;;;###autoload
(defun ora-nextmagit-diff-hook ())
;;;###autoload
(defun ora-nextmagit-branch-manager-hook ())
;;* Functions
(defun ora-magit-find-main-file ()
  "Open the main file of the repo."
  (interactive)
  (let* ((dirname (car (last (split-string default-directory "/" t))))
         (fname (format "%s.el" dirname)))
    (when (file-exists-p fname)
      (find-file fname))))

(defun ora-magit-copy-item-as-kill ()
  "See `magit-copy-section-value'"
  (interactive)
  (let* ((section (magit-current-section))
         (value (oref section value)))
    (magit-section-case
      ((message)
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
         (message "COMMIT_MSG")))
      (t (kill-new (message "%s" value))))))

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
  (magit-diff-visit-worktree-file (magit-file-at-point)))

(define-key magit-status-mode-map "e" 'ora-magit-ediff-dwim)
;; (define-key magit-status-mode-map "e" 'magit-ediff-show-working-tree)
(define-key magit-status-mode-map "ox" 'ora-nextmagit-simple-commit)
(define-key magit-status-mode-map "w" 'ora-nextmagit-copy-message)
(defun ora-magit-ediff-dwim ()
  (interactive)
  (let ((range (magit-diff--dwim)))

    (cond
     ((eq range 'unstaged)
      (ora-magit-ediff-stage (magit-current-file))
      ;; (magit-ediff-show-unstaged (magit-current-file))
      )
     ((eq range 'staged)
      (magit-ediff-show-staged (magit-current-file)))
     (t
      (error "Unexpected")
      (magit-ediff-show-working-tree (magit-current-file))))))

(defun ora-magit-update-index ()
  (let ((file (magit-file-relative-name)))
    (let ((index (make-temp-name (magit-git-dir "magit-update-index-")))
          (buffer (current-buffer)))
      (when magit-wip-before-change-mode
        (magit-wip-commit-before-change (list file) " before un-/stage"))
      (unwind-protect
          (progn
            (let ((coding-system-for-write buffer-file-coding-system))
              (with-temp-file index
                (insert-buffer-substring buffer)))
            (magit-with-toplevel
              (magit-call-git
               "update-index" "--cacheinfo"
               (substring (magit-git-string "ls-files" "-s" file)
                          0 6)
               (magit-git-string "hash-object" "-t" "blob" "-w"
                                 (concat "--path=" file)
                                 "--" (magit-convert-filename-for-git index))
               file)))
        (ignore-errors (delete-file index)))
      (set-buffer-modified-p nil)
      (when magit-wip-after-apply-mode
        (magit-wip-commit-after-apply (list file) " after un-/stage")))))

(defun ora-magit-ediff-stage (file)
  "Modified from `magit-ediff-stage'."
  (magit-with-toplevel
    (let* ((bufB (magit-get-revision-buffer "{index}" file))
           (bufC (get-file-buffer file))
           ;; Use the same encoding for all three buffers or we
           ;; may end up changing the file in an unintended way.
           (bufC* (or bufC (find-file-noselect file)))
           (coding-system-for-read
            (buffer-local-value 'buffer-file-coding-system bufC*))
           (bufB* (magit-find-file-index-noselect file t)))
      (setf (buffer-local-value 'buffer-read-only bufB*) nil)
      (magit-ediff-buffers
       (bufB bufB*)
       (bufC bufC*)
       nil
       nil
       #'ora-magit-ediff-finish))))

(defun ora-magit-ediff-finish ()
  (when (buffer-live-p ediff-buffer-A)
    (when (buffer-modified-p ediff-buffer-A)
      (with-current-buffer ediff-buffer-A
        (ora-magit-update-index))))
  (when (and (buffer-live-p ediff-buffer-B)
             (buffer-modified-p ediff-buffer-B))
    (with-current-buffer ediff-buffer-B
      (save-buffer))))

(transient-define-argument magit:--author ()
  :description "Limit to author"
  :class 'transient-option
  :key "t"
  :argument "--author="
  :reader #'magit-transient-read-person)

(transient-append-suffix 'magit-log "-n" '("f" "First parent" "--first-parent"))

(defun ora-nextmagit-simple-commit ()
  (interactive)
  (magit-with-toplevel
    (save-window-excursion
      (let* ((item (magit-current-section))
             (fname (oref item value))
             action log)
        (ignore-errors
          (magit-stage))
        (search-forward fname)
        (setq action (if (looking-back "^new file.*" (line-beginning-position))
                         "Add"
                       "Update"))
        (magit-commit-add-log)
        (while (not (setq log (magit-commit-message-buffer)))
          (sit-for 0.01))
        (with-current-buffer log
          (insert action)
          (with-editor-finish nil))))))

(defun ora-nextmagit-copy-message ()
  (interactive)
  (let* ((item (magit-current-section))
         (hash (oref item value)))
    (kill-new
     (shell-command-to-string
      (format "git log -n 1 --pretty=format:%%s %s" hash)))))

(defvar ora-magit-status-buffer-hook nil)

;;;###autoload
(defun ora-magit-status-buffer ()
  (interactive)
  (run-hooks 'ora-magit-status-buffer-hook)
  (let ((ivy-initial-inputs-alist
         '((ivy-switch-buffer . "^magit: "))))
    (ivy-switch-buffer)))

(define-key magit-refs-mode-map (kbd "C-k") 'magit-branch-delete)
(setq git-commit-fill-column 100)


(defun magit-branch-and-checkout (branch start-point &optional args)
  "Create and checkout BRANCH at branch or revision START-POINT."
  (interactive (append (list
                        (magit-read-string-ns "Create and checkout branch named")
                        "HEAD")
                       (list (magit-branch-arguments))))
  (if (string-match-p "^stash@{[0-9]+}$" start-point)
      (magit-run-git "stash" "branch" branch start-point)
    (magit-call-git "checkout" args "-b" branch start-point)
    (magit-branch-maybe-adjust-upstream branch start-point)
    (magit-refresh)))

;; (transient-insert-suffix 'magit-commit "x" '("x" "Auto-commit" magit-commit-add-log))


(define-key magit-revision-mode-map "p" 'ora-magit-parent-commit)

(defun ora-magit-parent-commit ()
  (interactive)
  (let* ((commit (save-excursion
                   (goto-char (point-min))
                   (buffer-substring-no-properties (point-min) (line-end-position))))
         (parent (shell-command-to-string (format "git get-merge %s" commit))))
    (when parent
      (let ((parent-commit (and (string-match "commit \\(.*\\)" parent)
                                (match-string 1 parent))))
        (magit-show-commit parent-commit)))))


(remove-hook 'magit-status-headers-hook 'magit-insert-tags-header)

(defun ora-magit-force-push ()
  (interactive)
  (let* ((branch (magit-get-current-branch))
         (merge (concat "refs/heads/" branch)))
    (magit-run-git-async
     "push" "-v" '("--force") "origin" (concat branch ":" merge))))

(require 'pora-magit nil t)
(provide 'ora-magit)
