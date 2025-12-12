(require 'vterm)

;;;###autoload
(defun ora-vterm-hook ()
  ;; (setq-local auto-hscroll-mode nil)
  )

(defun ora-vterm-parens ()
  (interactive)
  (vterm-insert "()")
  (backward-char))

(defun ora-vterm-to-copy-mode ()
  (interactive)
  (vterm-copy-mode 1)
  (setq cursor-type t))

(defun ora-vterm-to-main-mode ()
  (interactive)
  (vterm-copy-mode -1)
  (setq cursor-type nil))


(define-key vterm-mode-map (kbd "C-z") 'ora-vterm-to-copy-mode)
(define-key vterm-mode-map (kbd "C-m") 'vterm-send-return)
(define-key vterm-mode-map (kbd "φ") 'ora-vterm-parens)
;; (define-key vterm-mode-map (kbd "<f1> k") 'describe-key)
(define-key vterm-copy-mode-map (kbd "C-z") 'ora-vterm-to-main-mode)
(setq vterm-clear-scrollback-when-clearing t)

(push (list "find-file-below"
            (lambda (path)
              (if-let* ((buf (find-file-noselect path))
                        (window (display-buffer-below-selected buf nil)))
                  (select-window window)
                (message "Failed to open file: %s" path))))
      vterm-eval-cmds)
(diminish 'compilation-shell-minor-mode)
(setq vterm-min-window-width 80)


(provide 'ora-vterm)
