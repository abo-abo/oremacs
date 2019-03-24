(require 'bash-completion)
(bash-completion-setup)

;;;###autoload
(defun ora-shell-hook ())

(advice-add 'ansi-color-apply-on-region :before 'ora-ansi-color-apply-on-region)

(defun ora-ansi-color-apply-on-region (begin end)
  "Fix progress bars for e.g. apt(8).
Display progress in the mode line instead."
  (let ((end-marker (copy-marker end)))
    (save-excursion
      (goto-char begin)
      (while (re-search-forward "\0337\\(.*\\)\0338" end-marker t)
        (let ((progress (delete-and-extract-region (match-beginning 0) (point))))
          (setq mode-line-process
                (if (string-match "Progress: \\[ *\\([0-9]+\\)%\\]" progress)
                    (list (concat ":%s " (match-string 1 progress) "%%%% "))
                  '(":%s")))
          (force-mode-line-update))))))

(provide 'ora-shell)
