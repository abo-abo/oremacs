(require 'bookmark)
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

(provide 'ora-bookmark)
