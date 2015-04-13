(require 'sh-script)

(define-key sh-mode-map (kbd "<f5>")
  (lambda ()
    (interactive)
    (executable-interpret
     (buffer-file-name))))

;;;###autoload
(defun ora-sh-hook ())
