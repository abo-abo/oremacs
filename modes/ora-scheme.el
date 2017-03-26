(require 'geiser-mode)
(define-key geiser-mode-map (kbd "C-.") nil)
(define-key geiser-mode-map (kbd "C-c C-l") 'geiser-eval-buffer)
(setq geiser-active-implementations '(racket))
(setq geiser-mode-autodoc-p nil)

(defun scheme-completion-at-point ()
  (let* ((bnd (bounds-of-thing-at-point 'symbol))
         (prefix (lispy--string-dwim bnd)))
    (with-current-buffer (geiser-repl--buffer-name geiser-impl--implementation)
      (list (car bnd) (cdr bnd)
            (geiser-completion--symbol-list prefix)))))
;;;###autoload
(defun ora-scheme-hook ()
  (setq prettify-symbols-alist
        '(("lambda" . ?λ)))
  (setq-local lispy-outline-header ";;")
  (prettify-symbols-mode)
  (geiser-mode)
  (lispy-mode)
  (company-mode -1)
  (setq-local completion-at-point-functions '(scheme-completion-at-point)))

(setq scheme-program-name "/usr/bin/csi")
