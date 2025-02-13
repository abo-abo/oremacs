(require 'flycheck)

(setq flycheck-check-syntax-automatically '(save mode-enabled))

(setq flycheck-mode-line-prefix "")
(setq flycheck-mode-line-color nil)
(setq flycheck-mode-success-indicator "0")

(defun ora-flycheck-error-list-hook ()
  (setq tabulated-list-format '[("File" 15)
                                ("Line"
                                 5
                                 flycheck-error-list-entry-<
                                 :right-align t)
                                ("Col" 3 nil :right-align t)
                                ("Level"
                                 7
                                 flycheck-error-list-entry-level-<)
                                ("ID" 16 t)
                                (#("Message (Checker)"
                                   0 7 (face
                                        flycheck-error-list-error-message)
                                   9 16 (face
                                         flycheck-error-list-checker-name))
                                 0
                                 t)])
  (tabulated-list-init-header))

(define-key flycheck-error-list-mode-map "j" 'flycheck-error-list-next-error)
(define-key flycheck-error-list-mode-map "k" 'flycheck-error-list-previous-error)

(add-hook 'flycheck-error-list-mode-hook 'ora-flycheck-error-list-hook)

(provide 'ora-flycheck)
