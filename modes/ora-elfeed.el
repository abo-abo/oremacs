(require 'elfeed-search)

(define-key elfeed-search-mode-map "j" 'next-line)
(define-key elfeed-search-mode-map "k" 'previous-line)
(define-key elfeed-search-mode-map "f" 'ora-elfeed-search-browse-url)
(define-key elfeed-search-mode-map "r" 'ora-elfeed-mark-read)

(defun ora-elfeed-search-browse-url ()
  (interactive)
  (save-excursion
    (elfeed-search-browse-url)))

(defun ora-elfeed-mark-read ()
  (interactive)
  (dolist (entry (elfeed-search-selected))
    (elfeed-untag entry 'unread)
    (elfeed-search-update-entry entry)))

(provide 'ora-elfeed)
