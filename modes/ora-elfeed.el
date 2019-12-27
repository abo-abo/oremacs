(require 'elfeed-search)

(define-key elfeed-search-mode-map "j" 'next-line)
(define-key elfeed-search-mode-map "k" 'previous-line)
(define-key elfeed-search-mode-map "f" 'ora-elfeed-search-browse-url)
(define-key elfeed-search-mode-map "r" 'ora-elfeed-mark-read)

(defun ora-elfeed-search-browse-url ()
  (interactive)
  (let* ((entries (elfeed-search-selected))
         (entry (car entries)))
    (cl-assert (= (length entries) 1))
    (elfeed-untag entry 'unread)
    (elfeed-search-update-entry entry)
    (let ((link (elfeed-entry-link entry)))
      (if (string-match-p "https://www.youtube.com" link)
          (progn
            (push (list link (elfeed-entry-title entry))
                  org-stored-links)
            (org-capture nil "l")
            (message ""))
        (browse-url link)))))

(defun ora-elfeed-mark-read ()
  (interactive)
  (dolist (entry (elfeed-search-selected))
    (elfeed-untag entry 'unread)
    (elfeed-search-update-entry entry)))

(defun ora-elfeed-reload-youtube ()
  "Merge `elfeed-feeds' with the current Youtube subscriptions.
Assumes `browse-url-browser-function' is logged into Youtube."
  (interactive)
  (let ((file "~/Downloads/subscription_manager"))
    (when (file-exists-p file)
      (delete-file file))
    (browse-url
     "https://www.youtube.com/subscription_manager?action_takeout=1")
    (while (not (file-exists-p file))
      (sit-for 0.2))
    (let* ((xml (xml-parse-file file))
           (feeds (elfeed--parse-opml xml))
           (full (append feeds elfeed-feeds)))
      (setf elfeed-feeds (cl-delete-duplicates full :test #'string=)))
    (with-current-buffer (find-file-noselect
                          (expand-file-name
                           "personal/elfeed-feeds.el"
                           emacs-d))
      (erase-buffer)
      (lispy--insert
       `(setq elfeed-feeds (ly-raw quote ,elfeed-feeds)))
      (lispy-alt-multiline)
      (save-buffer)
      (kill-buffer))))

(provide 'ora-elfeed)
