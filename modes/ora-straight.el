;; (setq straight-check-for-modifications nil)
;; (setq straight-use-package-by-default t)
;; (straight-use-package 'use-package)

(require 'cl-seq)
(cl-reduce (lambda (a b)) '(0 0))

(defun ora-straight-reload-all ()
  (interactive)
  (let ((build-dir "~/.emacs.d/straight/build/"))
    (dolist (pkg (delete "cl-lib" (delete ".." (delete "." (directory-files build-dir)))))
      (let* ((dir (expand-file-name pkg build-dir))
             (autoloads (car (directory-files dir t "-autoloads.el"))))
        (add-to-list 'load-path dir)
        (when autoloads
          (load autoloads t 'nomessage))))))

(ora-straight-reload-all)

(provide 'ora-straight)
