(require 'sql-indent)

(require 'ejc-sql)
(require 'ejc-company)
(push 'ejc-company-backend company-backends)

;;;###autoload
(defun ora-sql-hook ()
  (sqlind-minor-mode)
  (company-mode))

(add-hook 'org-babel-execute-sql-command-hook #'ora-ob-sql-command-snowflake)

(defun ora-ob-sql-command-snowflake (in-file out-file params)
  (when (string= (cdr (assq :engine params)) "snowflake")
    (format "cook :front snow %s %s"
            (org-babel-process-file-name in-file)
            (org-babel-process-file-name out-file))))

(provide 'ora-sql)
