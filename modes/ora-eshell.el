(require 'eshell)

(defun eshell-completion-at-point ()
  (let* ((t1 (comint-completion-at-point))
         (beg (nth 0 t1))
         (end (nth 1 t1))
         (str (buffer-substring-no-properties beg end))
         (collection (nth 2 t1))
         (comps
          (completion-all-completions str collection predicate (- end beg))))
    (if comps
        t1
      (elisp-completion-at-point))))

;;;###autoload
(defun ora-eshell-hook ()
  (define-key eshell-mode-map (kbd "<tab>") 'completion-at-point)
  (setq completion-at-point-functions '(eshell-completion-at-point)))

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
