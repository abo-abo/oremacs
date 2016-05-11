(define-key occur-mode-map "k" 'previous-line)
(define-key occur-mode-map (kbd "C-x C-q") 'wgrep-change-to-wgrep-mode)
(define-key occur-mode-map (kbd "C-c C-c") 'wgrep-finish-edit)

;;;###autoload
(defun ora-occur-mode-hook ())

;;;###autoload
(defun ora-occur-hook ())

