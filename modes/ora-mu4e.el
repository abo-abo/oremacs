(require 'whicher)
(require 'ora-smime)

(csetq send-mail-function 'smtpmail-send-it)
(csetq smtpmail-auth-credendials (expand-file-name "~/.authinfo"))
(csetq smtpmail-smtp-server "smtp.gmail.com")
(csetq smtpmail-smtp-service 587)

(use-package mu4e
  :load-path "/usr/local/share/emacs/site-lisp/mu4e/")
(setq mu4e-maildir "~/mail/work")
(setq mu4e-html2text-command (whicher "w3m -T text/html"))
(setq mu4e-drafts-folder "/Drafts")
(setq mu4e-trash-folder "/Trash")
(setq mu4e-get-mail-command (whicher "mbsync -a"))
(setq message-kill-buffer-on-exit t)
(setq mu4e-confirm-quit nil)
(setq mu4e-headers-date-format "%Y-%m-%d %H:%M")
(setq mu4e-headers-fields
      '((:human-date . 16)
        (:flags . 6)
        (:from . 22)
        (:subject . nil)))
(setq mu4e-compose-format-flowed t)
(setq mu4e-view-show-addresses t)
;; needed for mbsync
(setq mu4e-change-filenames-when-moving t)
(setq message-sendmail-f-is-evil nil)
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq sendmail-program (whicher "msmtp"))

;; don't save message to Sent Messages, IMAP server takes care of that
(setq mu4e-sent-messages-behavior 'delete)
(setq mu4e-headers-include-related nil)

(define-key mu4e-compose-mode-map (kbd "C-M-i") nil)
(define-key mu4e-compose-mode-map (kbd "C-c C-a") 'ora-mml-attach-file)
(define-key mu4e-compose-mode-map (kbd "M-q") 'fill-paragraph)
(define-key mu4e-headers-mode-map "j" 'mu4e-headers-next)
(define-key mu4e-headers-mode-map "k" 'mu4e-headers-prev)
(define-key mu4e-headers-mode-map "J" 'mu4e~headers-jump-to-maildir)
(define-key mu4e-view-mode-map (kbd "C--") nil)
(define-key mu4e-view-mode-map "j" 'mu4e-view-headers-next)
(define-key mu4e-view-mode-map "k" 'mu4e-view-headers-prev)

(set-face-foreground 'mu4e-modeline-face "white")

(defun ora-mml-attach-file ()
  (interactive)
  (let ((current-prefix-arg '(42)))
    (call-interactively #'mml-attach-file)))

;;;###autoload
(defun ora-mu4e-headers-hook ())

;;;###autoload
(defun ora-mu4e-compose-hook ()
  (use-hard-newlines -1)
  ;; (setq truncate-lines t)
  (setq completion-at-point-functions
        '(mu4e~compose-complete-contact t)))

(require 'pora-mu4e nil t)

(provide 'ora-mu4e)
