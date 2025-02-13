(require 'comint)

(define-key comint-mode-map (kbd "<tab>") 'completion-at-point)
(define-key comint-mode-map (kbd "C-k") 'ora-comint-kill-line)
(define-key comint-mode-map (kbd "M-.") 'ora-comint-goto-link)


;;;###autoload
(defun ora-comint-hook ()
  (setq completion-at-point-functions
        '(bash-completion-dynamic-complete
          comint-c-a-p-replace-by-expanded-history
          shell-environment-variable-completion
          shell-command-completion
          shell-c-a-p-replace-by-expanded-directory
          shell-filename-completion
          comint-filename-completion))
  (make-variable-buffer-local 'comint-preoutput-filter-functions)
  (shell-dirtrack-mode 1))

(defun ora-fontify-shell-links (str)
  (replace-regexp-in-string
   "\e\\]8;[^;]*;\\(.*?\\)\e\\\\\\(.*?\\)\e\\]8;;\e\\\\?"
   (lambda (s)
     (let ((url (match-string-no-properties 1 s))
           (text (match-string-no-properties 2 s)))
       (propertize text
                   'face 'url
                   'url url
                   'action (lambda (x) (browse-url (button-get x 'url)))
                   'category 'default-button
                   'button '(t))))
   str))

(add-hook 'comint-preoutput-filter-functions 'ora-fontify-shell-links)

(defun ora-comint-kill-line ()
  (interactive)
  (let* ((offset (- (point) (line-beginning-position)))
         (line (buffer-substring-no-properties
                (line-beginning-position) (line-end-position)))
         (bnd (with-temp-buffer
                (sh-mode)
                (insert line)
                (goto-char (point-min))
                (forward-char offset)
                (lispy--bounds-string))))
    (if bnd
        (kill-region
         (point) (+ (line-beginning-position) (cdr bnd) -2))
      (kill-region (point) (line-end-position)))))

(defun ora-comint-goto-link ()
  (interactive)
  (let (fname line)
    (when (cond ((save-excursion
                   (beginning-of-line)
                   (looking-at "\\(/?\\)\\(.*\\):\\([0-9]+\\):"))
                 (setq root-p (match-string-no-properties 1))
                 (setq fname (match-string-no-properties 2))
                 (setq line (match-string-no-properties 3))
                 (if (string= root-p "")
                     (setq fname (expand-file-name fname))
                   (setq fname (concat root-p fname))))
                ((save-excursion
                   (beginning-of-line)
                   (re-search-forward "lineno=\\([0-9]+\\).*pathname=\\(.*\\) pid" (line-end-position) t))
                 (setq line (match-string-no-properties 1))
                 (setq fname (match-string-no-properties 2))))
      (xref-push-marker-stack)
      (find-file fname)
      (goto-char (point-min))
      (forward-line (1- (string-to-number line)))
      (lpy-beginning-of-line))))

(provide 'ora-comint)
