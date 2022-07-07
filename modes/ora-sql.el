(require 'sql-indent)

;;;###autoload
(defun ora-sql-hook ()
  (sqlind-minor-mode)
  (company-mode)
  ;; setup escape character
  (modify-syntax-entry ?\\ "\\" sql-mode-syntax-table)
  (modify-syntax-entry ?\\ "\\" sqlind-syntax-table))

(require 'pora-sql nil t)
(provide 'ora-sql)
