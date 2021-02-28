(require 'subword)
(require 'latex)
(require 'doc-view)
(require 'tex-site)

(csetq LaTeX-math-abbrev-prefix "β")
(csetq reftex-ref-macro-prompt nil)
(setq reftex-bibliography-commands '("addbibresource" "bibliography" "nobibliography" "setupbibtex\\[.*?database="))
(csetq LaTeX-command-style '(("" "%(PDF)%(latex) -file-line-error %S%(PDFout)")))
(add-to-list 'TeX-command-list
             '("make" "make" TeX-run-TeX nil (latex-mode doctex-mode) :help "Run make"))
(setcdr (assoc "tabular" LaTeX-indent-environment-list)
        '(LaTeX-indent-tabular))

(add-to-list 'insert-pair-alist '(?$ ?$))
(setq LaTeX-default-environment "equation")
(setq LaTeX-math-insert-function
      (lambda (symbol)
        (interactive)
        (insert (concat "\\" symbol))))
(setq LaTeX-command "latex -shell-escape -synctex=1")

(define-key LaTeX-mode-map [f5] 'ora-pdflatex-quiet)
(define-key LaTeX-mode-map (kbd "M-l") 'TeX-view)
(define-key LaTeX-mode-map (kbd "C-c 9") 'reftex-label)
(define-key LaTeX-mode-map (kbd "C-c 0") 'reftex-reference)
(define-key LaTeX-mode-map (kbd "C-c 7") 'reftex-view-crossref)
(define-key LaTeX-mode-map (kbd "C-c C-w") 'latex-wrap-region)
(define-key LaTeX-mode-map (kbd "C-c C-o") 'latex-insert-block)
(define-key LaTeX-mode-map (kbd "$") 'insert-pair)
(define-key LaTeX-mode-map (kbd "|") 'self-insert-command)
(define-key LaTeX-mode-map (kbd "C-M-i") 'iedit-mode)
(define-key LaTeX-mode-map (kbd "C-c ~") 'LaTeX-math-mode)

;;;###autoload
(defun ora-latex-hook ()
  (TeX-PDF-mode)
  (auto-complete-mode)
  (subword-mode)
  (reftex-mode)
  (TeX-source-correlate-mode)
  (LaTeX-math-mode)
  (setq TeX-engine 'xetex))

(defun ora-run-bibtex ()
  (interactive)
  (let ((file (file-name-nondirectory
               (file-name-sans-extension
                (buffer-file-name)))))
    (TeX-run-BibTeX
     "BibTeX"
     (format "bibtex %s" file)
     file)))

(setq TeX-engine 'default)
(setq-default TeX-engine 'xetex)
(defun ora-pdflatex-quiet ()
  "Compile .tex file and show .pdf file."
  (interactive)
  (dolist (wnd (window-list))
    (save-buffer (window-buffer wnd)))
  (TeX-command "LaTeX" 'TeX-master-file -1))

(eval-after-load 'font-latex
  '(add-to-list 'font-latex-match-function-keywords
    '("newcommandx" "*|{\\[[{")))

;;* Font lock
(csetq font-latex-user-keyword-classes
       '(("intertext" ("intertext") (:family "font-lock-type-face") (command 1))
         ("newcommandx" ("newcommandx" "*|{\\[[{") (:family "font-lock-function-name-face") (command 1))
         ("renewcommandx" ("renewcommandx") (:family "font-lock-type-face") (command 1))))

(defvar font-lock-simple-face
  (defface font-lock-simple-face '((nil (:foreground "#000000")) (t nil))
    "simple face."
    :group 'font-lock-highlighting-faces))

(font-lock-add-keywords 'latex-mode
                        '(("\\\\intertext{\\([^}]*\\)" 1 font-lock-simple-face prepend)
                          ("\\\\text{\\([^}]*\\)" 1 font-lock-simple-face prepend)))
(mapc
 (lambda (x)
   (font-lock-add-keywords
    'latex-mode
    (ora-fontify-glyph (concat "\\\\" (car x) " ") (cadr x))))
 '(("partial" "∂")
   ("nabla" "∇")
   ("varphi" "φ")
   ("varepsilon" "ε")
   ("cdot" "⋅")
   ("forall" "∀")
   ("|" "||")
   ("in" "∊")
   ("ge" "≥")
   ("le" "≤")
   ("cap" "∩")
   ("cup" "∪")
   ("Delta" "Δ")
   ("setminus" "∖")))

(defadvice TeX-source-correlate-sync-source (after ora-raise-tex activate)
  (require 'org-fu)
  (orfu-raise-frame))

(add-to-list 'TeX-view-program-selection '(output-pdf "PDF Tools"))

(provide 'ora-latex)
