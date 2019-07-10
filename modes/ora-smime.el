(require 'smime)
(require 'mml)

(setq message-send-hook '(ora-smime-sign))
(setq mm-7bit-chars "\x20-\x7f\n\r\t\x7\x8\xb\xc\x1f")

(defun ora--makemime-token (regex)
  (if (looking-at regex)
      (prog1 (match-string-no-properties 1)
        (goto-char (match-end 0)))
    (error "Expected '%s'" regex)))

(defun ora--makemime ()
  (let ((boundary (concat "----" "UNIQUE_BOUNDARY")))
    (message-goto-body)
    (insert
     (format "Content-Type: multipart/mixed; boundary=\"%s\"" boundary)
     "\n\n\n")
    (insert "--" boundary "\n")
    (insert
     "Content-Type: text/plain; charset=\"utf-8\"; format=\"flowed\""
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
        (insert "Content-Type: application/pdf; name=\"" (file-name-nondirectory filename) "\"\n")
        (insert "Content-Disposition: attachment; filename=" filename "\n")
        (insert "Content-Transfer-Encoding: base64\n\n")
        (insert
         (with-temp-buffer
           (insert-file-contents-literally filename)
           (base64-encode-region (point-min) (point-max))
           (buffer-string)))
        (insert "\n")))
    (goto-char (point-max))
    (insert "\n--" boundary "--\n")))

(defun ora-file-matches-p (keyfile regexp)
  (with-temp-buffer
    (insert-file-contents-literally keyfile)
    (goto-char (point-min))
    (re-search-forward regexp nil t)))

(defun ora--smime-keyfile ()
  (cadr
   (cl-find-if
    (lambda (x)
      (string-match (car x) (message-field-value "From")))
    smime-keys)))

(defun ora-smime-sign ()
  (setq message-inhibit-body-encoding nil)
  (mml-to-mime)
  (ora--makemime)
  (let ((keyfile (ora--smime-keyfile)))
    (when keyfile
      (let ((openssl-args
             (list "smime" "-sign" "-signer" (expand-file-name keyfile))))
        (if (ora-file-matches-p keyfile "-----BEGIN RSA PRIVATE KEY-----")
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

(defun ora-smime-decrypt ()
  (interactive)
  (let ((inhibit-read-only t)
        (keyfile (cadr (assoc user-mail-address smime-keys))))
    (when (ora-file-matches-p keyfile "-----BEGIN RSA PRIVATE KEY-----")
      (progn
        (erase-buffer)
        (insert
         (shell-command-to-string
          (concat
           "openssl smime -decrypt -in "
           (buffer-file-name)
           " -inform DER -inkey "
           (expand-file-name keyfile)
           " | openssl smime -verify 2>/dev/null"
           " | sed -e 's///g'")))
        (set-buffer-modified-p nil)
        (read-only-mode 1)))))

(add-to-list 'auto-mode-alist
             '("smime.p7m\\'" . ora-smime-decrypt))

(provide 'ora-smime)
