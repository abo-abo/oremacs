(add-to-list 'load-path "~/git/mu/mu4e")
(require 'mu4e)
(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")
(setq mu4e-headers-skip-duplicates t)

(define-key mu4e-headers-mode-map "h" 'mu4e-headers-prev)

;;;###autoload
(defun ora-mu4e-headers-hook ())

