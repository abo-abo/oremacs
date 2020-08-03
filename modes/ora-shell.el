(require 'shell)
(require 'bash-completion)
(bash-completion-setup)

;;;###autoload
(defun ora-shell-hook ())

(define-key shell-mode-map (kbd "C-r") 'counsel-shell-history)
(define-key shell-mode-map (kbd "C-k") 'ora-shell-kill-line)

(ora-advice-add 'ansi-color-apply-on-region :before 'ora-ansi-color-apply-on-region)

(defun ora-ansi-color-apply-on-region (begin end)
  "Fix progress bars for e.g. apt(8).
Display progress in the mode line instead."
  (let ((end-marker (copy-marker end))
        mb)
    (save-excursion
      (goto-char (copy-marker begin))
      (while (re-search-forward "]0;" end-marker t)
        (setq mb (match-beginning 0))
        (when (re-search-forward ":~" end-marker t)
          (delete-region mb (point))))
      (goto-char (copy-marker begin))
      (while (re-search-forward "\0337" end-marker t)
        (setq mb (match-beginning 0))
        (when (re-search-forward "\0338" end-marker t)
          (let ((progress (buffer-substring-no-properties
                           (+ mb 2) (- (point) 2))))
            (delete-region mb (point))
            (ora-apt-progress-message progress)))))))

(defun ora-apt-progress-message (progress)
  ;; (setq mode-line-process
  ;;       (if (string-match "Progress: \\[ *\\([0-9]+\\)%\\]" progress)
  ;;           (list (concat ":%s " (match-string 1 progress) "%%%% "))
  ;;         '(":%s")))
  ;; (force-mode-line-update)
  (message
   (replace-regexp-in-string
    "%" "%%"
    (ansi-color-apply progress))))

(defun ora-shell-kill-line ()
  "When in a string, kill until the end of string.
Otherwise, behave like `kill-line'."
  (interactive)
  (let ((offset (- (point) (line-beginning-position)))
        (str (buffer-substring-no-properties
              (line-beginning-position)
              (point-max))))
    (delete-region
     (line-beginning-position)
     (point-max))
    (insert
     (with-temp-buffer
       (python-mode)
       (insert str)
       (goto-char (1+ offset))
       (lpy-kill-line)
       (buffer-string)))
    (goto-char (+ offset (line-beginning-position)))))

(provide 'ora-shell)
