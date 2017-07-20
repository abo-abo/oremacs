(require 'sh-script)

(define-key sh-mode-map (kbd "<f5>")
  (lambda ()
    (interactive)
    (executable-interpret
     (buffer-file-name))))

(define-key sh-mode-map (kbd "C-c C-r") nil)


;;;###autoload
(defun ora-sh-hook ()
  (setq sh-basic-offset 2))
