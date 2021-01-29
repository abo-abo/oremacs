;; (setq straight-check-for-modifications nil)
;; (setq straight-use-package-by-default t)
;; (straight-use-package 'use-package)

(require 'cl-seq)
(cl-reduce (lambda (a b)) '(0 0))

(defun ora-directory-files (dir)
  (delete ".." (delete "." (directory-files dir))))

;;;###autoload
(defun ora-straight-reload-all ()
  (interactive)
  (let* ((build-dir "~/.emacs.d/straight/build/")
         (emacs-git (expand-file-name "git/" emacs-d))
         (git-files (ora-directory-files emacs-git))
         (pkgs (cl-set-difference
                (delete "cl-lib" (ora-directory-files build-dir))
                (append '("cl-lib")
                        (when (member "swiper" git-files)
                          '("counsel" "ivy" "ivy-avy"))
                        git-files)
                :test #'equal)))
    (dolist (pkg pkgs)
      (let* ((dir (expand-file-name pkg build-dir))
             (autoloads (car (directory-files dir t "-autoloads.el"))))
        (add-to-list 'load-path dir)
        (when autoloads
          (load autoloads t 'nomessage))))))

(ora-straight-reload-all)

(provide 'ora-straight)
