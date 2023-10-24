(require 'pass)
(define-key pass-mode-map (kbd "j") #'pass-next-entry)
(define-key pass-mode-map (kbd "k") #'pass-prev-entry)
(define-key pass-mode-map (kbd "i") #'pass-goto-entry)
(define-key pass-mode-map (kbd "C-d") #'pass-kill)
(define-key pass-mode-map (kbd "a") #'pass-insert)
(define-key pass-mode-map (kbd "+") #'pass-insert)
(define-key pass-mode-map (kbd "A") #'pass-insert-generated)
(define-key pass-mode-map (kbd "n") #'pass-copy)

;;;###autoload
(defun ora-password ()
  (interactive)
  (ivy-read "Pass: " (password-store-list)
            :action #'password-store-copy
            :caller 'ora-password))

(defun ora-password-action-gpg (password-path)
  (insert "$(gpg -q --for-your-eyes-only --no-tty -d ~/.password-store/" password-path ".gpg)"))

(ivy-set-actions
 'ora-password
 '(("g" ora-password-action-gpg "gpg")))

(provide 'ora-pass)
