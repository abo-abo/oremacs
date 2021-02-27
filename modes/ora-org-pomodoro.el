(require 'org-agenda)

(use-package gtk-pomodoro-indicator
  :config
  (gpi-setup))

(use-package org-pomodoro
  :config
  (setq org-pomodoro-ask-upon-killing nil))

;;;###autoload
(defun ora-org-clock-out ()
  (interactive)
  (when (org-pomodoro-active-p)
    (org-clock-out nil t)
    (org-pomodoro-kill)))

(define-key org-agenda-mode-map "p" 'ora-org-pomodoro)

(defun ora-org-pomodoro ()
  (interactive)
  (if (eq major-mode 'org-agenda-mode)
      (progn
        (worf-pomodoro)
        (org-save-all-org-buffers))
    (worf-pomodoro)))

(require 'pora-org-pomodoro nil t)
(provide 'ora-org-pomodoro)
