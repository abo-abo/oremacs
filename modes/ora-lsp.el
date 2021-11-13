(require 'lsp)

(setq lsp-auto-guess-root t)
(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)

(global-set-key (kbd "C-<") lsp-command-map)

(defun lsp-mode-line ()
  "Construct the mode line text."
  (concat
   " LSP"
   (unless (lsp-workspaces)
     (propertize "[Disconnected]" 'face 'warning))))

(setq lsp-clients-clangd-executable "/usr/bin/clangd-8")

(provide 'ora-lsp)
