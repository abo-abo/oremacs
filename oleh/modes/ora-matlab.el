(require 'matlab-load)
(require 'matlab)

(define-key matlab-mode-map (kbd "C-h") nil)
(define-key matlab-mode-map (kbd "C-M-i") nil)
(define-key matlab-mode-map (kbd "<f5>") 'matlab-run-file)
(define-key matlab-mode-map (kbd "'") 'ora-single-quotes)
(define-key matlab-mode-map (kbd "C-'") (lambda()(interactive)(insert "'")))
(define-key matlab-mode-map (kbd "C-c C-z")
  (lambda ()
    (interactive)
    (delete-other-windows)
    (split-window-below)
    (matlab-shell)))

(require 'soap)
(dolist (k '("=" "+" "-" "<" ">" ","))
  (define-key matlab-mode-map k 'soap-command))

;;;###autoload
(defun ora-matlab-hook ())

(defun matlab-run-file ()
  (interactive)
  (let ((buffer (current-buffer))
        (dir default-directory))
    (unless (matlab-shell-active-p)
      (matlab-shell))
    (switch-to-buffer buffer)
    (save-window-excursion
      (switch-to-buffer (concat "*" matlab-shell-buffer-name "*"))
      (matlab-shell-send-string (format "userpath('%s');\n"
                                        dir)))
    (matlab-shell-save-and-go)))

(setq matlab-fill-code nil)
