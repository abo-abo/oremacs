;;;###autoload
(defun ora-calc-hook ())

(defun ora-copy-calc-top ()
  "Copy the thing at the top of the calc stack."
  (interactive)
  (let ((val (calc-top)))
    (kill-new (if (Math-scalarp val)
                  (math-format-number val)
                (math-format-flat-expr-fancy val 0)))))

(define-key calc-mode-map (kbd "M-w") #'ora-copy-calc-top)

(provide 'ora-calc)
