(require 'bash-completion)
(bash-completion-setup)

;;;###autoload
(defun ora-shell-hook ())

(advice-add 'ansi-color-apply-on-region :before 'ora-ansi-color-apply-on-region)

(defun ora-ansi-color-apply-on-region (begin end)
  "Fix progress bars for e.g. apt(8).
Display progress in the mode line instead."
  (let ((end-marker (copy-marker end))
        mb)
    (save-excursion
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

(provide 'ora-shell)
