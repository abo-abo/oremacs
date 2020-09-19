(require 'wgrep)
(setq wgrep-auto-save-buffer t)

(define-key grep-mode-map (kbd "C-x C-q") 'wgrep-change-to-wgrep-mode)
(define-key grep-mode-map (kbd "C-c C-c") 'wgrep-finish-edit)

(provide 'ora-grep)
