(require 'nxml-mode)
(define-key nxml-mode-map (kbd "C-M-i") nil)

;;;###autoload
(defun ora-nxml-hook ()
  (rng-validate-mode -1))
