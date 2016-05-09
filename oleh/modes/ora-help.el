(require 'help-mode)

(define-key help-mode-map "j" 'next-line)
(define-key help-mode-map "k" 'previous-line)
(define-key help-mode-map "H" 'describe-mode)
(define-key help-mode-map "h" 'backward-char)
(define-key help-mode-map "L" 'help-go-back)
(define-key help-mode-map "l" 'forward-char)
(define-key help-mode-map "v" 'recenter-top-bottom)
(define-key help-mode-map (kbd "C-M-i") nil)
(define-key help-mode-map "c" 'counsel-ace-link)

;;;###autoload
(defun ora-help-hook ())
