(require 'man)

(define-key Man-mode-map "w" 'forward-word)
(define-key Man-mode-map "b" 'backward-word)

;;;###autoload
(defun ora-Man-hook ()
  (require 'rover)
  (rover-mode 1))

(provide 'ora-Man)
