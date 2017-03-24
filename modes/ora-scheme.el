(require 'geiser-mode)
(define-key geiser-mode-map (kbd "C-.") nil)
(define-key geiser-mode-map (kbd "C-c C-l") 'geiser-eval-buffer)
(setq geiser-active-implementations '(racket))
(setq geiser-mode-autodoc-p nil)

;;;###autoload
(defun ora-scheme-hook ()
  (setq prettify-symbols-alist
        '(("lambda" . ?λ)))
  (setq-local lispy-outline-header ";")
  (prettify-symbols-mode)
  (geiser-mode)
  (lispy-mode)
  (company-mode -1))

(setq scheme-program-name "/usr/bin/csi")
