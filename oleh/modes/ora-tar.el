(require 'tar-mode)

(define-key tar-mode-map "j" 'tar-next-line)
(define-key tar-mode-map "k" 'tar-previous-line)

;;;###autoload
(defun ora-tar-hook ())
