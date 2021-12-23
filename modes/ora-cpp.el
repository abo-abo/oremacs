(require 'subword)
;; (require 'lsp)
(diminish 'subword-mode)
(require 'function-args)
(fa-config-default)
(setq fa-insert-method 'name-space-parens)
(define-key function-args-mode-map (kbd "M-i") nil)
(define-key function-args-mode-map (kbd "C-2") 'fa-show)
(require 'ciao)
(require 'cc-chainsaw)
(csetq c-hanging-semi&comma-criteria nil)
(setq-default c-basic-offset 4)
(use-package ccls)
(use-package google-c-style)
;; (require 'oval)

;;* Keymaps
(define-key c-mode-base-map (kbd "C-M-h") 'moo-jump-local)
(define-key c-mode-base-map (kbd "C-M-j") 'moo-jump-directory)
(define-key c-mode-base-map "σ" 'ora-braces-c++)
(define-key c-mode-base-map "3"
  (lambda ()
    (interactive)
    (if (region-active-p)
        (call-interactively 'ccc-align-function-arguments)
      (self-insert-command 1))))
(define-key c-mode-base-map (kbd "TAB") 'ccc-magic-tab)
(define-key c-mode-base-map (kbd "DEL") 'ccc-electric-del)
(define-key c-mode-base-map (kbd "M-r") 'ccc-run)
(define-key c++-mode-map (kbd "β") 'counsel-company)
(define-key c++-mode-map (kbd "M-q") 'ccc-align-function-arguments)
(define-key c++-mode-map (kbd "C-M-g") 'hydra-gud/body)
(define-key c++-mode-map (kbd "C-2") 'fa-show)
(define-key c++-mode-map (kbd "C-x C-n") 'ccc-jump-to-definition)
(define-key c++-mode-map (kbd "C-c C-z") 'ora-c++-to-gud)
(define-key c++-mode-map (kbd "C-c n") 'hydra-moo-generate/body)
(define-key c++-mode-map "." 'ccc-smart-dot)

;;;###autoload
(defun ora-c-common-hook ()
  (company-mode)
  (unless (eq major-mode 'java-mode)
    ;; (lsp)
    (ciao-mode)
    (google-set-c-style)
    (c-set-offset 'access-label -2)
    (google-make-newline-indent)
    ;; (oval-mode)
    (subword-mode)
    (setq-local forward-sexp-function 'ora-c-forward-sexp-function)
    (add-to-list 'completion-at-point-functions 'moo-completion-headers)))

;;;###autoload
(defun ora-c-hook ()
  (setq ccc-compile-cmd "gcc -g -O2 -std=c99"))

;;;###autoload
(defun ora-c++-hook ()
  (c-toggle-auto-newline)
  (setq c-electric-flag nil)
  (electric-indent-mode -1))

(provide 'ora-cpp)
