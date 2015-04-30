(require 'pdf-view)

(define-key pdf-view-mode-map "j" 'pdf-view-next-line-or-next-page)
(define-key pdf-view-mode-map "k" 'pdf-view-previous-line-or-previous-page)

;;;###autoload
(defun ora-pdf-view-hook ())
