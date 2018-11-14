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

;; don't change the modeline every time someone goes online/offline
(defun erc-modified-channels-object (strings)
  "Generate a new `erc-modified-channels-object' based on STRINGS."
  (if strings
      (concat (if (eq erc-track-position-in-mode-line 'after-modes)
                  "[" " [")
              (mapconcat 'identity (nreverse (delete "&" strings)) ",")
              (if (eq erc-track-position-in-mode-line 'before-modes)
                  "] " "]"))
    ""))

;;;###autoload
(defun bitlbee ()
  (interactive)
  (erc
   :server "localhost"
   :nick "oleh"))

(provide 'ora-erc)
