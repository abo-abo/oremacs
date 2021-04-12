(add-to-list 'auto-mode-alist '("\\.tex\\'" . TeX-latex-mode))
(add-to-list 'auto-mode-alist '("\\.\\(?:a\\|so\\)\\'" . elf-mode))
(add-to-list 'auto-mode-alist '("\\.cache\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.\\(h\\|inl\\)\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\(stack\\(exchange\\|overflow\\)\\|superuser\\|askubuntu\\|reddit\\|github\\)\\.com[a-z-._0-9]+\\.txt" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.org_archive\\'" . org-mode))
(add-to-list 'auto-mode-alist '("trace.txt\\'" . compilation-mode))
(add-to-list 'auto-mode-alist '("user.txt\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("tmp_github.com" . markdown-mode))

(use-package elf-mode
  :commands elf-mode
  :init
  (add-to-list 'magic-mode-alist (cons "ELF" 'elf-mode)))

(provide 'ora-auto)
