(require 'markdown-mode)

(define-key markdown-mode-map (kbd "C-c C-c") 'server-edit)
(define-key markdown-mode-map (kbd "<tab>") nil)
(define-key markdown-mode-map (kbd "C-;") 'tiny-expand)
(define-key markdown-mode-map (kbd "C-c r") 'markdown-pre-region)
(define-key markdown-mode-map (kbd "C-c s") 'ora-markdown-stack-block)
(define-key markdown-mode-map (kbd "M-p") nil)
(define-key markdown-mode-map (kbd "C-M-i") nil)

;;;###autoload
(defun ora-markdown-hook ()
  (flyspell-mode)
  (pandoc-mode))

(setq markdown-metadata-key-face 'default)
(setq markdown-metadata-value-face 'default)

;;;###autoload
(defun ora-markdown-cleanup ()
  "Transform Elisp-style code references to Markdown-style."
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward "`[^\n ]+\\('\\)" nil t)
    (replace-match "`" nil nil nil 1)))

(defun ora-markdown-stack-block (beg end)
  (interactive "r")
  (let ((str (buffer-substring-no-properties beg end)))
    (delete-region beg end)
    (insert
     "<!-- language: lang-cl -->\n\n    "
     (mapconcat
      #'identity
      (split-string str "\n" t)
      "\n    "))))
