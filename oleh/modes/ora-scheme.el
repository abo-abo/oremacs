(require 'geiser-mode)
(define-key geiser-mode-map (kbd "C-.") nil)
(define-key geiser-mode-map (kbd "C-c C-l") 'geiser-eval-buffer)
(setq geiser-impl--implementation 'racket)

;;;###autoload
(defun ora-scheme-hook ()
  (setq prettify-symbols-alist
        '(("lambda" . ?λ)))
  (prettify-symbols-mode)
  (lispy-mode)
  (company-mode -1))

(setq scheme-program-name "/usr/bin/csi")
