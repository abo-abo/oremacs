(define-key text-mode-map (kbd "C-c C-c") 'server-edit)

;;;###autoload
(defun ora-text-hook ()
  (unless (eq system-type 'windows-nt)
    (flyspell-mode)))
