(require 'nxml-mode)
(define-key nxml-mode-map (kbd "C-M-i") nil)

;;;###autoload
(defun ora-nxml-hook ()
  (rng-validate-mode -1)
  (when (eq system-name "firefly")
    (setq-local lispy-left "<")
    (setq-local lispy-right ">")
    (setq-local lispy-forward-list-function 'nxml-forward-element)
    (setq-local lispy-backward-list-function 'nxml-forward-element)
    (modify-syntax-entry ?< "(>")
    (modify-syntax-entry ?> ")<")
    (lispy-mode)))
