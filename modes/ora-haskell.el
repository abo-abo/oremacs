(require 'haskell)
(require 'lpy-soap)
(require 'company-dabbrev)

(defun ora-haskell-comment-insert ()
  (insert "-- "))

;;;###autoload
(defun ora-haskell-hook ()
  (setq comment-insert-comment-function #'ora-haskell-comment-insert)
  (company-mode))


(require 'pora-haskell nil t)

(provide 'ora-haskell)
