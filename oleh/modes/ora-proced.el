;;;###autoload
(defun ora-proced-hook ())

(define-key proced-mode-map "K" 'proced-send-signal)
(define-key proced-mode-map "j" 'next-line)
(define-key proced-mode-map "k" 'previous-line)

(provide 'ora-proced)
