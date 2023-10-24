(setq lsp-auto-configure nil)
(setq lsp-warn-no-matched-clients nil)
(require 'lsp)
(require 'lsp-ui)
;; `lsp--auto-configure'
(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-modeline-code-actions-enable nil)
(setq lsp-modeline-diagnostics-enable nil)
(setq lsp-modeline-workspace-status-enable nil)
(setq lsp-diagnostics-provider nil)

(setq lsp-auto-guess-root t)

(setq lsp-ui-doc-position 'at-point)
(define-key lsp-ui-mode-map (kbd "C-1") 'lsp-ui-doc-toggle)

(setq lsp-headerline-breadcrumb-enable-diagnostics nil)
(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
(add-hook 'lsp-configure-hook 'lsp-completion--enable)

(global-set-key (kbd "C-<") lsp-command-map)

(defun lsp-mode-line ()
  "Construct the mode line text."
  (concat
   " LSP"
   (unless (lsp-workspaces)
     (propertize "[Disconnected]" 'face 'warning))))

(setq lsp-clients-clangd-executable "/usr/bin/clangd-8")

(require 'pora-lsp nil t)
(provide 'ora-lsp)
