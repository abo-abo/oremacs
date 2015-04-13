(require 'eshell)

;;;###autoload
(defun eshell-this-dir ()
  "Open or move eshell in `default-directory'."
  (interactive)
  (unless (get-buffer eshell-buffer-name)
    (eshell))
  (switch-to-buffer eshell-buffer-name)
  (goto-char (point-max))
  (eshell-kill-input)
  (insert (format "cd %s" default-directory))
  (eshell-send-input)
  (goto-char (point-max)))
