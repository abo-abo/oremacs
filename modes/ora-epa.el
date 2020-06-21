(require 'epa-hook)

(setq-default epa-file-encrypt-to '("8EAAF3D4DD64FBB5"))

(defun ora-epa-user-id (key)
  (epg-user-id-string
   (car (epg-key-user-id-list key))))

(defun epa-select-keys (context prompt &optional names secret)
  "Display a user's keyring and ask him to select keys.
CONTEXT is an epg-context.
PROMPT is a string to prompt with.
NAMES is a list of strings to be matched with keys.  If it is nil, all
the keys are listed.
If SECRET is non-nil, list secret keys instead of public keys."
  (let* ((keys (epg-list-keys context names secret))
         (id (ivy-read prompt
                       (mapcar #'ora-epa-user-id keys))))
    (cl-remove-if-not (lambda (k) (equal (ora-epa-user-id k) id)) keys)))

(ora-advice-add 'epa-progress-callback-function :around #'ignore)

(provide 'ora-epa)
