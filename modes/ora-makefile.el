(require 'make-mode)

(define-key makefile-mode-map (kbd "C-<f5>") 'save-and-compile)
(define-key makefile-mode-map (kbd "<f5>") 'helm-make)
(define-key makefile-mode-map (kbd "C-M-i") nil)

;;;###autoload
(defun ora-makefile-hook ())

(defun save-and-compile ()
  (interactive)
  (save-buffer)
  (compile "make -j4")
  (pop-to-buffer next-error-last-buffer))
