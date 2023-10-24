(require 'sql-indent)

;;;###autoload
(defun ora-sql-hook ()
  (sqlind-minor-mode)
  ;; setup escape character
  (modify-syntax-entry ?\\ "\\" sql-mode-syntax-table)
  (modify-syntax-entry ?\\ "\\" sqlind-syntax-table))

(defun ora-sql-string-linebreak ()
  (interactive)
  (cond ((lispy--in-string-p)
         (insert "' ||")
         (newline-and-indent)
         (insert "'"))
        (t
         (default-indent-new-line))))

(define-key sql-mode-map (kbd "M-j") 'ora-sql-string-linebreak)

(require 'pora-sql nil t)
(provide 'ora-sql)
