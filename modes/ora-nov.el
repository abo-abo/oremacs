(require 'nov)
(require 'rover)

;;;###autoload
(add-hook 'nov-mode-hook 'ora-nov-hook)

;;;###autoload
(defun ora-nov-hook ()
  (rover-mode))

(define-key nov-mode-map "j" 'next-line)
(define-key nov-mode-map "k" 'previous-line)
(define-key nov-mode-map "v" 'recenter-top-bottom)

(provide 'ora-nov)
