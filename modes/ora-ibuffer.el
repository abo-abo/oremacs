(require 'ibuffer)
(setq ibuffer-movement-cycle nil)

;; (define-key ibuffer-mode-map "j" 'ibuffer-jump-to-buffer)
(define-key ibuffer-mode-map "j" 'ibuffer-forward-line)
;; (define-key ibuffer-mode-map "k" 'ibuffer-do-kill-lines)
(define-key ibuffer-mode-map "k" 'ibuffer-backward-line)
(define-key ibuffer-mode-map (kbd "C-t") nil)

;;;###autoload
(defun ora-ibuffer-hook ())
