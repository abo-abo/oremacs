(require 'doc-view)

(csetq doc-view-continuous t)
(define-key doc-view-mode-map "h" 'doc-view-previous-page)
(define-key doc-view-mode-map "\C-p" 'doc-view-previous-page)
(define-key doc-view-mode-map "k" 'doc-view-previous-page)
(define-key doc-view-mode-map "j" 'doc-view-next-page)

;;;###autoload
(defun ora-doc-view-hook ())
