(require 'whicher)
(require 'ora-smime)
(use-package mu4e
  :load-path "~/git/Emacs/mu/mu4e")
(setq mu4e-maildir "~/mail/work")
(setq mu4e-html2text-command (whicher "w3m -T text/html"))
(setq mu4e-drafts-folder "/Drafts")
(setq mu4e-sent-folder "/Sent Items")
(setq mu4e-trash-folder "/Trash")
(setq mu4e-get-mail-command (whicher "mbsync -a"))
(setq message-kill-buffer-on-exit t)
(setq mu4e-confirm-quit nil)
(setq mu4e-headers-date-format "%d-%m-%Y %H:%M")
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

;; don't save message to Sent Messages, IMAP server takes care of that
(setq mu4e-sent-messages-behavior 'delete)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.
(setq mu4e-maildir-shortcuts
      '(("/INBOX" . ?i)
        ("/Archive" . ?a)
        ("/Trash" . ?t)))

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
  (setq truncate-lines t)
  (setq completion-at-point-functions
        '(mu4e~compose-complete-contact t)))

(require 'pora-mu4e nil t)

(provide 'ora-mu4e)
