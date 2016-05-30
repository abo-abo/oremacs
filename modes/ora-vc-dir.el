(require 'vc-dir)

(define-key vc-dir-mode-map "j" 'vc-dir-next-line)
(define-key vc-dir-mode-map "k" 'vc-dir-previous-line)
(define-key vc-dir-mode-map "e" 'vc-ediff)
(define-key vc-dir-mode-map "R" 'vc-revert)

;;;###autoload
(defun ora-vc-dir-hook ())
