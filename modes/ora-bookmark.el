(use-package bookmark
  ;; remove the ugliness in the fringe in Emacs 28
  :custom-face (bookmark-face ((t (:foreground "white" :background "unspecified")))))

(setq bookmark-completion-ignore-case nil)
(bookmark-maybe-load-default-file)

(use-package headlong
  :commands headlong-bookmark-jump)

(defun bmk/function (bookmark)
  "Handle a function bookmark BOOKMARK."
  (funcall (bookmark-prop-get bookmark 'function)))

(defun bmk/magit-status ()
  "Bookmark for `magit-status'."
  (interactive)
  (when (buffer-file-name)
    (delete-trailing-whitespace)
    (save-buffer))
  (call-interactively 'magit-status))

(defun bmk/scratch ()
  "Bookmark for *scratch*."
  (interactive)
  (switch-to-buffer
   (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun bmk/py-scratch ()
  (interactive)
  (let ((data-dir (expand-file-name
                   (format-time-string "%Y-%m/%Y-%m-%d"
                                       (and current-prefix-arg (org-read-date nil 'to-time)))
                   roamy-directory-work)))
    (make-directory data-dir t)
    (find-file (expand-file-name "scratch.py" data-dir))))

(defun bmk/today-archive ()
  (interactive)
  (let ((data-dir (let ((roamy-directory-personal "~/Archive/years/")) (roamy--today-personal))))
    (make-directory data-dir t)
    (dired data-dir)))

(cl-pushnew
 '("p:  py-scratch"
   (filename . "   - no file -") (position . 0) (function . bmk/py-scratch) (handler . bmk/function))
 bookmark-alist :test #'equal)

(cl-pushnew
 '("t:  thoughts"
   (filename . "   - no file -") (position . 0) (function . roamy-find-thoughts) (handler . bmk/function))
 bookmark-alist :test #'equal)


(defun ora-remote-hosts ()
  (require 'tramp)
  (let ((default-directory "~"))
    (delq nil (mapcar
               (lambda (x) (and x (cdr x) (cadr x)))
               (tramp-parse-sconfig "~/.ssh/config")))))

(defun bmk/remote-shell ()
  (interactive)
  (ivy-read "ssh: " (cons "localhost" (ora-remote-hosts))
            :action (lambda (h)
                      (let ((default-directory
                             (if (string= h "localhost")
                                 default-directory
                               (concat "/ssh:" h ":/"))))
                        (ora-dired-open-term)))))

(defun bmk/remote-dired ()
  (interactive)
  (ivy-read "ssh: " (ora-remote-hosts)
            :action (lambda (h)
                      (dired (concat "/ssh:" h ":/")))))

(defun ora-add-bookmark-command-action (cmd)
  (let ((entry `(,(concat ": " cmd)
                 (filename . "   - no file -")
                 (position . 0)
                 (function . ,(intern cmd))
                 (handler . bmk/function))))
    (cl-pushnew entry bookmark-alist :test #'equal)))

(defun ora-add-bookmark-command ()
  "Add a command action."
  (interactive)
  (let ((ivy-inhibit-action #'ora-add-bookmark-command-action))
    (counsel-M-x)))

(require 'pora-bookmark nil t)

(provide 'ora-bookmark)
