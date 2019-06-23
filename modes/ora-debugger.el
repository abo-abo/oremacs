(setq debugger-stack-frame-as-list t)

(define-key debugger-mode-map (kbd "J") 'debugger-jump)
(define-key debugger-mode-map (kbd "j") 'next-line)
(define-key debugger-mode-map (kbd "k") 'previous-line)
(define-key debugger-mode-map (kbd "Q") 'top-level)
(define-key debugger-mode-map (kbd "q") 'bury-buffer)
(define-key debugger-mode-map (kbd "Z") 'ora-debug-set-frame)

(defun ora-debug-set-frame ()
  (interactive)
  (let* ((debugger-window (selected-window))
         (nframe (1+ (debugger-frame-number 'skip-base)))
         (base (debugger--backtrace-base))
         (locals (backtrace--locals nframe base))
         wnd)
    (push-button)
    (setq wnd (current-window-configuration))
    (run-with-timer
     0 nil
     `(lambda ()
        (mapc (lambda (x!) (set (car x!) (cdr x!))) ',locals)
        (set-window-configuration ,wnd)
        (when (get-buffer "*Backtrace*")
          (kill-buffer "*Backtrace*"))))
    (top-level)))

;;;###autoload
(defun ora-debugger-hook ())

(provide 'ora-debugger)
