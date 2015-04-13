(require 'elfeed)

(define-key elfeed-search-mode-map "j" 'next-line)
(define-key elfeed-search-mode-map "k" 'previous-line)

(define-key elfeed-show-mode-map "\C-j" 'shr-browse-url)
(define-key elfeed-show-mode-map "j" 'next-line)
(define-key elfeed-show-mode-map "k" 'previous-line)
(define-key elfeed-show-mode-map "o" 'ace-link-info)

;;;###autoload
(defun ora-elfeed-search-hook ())

;;;###autoload
(defun ora-elfeed-show-hook ())
