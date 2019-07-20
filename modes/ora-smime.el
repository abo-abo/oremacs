(require 'smime)
(require 'mml)

(setq message-send-hook '(ora-smime-sign))
(setq mm-7bit-chars "\x20-\x7f\n\r\t\x7\x8\xb\xc\x1f")

(defun ora--makemime-token (regex)
  (if (looking-at regex)
      (prog1 (match-string-no-properties 1)
        (goto-char (match-end 0)))
    (error "Expected '%s'" regex)))

(defun ora--message-parts ()
  (let (pt res)
    (message-goto-body)
    (setq pt (point))
    (while (search-forward "<#part" nil t)
      (let ((mb (match-beginning 0))
            type filename disposition)
        (setq type (ora--makemime-token " *type=\"\\([^\"]+\\)\""))
        (setq filename (ora--makemime-token " *filename=\"\\([^\"]+\\)\""))
        (setq disposition (ora--makemime-token " *disposition=\\(attachment\\|inline\\)"))
        (search-forward "<#/part>")
        (push (list "text/plain" (buffer-substring-no-properties pt mb)) res)
        (push (list type filename disposition) res)
        (setq pt (point))))
    (push (list "text/plain" (string-trim (buffer-substring-no-properties pt (point-max)))) res)
    (nreverse res)))

(defun ora--makemime ()
  (let ((parts (ora--message-parts))
        (boundary (concat "----" "UNIQUE_BOUNDARY")))
    (message-goto-body)
    (delete-region (point) (point-max))
    (insert
     (format "Content-Type: multipart/mixed; boundary=\"%s\"" boundary)
     "\n\n\n")
    (dolist (part parts)
      (if (equal (car part) "text/plain")
          (progn
            (insert "--" boundary "\n")
            (insert
             "Content-Type: text/plain; charset=\"utf-8\"; format=\"flowed\""
             "\n"
             "Content-Transfer-Encoding: quoted-printable"
             "\n\n")
            (insert (nth 1 part)))
        (let* ((type (nth 0 part))
               (filename (nth 1 part))
               (disposition (nth 2 part))
               (name (file-name-nondirectory filename)))
          (insert "--" boundary "\n")
          (insert "Content-Type: " type "; name=\"" name "\"\n")
          (insert "Content-Disposition: " disposition "; filename=" name "\n")
          (insert "Content-Transfer-Encoding: base64\n\n")
          (insert
           (with-temp-buffer
             (insert-file-contents-literally filename)
             (base64-encode-region (point-min) (point-max))
             (buffer-string)))
          (insert "\n"))))
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

(defmacro ora-with-smime-pass (keyfile &rest body)
  (declare (indent 1))
  `(unwind-protect
        (progn
          (setenv "GNUS_SMIME_PASSPHRASE" (smime-ask-passphrase ,keyfile))
          ,@body)
     (setenv "GNUS_SMIME_PASSPHRASE" "")))

(defun ora-smime-sign ()
  (setq message-inhibit-body-encoding nil)
  ;; (mml-to-mime)
  (ora--makemime)
  (let ((keyfile (ora--smime-keyfile)))
    (when keyfile
      (let ((openssl-args
             (list "cms" "-sign" "-signer" (expand-file-name keyfile))))
        (if (ora-file-matches-p keyfile "-----BEGIN RSA PRIVATE KEY-----")
            (apply #'call-process-region
                   (message-goto-body) (point-max) smime-openssl-program t t nil
                   openssl-args)
          (ora-with-smime-pass keyfile
            (apply #'call-process-region
                   (message-goto-body) (point-max) smime-openssl-program t t nil
                   (append openssl-args '("-passin" "env:GNUS_SMIME_PASSPHRASE"))))))
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
  (let ((keyfile (cadr (assoc user-mail-address smime-keys))))
    (unless keyfile
      (user-error "`smime-keys' has no entry for `user-mail-address'."))
    (let* ((no-pass (ora-file-matches-p keyfile "-----BEGIN RSA PRIVATE KEY-----"))
           (passin-args (if no-pass "" "-passin env:GNUS_SMIME_PASSPHRASE "))
           (cmd (concat
                 "openssl cms -decrypt " passin-args
                 "-in "
                 (buffer-file-name)
                 " -inform DER -inkey "
                 (expand-file-name keyfile)
                 " | openssl cms -verify 2>/dev/null"
                 " | sed -r -e 's/=?//g'"
                 ;; Microsoft's email does style=3D'color:red', why?
                 " | sed -r -e 's/=3D/=/g'"))
           (res (if no-pass
                    (shell-command-to-string cmd)
                  (ora-with-smime-pass keyfile
                    (shell-command-to-string cmd)))))
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert res)
        (goto-char (point-min))
        (set-buffer-modified-p nil)
        (read-only-mode 1)))))

(add-to-list 'auto-mode-alist
             '("smime.p7m\\'" . ora-smime-decrypt))

(provide 'ora-smime)
