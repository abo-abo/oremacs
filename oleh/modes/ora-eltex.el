(require 'eltex)
(require 'lispy)
(setq lispy-no-space nil)
(define-key eltex-mode-map [f5] 'eltex-compile)

;;;###autoload
(defun ora-eltex-hook ()
  (setq-local font-lock-string-face 'eltex-text-face)
  (auto-complete-mode)
  (when (bound-and-true-p auto-compile-mode)
    (auto-compile-mode 0)))
