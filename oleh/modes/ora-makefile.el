(require 'make-mode)

(define-key makefile-mode-map [f5] 'save-and-compile)
(define-key makefile-mode-map (kbd "C-M-i") nil)

;;;###autoload
(defun ora-makefile-hook ())

(defun save-and-compile ()
  (interactive)
  (save-buffer)
  (compile "make -j4")
  (pop-to-buffer next-error-last-buffer))
