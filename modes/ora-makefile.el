(require 'make-mode)

(define-key makefile-mode-map (kbd "C-<f5>") 'save-and-compile)
(define-key makefile-mode-map (kbd "<f5>") 'helm-make)
(define-key makefile-mode-map (kbd "C-M-i") nil)

;;;###autoload
(defun ora-makefile-hook ()
  (semantic-mode -1))

(defun save-and-compile ()
  (interactive)
  (save-buffer)
  (compile "make -j4")
  (pop-to-buffer next-error-last-buffer))

(use-package helm-make
  :commands (helm-make helm-make-projectile)
  :config
  (setq helm-make-completion-method 'ivy)
  (setq helm-make-named-buffer nil)
  (require 'ansi-color)
  (defun ora-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  :hook (compilation-filter . ora-colorize-compilation-buffer))

(defun ora-helm-make-compile-function (cmd)
  (if (string-match (concat "git/monorepo/ -j[0-9] \\("
                            (regexp-opt '("m.pgcli"))
                            "\\)")
                    cmd)
      (let* ((item (match-string 1 cmd))
             (buf (vterm--internal
                   #'pop-to-buffer-same-window
                   (concat vterm-buffer-name " " item))))
        (with-current-buffer buf
          (vterm-insert cmd)
          (vterm-send-return))
        buf)
    (helm-make-compile-function-compile cmd)))

(setq helm-make-compile-function #'ora-helm-make-compile-function)

(provide 'ora-makefile)
