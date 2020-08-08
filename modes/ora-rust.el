(require 'rust-mode)
(require 'cc-chainsaw)

(define-key rust-mode-map (kbd "<f5>") 'ccc-run)
(define-key rust-mode-map "σ" 'ora-braces-c++)

;;;###autoload
(defun ora-rust-hook ())

(require 'pora-rust nil t)
(provide 'ora-rust)
