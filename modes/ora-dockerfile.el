;;;###autoload
(defun ora-dockerfile-hook ()
  ;; $ is not a word constituent, this fixed `iedit' etc
  (modify-syntax-entry ?$ ".")
  (modify-syntax-entry ?/ "."))
