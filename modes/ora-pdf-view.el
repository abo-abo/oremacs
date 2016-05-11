(require 'pdf-view)

(define-key pdf-view-mode-map "j" 'pdf-view-next-line-or-next-page)
(define-key pdf-view-mode-map "k" 'pdf-view-previous-line-or-previous-page)
(define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward-regexp)

;;;###autoload
(defun ora-pdf-view-hook ())
