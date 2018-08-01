(require 'comint)
(require 'bash-completion)
(bash-completion-setup)

(define-key comint-mode-map (kbd "<tab>") 'completion-at-point)

;;;###autoload
(defun ora-comint-hook ()
  (setq completion-at-point-functions
        '(bash-completion-dynamic-complete
          comint-c-a-p-replace-by-expanded-history
          shell-environment-variable-completion
          shell-command-completion
          shell-c-a-p-replace-by-expanded-directory
          shell-filename-completion
          comint-filename-completion))
  (shell-dirtrack-mode 1))

(provide 'ora-comint)
