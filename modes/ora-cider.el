(require 'ac-cider)
(add-to-list 'ac-modes 'cider-mode)
(require 'cider)
(setq cider-auto-mode nil)

(define-key cider-mode-map (kbd "C-:") nil)
(define-key cider-mode-map (kbd "C-c C-c") nil)
(define-key cider-mode-map (kbd "C-c C-k") nil)

(define-key cider-repl-mode-map (kbd "C-x C-l") 'cider-repl-clear-buffer)
(define-key cider-repl-mode-map (kbd "C-:") nil)
(define-key cider-repl-mode-map (kbd "C-c C-c") nil)
(define-key cider-repl-mode-map (kbd "C-c C-k") nil)

;;;###autoload
(defun ora-cider-hook ())
