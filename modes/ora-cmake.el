(require 'cmake-mode)

;;;###autoload
(defun ora-cmake-hook ())

(defun cmake-indent ()
  "Indent current line as CMake code."
  (interactive)
  (unless (cmake-line-starts-inside-string)
    (if (bobp)
        (cmake-indent-line-to 0)
      (let (cur-indent)
        (save-excursion
          (beginning-of-line)
          (let ((point-start (point))
                (case-fold-search t) ;; case-insensitive
                token)
            ;; Search back for the last indented line.
            (cmake-find-last-indented-line)
            ;; Start with the indentation on this line.
            (setq cur-indent (current-indentation))
            ;; Search forward counting tokens that adjust indentation.
            (while (re-search-forward cmake-regex-token point-start t)
              (setq token (match-string 0))
              (when (or (string-match (concat "^" cmake-regex-paren-left "$") token)
                        (and (string-match cmake-regex-block-open token)
                             (looking-at (concat "[ \t]*" cmake-regex-paren-left))))
                (setq cur-indent (+ cur-indent cmake-tab-width)))
              (when (string-match (concat "^" cmake-regex-paren-right "$") token)
                (setq cur-indent (- cur-indent cmake-tab-width))))
            (goto-char point-start)
            ;; If next token closes the block, decrease indentation
            (when (or (looking-at cmake-regex-close)
                      (looking-at " *)"))
              (setq cur-indent (- cur-indent cmake-tab-width)))))
        ;; Indent this line by the amount selected.
        (cmake-indent-line-to (max cur-indent 0))))))
