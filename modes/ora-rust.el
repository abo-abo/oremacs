(require 'rust-mode)
(require 'cc-chainsaw)

(define-key rust-mode-map (kbd "<f5>") 'ccc-run)

;;;###autoload
(defun ora-rust-hook ())

(provide 'ora-rust)
