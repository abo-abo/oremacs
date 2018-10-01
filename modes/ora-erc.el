(require 'erc)

(setq erc-server "localhost")
(setq erc-nick "oleh")
(setq erc-port 6667)
(setq erc-accidental-paste-threshold-seconds nil)
(setq erc-prompt-for-password nil)
(defvar ora-erc-buddies)

;;;###autoload
(defun ora-erc-hook ()
  (let ((fly (assoc (buffer-name) ora-erc-buddies)))
    (when fly
      (toggle-input-method)
      (ispell-change-dictionary (cadr fly))
      (flyspell-mode 1))))

(provide 'ora-erc)
