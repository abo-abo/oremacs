(require 'ora-elisp-style-guide)

(remove-hook 'post-self-insert-hook 'blink-paren-post-self-insert-function)
(csetq eval-expression-print-length nil)
(csetq eval-expression-print-level nil)
(setq print-gensym nil)
(setq print-circle nil)
(setq byte-compile--use-old-handlers nil)

(when (fboundp 'global-eldoc-mode) (global-eldoc-mode -1))
(defun eldoc-mode (&rest _))
(show-paren-mode 1)

;;* Misc
;;;###autoload
(defun ora-emacs-lisp-hook ()
  (ignore-errors
    (prettify-symbols-mode)
    (lispy-mode 1)
    (company-mode)
    (set (make-local-variable 'company-backends)
         '((company-elisp)))
    ;; (abel-mode)
    (diminish 'abbrev-mode)
    ;; (yas-minor-mode-on)
    (auto-compile-mode 1)
    (semantic-mode -1)
    (add-to-list 'completion-at-point-functions 'lispy-complete-fname-at-point)))

(use-package lispy
    :init
  (setq lispy-key-theme '(oleh special lispy c-digits))
  :config
  (progn
    (setq lispy-no-permanent-semantic t)
    (setq lispy-delete-backward-recenter nil)
    (setq lispy-helm-columns '(70 100))
    (setq lispy-avy-style-symbol 'at-full)))

(defun ora-package-symbol ()
  (interactive)
  (let ((prefix (concat (file-name-nondirectory
                         (directory-file-name
                          (file-name-directory (buffer-file-name))))
                        "-")))
    (unless (looking-back prefix (line-beginning-position))
      (insert prefix))
    (complete-symbol nil)))

(define-key lisp-mode-shared-map (kbd "β") 'counsel-company)
(define-key lisp-mode-shared-map (kbd "β") 'ora-package-symbol)

(define-key lisp-mode-shared-map (kbd "C-c C-z")
  (lambda ()
    (interactive)
    (switch-to-buffer-other-window "*scratch*")))
(define-key lisp-mode-shared-map (kbd "C-c C-l") 'eval-buffer)
(define-key emacs-lisp-mode-map (kbd "C-M-i") nil)
(define-key lisp-interaction-mode-map (kbd "C-M-i") nil)

(defun lisp--match-hidden-arg (limit) nil)

(setq prettify-symbols-alist
      '(("lambda" . ?λ)))
(font-lock-add-keywords 'emacs-lisp-mode
                        (ora-fontify-glyph "\\\\\\\\|" "∨"))
(font-lock-add-keywords 'emacs-lisp-mode
                        (ora-fontify-glyph "\\\\\\\\(" "("))
(font-lock-add-keywords 'emacs-lisp-mode
                        (ora-fontify-glyph "\\\\\\\\)" ")"))
(font-lock-add-keywords 'emacs-lisp-mode
                        (ora-fontify-glyph "\\\\\\\\{" "{"))
(font-lock-add-keywords 'emacs-lisp-mode
                        (ora-fontify-glyph "\\\\\\\\}" "}"))
(font-lock-add-keywords 'emacs-lisp-mode
                        '(("^;;;###[-a-z]*autoload.*$" 0 'shadow t))
                        'end)

(when (version< emacs-version "24.4")
  (defun prettify-symbols-mode ()))

(defun conditionally-enable-lispy ()
  (when (eq this-command 'eval-expression)
    (lispy-mode 1)))

(add-hook 'minibuffer-setup-hook 'conditionally-enable-lispy)

(defun ora-lisp-interaction-hook ()
  (lispy-mode 1)
  (company-mode 1))

;;* Add the last eval result to "M-y"
(defvar ora-last-eval-expression-result "")

(defun ora-last-eval-expression-result ()
  (list ora-last-eval-expression-result))

(defun ora-eval-expression (orig-fun &rest args)
  (setq ora-last-eval-expression-result
        (prin1-to-string
         (apply orig-fun args))))
(ora-advice-add 'eval-expression :around #'ora-eval-expression)

(ivy-set-sources
 'counsel-yank-pop
 '((original-source)
   (ora-last-eval-expression-result)))

(defun vs (n strs)
  "View strings."
  (cl-subseq
   (mapcar #'substring-no-properties strs)
   0 10))

(defun ora-edebug-hook ()
  ;; (lispy-mode -1)
  )

(add-hook 'edebug-setup-hook 'ora-edebug-hook)

(require 'pora-elisp nil t)
(provide 'ora-elisp)
