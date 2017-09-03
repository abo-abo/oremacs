(require 'compile)

;;;###autoload
(defun ora-compilation-hook ())

(define-key compilation-mode-map (kbd "j") 'ora-compilation-next)
(define-key compilation-mode-map (kbd "k") 'ora-compilation-prev)

(defun ora-compilation-next ()
  (interactive)
  (let ((pt (point)))
    (forward-line)
    (if (re-search-forward "[0-9]: info" nil t)
        (beginning-of-line)
      (goto-char pt))
    (save-selected-window
      (compile-goto-error))))

(defun ora-compilation-prev ()
  (interactive)
  (when (re-search-backward "[0-9]: info" nil t)
    (beginning-of-line)
    (save-selected-window
      (compile-goto-error))))
