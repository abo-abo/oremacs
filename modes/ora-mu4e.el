(require 'whicher)
(require 'smime)
(use-package mu4e
    :load-path "~/git/mu/mu4e")
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
(define-key mu4e-headers-mode-map "J" 'mu4e-headers-next)
(define-key mu4e-headers-mode-map "K" 'mu4e-headers-prev)
(define-key mu4e-view-mode-map "J" 'mu4e-view-headers-next)
(define-key mu4e-view-mode-map "K" 'mu4e-view-headers-prev)
(define-key mu4e-view-mode-map (kbd "C--") nil)

;;;###autoload
(defun ora-mu4e-headers-hook ())

;;;###autoload
(defun ora-mu4e-compose-hook ()
  (setq truncate-lines t)
  (setq completion-at-point-functions
        '(mu4e~compose-complete-contact t)))

(setq mm-7bit-chars "\x20-\x7f\n\r\t\x7\x8\xb\xc\x1f")
(setq message-send-hook '(ora-smime-sign))

(defun ora--makemime-token (regex)
  (if (looking-at regex)
      (prog1 (match-string-no-properties 1)
        (goto-char (match-end 0)))
    (error "Expected '%s'" regex)))

(defun ora--makemime ()
  (let ((boundary (concat "----" "Part_1")))
    (message-goto-body)
    (insert
     (format "Content-Type: multipart/mixed; boundary=\"%s\"" boundary)
     "\n\n\n")
    (insert "--" boundary "\n")
    (insert
     "Content-Type: text/plain; charset=\"utf-8\""
     "\n"
     "Content-Transfer-Encoding: quoted-printable"
     "\n\n")
    (while (search-forward "<#part" nil t)
      (let ((beg (match-beginning 0))
            type filename disposition)
        (setq type (ora--makemime-token " *type=\"\\([^\"]+\\)\""))
        (setq filename (ora--makemime-token " *filename=\"\\([^\"]+\\)\""))
        (setq disposition (ora--makemime-token " *disposition=\\(attachment\\|inline\\)"))
        (search-forward "<#/part>")
        (delete-region beg (point))
        (insert "--" boundary "\n")
        (insert
         (shell-command-to-string
          (format "makemime -c \"%s\" -a \"Content-Disposition: %s; filename=%s\" -N %s %s"
                  type disposition filename
                  (shell-quote-argument (file-name-nondirectory filename))
                  (shell-quote-argument filename))))
        (insert "\n")))
    (insert "--" boundary "--" "\n")
    (setq message-inhibit-body-encoding t)))

(defun ora-smime-sign ()
  (ora--makemime)
  (let* ((from (message-field-value "From"))
         (keyfile
          (cadr
           (cl-find-if
            (lambda (x)
              (string-match (car x) from))
            smime-keys))))
    (when keyfile
      (let ((openssl-args
             (list "smime" "-sign" "-signer" (expand-file-name keyfile))))
        (if (string-match-p "plain.pem$" keyfile)
            (apply #'call-process-region
                   (message-goto-body) (point-max) smime-openssl-program t t nil
                   openssl-args)
          (let ((passphrase (smime-ask-passphrase keyfile)))
            (unwind-protect
                 (progn
                   (setenv "GNUS_SMIME_PASSPHRASE" passphrase)
                   (apply #'call-process-region
                          (message-goto-body) (point-max) smime-openssl-program t t nil
                          (append openssl-args '("-passin" "env:GNUS_SMIME_PASSPHRASE"))))
              (setenv "GNUS_SMIME_PASSPHRASE" "")))))
      ;; we already specify MIME-Version here, don't let
      ;; `message-encode-message-body' mess it up.
      (setq message-inhibit-body-encoding t)
      (message-goto-body)
      ;; move MIME-Version to headers
      (when (looking-at "MIME-Version: 1.0\nContent-Type.*\n")
        (let ((mime (delete-and-extract-region (point) (match-end 0))))
          (re-search-backward "^--text follows this line--" nil t)
          (insert mime))))))

(provide 'ora-mu4e)
