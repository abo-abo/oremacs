(require 'slime)
(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/bin/sbcl")
(define-key slime-mode-map (kbd "M-p") nil)
(define-key slime-mode-map (kbd "C-M-i") nil)
(define-key slime-mode-indirect-map (kbd "C-M-i") nil)
(define-key lisp-mode-map (kbd "β") 'counsel-cl)
(setq lispy-colon-no-space-regex nil)
;; (remove-hook 'lisp-mode-hook 'slime-lisp-mode-hook)


;;;###autoload
(defun ora-lisp-hook ()
  (setq prettify-symbols-alist
        '(("lambda" . ?λ)))
  (prettify-symbols-mode)
  (lispy-mode)
  (when (bound-and-true-p slime-autodoc-mode)
    (slime-autodoc-mode -1)))

(defun ora-slime-completion-in-region (_fn completions start end)
  (funcall completion-in-region-function start end completions))

(advice-add
 'slime-display-or-scroll-completions
 :around #'ora-slime-completion-in-region)
