(require 'eww)
(require 'ace-jump-mode)

(defun eww-view-ace ()
  "Select point with ace-jump-mode and make that line the top one."
  (interactive)
  (setq ace-jump-mode-end-hook
        (list (lambda ()
                (setq ace-jump-mode-end-hook)
                (recenter 0))))
  (let ((ace-jump-mode-scope 'window))
    (call-interactively 'ace-jump-char-mode)))

(define-key eww-mode-map "j" 'ora-para-down)
(define-key eww-mode-map "k" 'ora-para-up)
(define-key eww-mode-map "l" 'forward-char)
(define-key eww-mode-map "L" 'eww-back-url)
(define-key eww-mode-map "h" 'backward-char)
(define-key eww-mode-map "v" 'recenter-top-bottom)
(define-key eww-mode-map "V" 'eww-view-source)
(define-key eww-mode-map "m" 'eww-follow-link)
(define-key eww-mode-map "a" 'move-beginning-of-line)
(define-key eww-mode-map "e" 'move-end-of-line)
(define-key eww-mode-map "o" 'ace-link-eww)
(define-key eww-mode-map "y" 'eww)
(define-key eww-mode-map "A" 'eww-view-ace)

;;;###autoload
(defun ora-eww-hook ())
