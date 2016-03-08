(require 'ido)

;;;###autoload
(defun ora-ido-hook ())

(use-package ido-vertical-mode
    :config
  (setf (nth 0 ido-vertical-decorations) "\n")
  (setf (nth 2 ido-vertical-decorations) "\n")
  (setf (nth 11 ido-vertical-decorations) "\n")
  (ido-vertical-mode 1)
  :ensure t)

;;* Settings
(setq ido-auto-merge-work-directories-length -1)

(when (keymapp ido-buffer-completion-map)
  (define-key ido-buffer-completion-map "η" 'ido-next-match)
  (define-key ido-buffer-completion-map (kbd "C-p") 'ido-fallback-command)
  (define-key ido-buffer-completion-map ";" 'hydra-ido/body))

(when (keymapp ido-file-dir-completion-map)
  (define-key ido-file-dir-completion-map "~" (lambda ()
                                                (interactive)
                                                (ido-set-current-directory "~/")
                                                (setq ido-exit 'refresh)
                                                (exit-minibuffer)))
  (define-key ido-file-dir-completion-map (kbd "φ") 'ido-next-match)
  (define-key ido-file-dir-completion-map (kbd ":") 'ido-prev-match)
  (define-key ido-file-dir-completion-map (kbd "C-y") 'ido-yank))

(when (keymapp ido-common-completion-map)
  (define-key ido-common-completion-map (kbd "DEL") 'ido-backspace)
  (define-key ido-common-completion-map "\C-n" 'ido-next-match)
  (define-key ido-common-completion-map (kbd "\C-p") 'ido-prev-match))

;;* Functions
(defun ido-backspace ()
  "Forward to `backward-delete-char'.
On error (read-only), quit without selecting."
  (interactive)
  (condition-case nil
      (backward-delete-char 1)
    (error
     (minibuffer-keyboard-quit))))

(defun ido-yank ()
  "Forward to `yank'."
  (interactive)
  (if (file-exists-p (current-kill 0))
      (ido-fallback-command)
    (yank)))

(provide 'ora-ido)
