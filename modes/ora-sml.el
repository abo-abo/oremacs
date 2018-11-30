(require 'sml-mode)
(require 'soap)


;;;###autoload
(defun ora-sml-hook ())

(dolist (k '("=" "+" "-" "<" ">" ","))
  (define-key sml-mode-map k 'soap-command))
