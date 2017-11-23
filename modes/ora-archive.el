(require 'arc-mode)

;;;###autoload
(defun ora-archive-hook ())

(define-key archive-mode-map "j" 'archive-next-line)
(define-key archive-mode-map "k" 'archive-previous-line)
