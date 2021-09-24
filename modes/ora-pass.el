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

(provide 'ora-pass)
