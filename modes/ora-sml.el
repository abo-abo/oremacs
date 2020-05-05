(require 'sml-mode)
(require 'lpy-soap)

;;;###autoload
(defun ora-sml-hook ())

(dolist (k '("=" "+" "-" "<" ">" ","))
  (define-key sml-mode-map k 'lpy-soap-command))

(require 'pora-sml nil t)

(provide 'ora-sml)
