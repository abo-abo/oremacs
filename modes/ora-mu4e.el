(add-to-list 'load-path "~/git/mu/mu4e")
(require 'mu4e)
(setq mu4e-maildir "~/mail/gmail")
(setq mu4e-maildir "~/mail/work")

(setq mu4e-html2text-command "w3m -T text/html")

(setq mu4e-drafts-folder "/Drafts")
(setq mu4e-sent-folder   "/Sent Items")
(setq mu4e-trash-folder  "/Trash")
(setq mu4e-headers-skip-duplicates t)
;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)
(setq mu4e-get-mail-command "mbsync -a")
(setq message-kill-buffer-on-exit t)
(setq mu4e-confirm-quit nil)
(setq mu4e-headers-date-format "%d-%m-%Y %H:%M")

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.
(setq mu4e-maildir-shortcuts
      '(("/INBOX" . ?i)
        ("/[Gmail].Sent Mail" . ?s)
        ("/[Gmail].Trash" . ?t)
        ("/[Gmail].All Mail" . ?a)
        ("/[asml].All Mail" . ?m)))

;; TODO
;; (define-key mu4e-view-mode-map "j" 'forward-paragraph)
;; (define-key mu4e-view-mode-map "k" 'backward-paragraph)
;; (define-key mu4e-headers-mode-map "h" 'mu4e-headers-prev)
(require 'smtpmail)

;;;###autoload
(defun ora-mu4e-headers-hook ())
(define-key mu4e-view-mode-map (kbd "C--") nil)
(define-key mu4e-compose-mode-map (kbd "C-M-i") nil)

;;;###autoload
(defun ora-mu4e-compose-hook ()
  (setq completion-at-point-functions
        '(mu4e~compose-complete-contact t)))

(provide 'ora-mu4e)
