(require 'slime)
(require 'slime-autoloads)
(setq inferior-lisp-program "sbcl")

(diminish 'slime-autodoc-mode)
(define-key slime-mode-map (kbd "M-p") nil)
(define-key slime-mode-map (kbd "C-M-i") nil)
(define-key slime-mode-indirect-map (kbd "C-M-i") nil)
(define-key lisp-mode-map (kbd "β") 'counsel-cl)
;; (remove-hook 'lisp-mode-hook 'slime-lisp-mode-hook)

;;;###autoload
(defun ora-lisp-hook ()
  (setq prettify-symbols-alist
        '(("lambda" . ?λ)))
  (prettify-symbols-mode)
  (lispy-mode)
  (when (bound-and-true-p slime-autodoc-mode)
    (slime-autodoc-mode -1)))

;; (eval-after-load 'slime-autodoc
;;   '(setf (symbol-function 'slime-autodoc-space) #'self-insert-command))

(defun ora-slime-completion-in-region (_fn completions start end)
  (funcall completion-in-region-function start end completions))

(advice-add
 'slime-display-or-scroll-completions
 :around #'ora-slime-completion-in-region)

(lispy-raise-minor-mode 'lispy-mode)
(lispy-raise-minor-mode 'lispy-other-mode)

(require 'pora-lisp nil t)
(provide 'ora-lisp)
