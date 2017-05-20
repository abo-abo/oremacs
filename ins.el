(require 'lispy)

;;;###autoload
(defun ora-quotes (arg)
  (interactive "P")
  (let (bnd)
    (cond ((eq major-mode 'term-mode)
           (term-send-raw-string "\"\"")
           (term-send-raw-string ""))

          ((region-active-p)
           (let ((beg (region-beginning))
                 (end (region-end)))
             (deactivate-mark)
             (goto-char beg)
             (insert "\"")
             (goto-char (1+ end))
             (insert "\"")))

          ((and (not (eq major-mode 'org-mode))
                (setq bnd (lispy--bounds-string))
                (not (eq (car bnd)
                         (point)))
                (not arg))
           (insert "\\\"\\\"")
           (backward-char 2))

          ((and (eq (char-before) ?<)
                (eq (char-after) ?>))
           (delete-region (1- (point))
                          (1+ (point)))
           (insert "\"\"")
           (backward-char))

          (t
           (insert "\"\"")
           (backward-char)))))

;;;###autoload
(defun ora-single-quotes (arg)
  (interactive "P")
  (if (region-active-p)
      (lispy--surround-region "'" "'")
    (insert "''")
    (backward-char)))

;;;###autoload
(defun ora-parens ()
  (interactive)
  (cond ((eq major-mode 'term-mode)
         (term-send-raw-string "()")
         (term-send-raw-string ""))
        ((region-active-p)
         (lispy--surround-region "(" ")"))
        ((looking-back "\\\\")
         (insert "(\\)")
         (backward-char 2))
        (t
         (if (looking-back "\\(if\\)\\|\\(for\\)\\|\\(switch\\)\\|\\(while\\)")
             (insert " "))
         (insert "()")
         (backward-char))))

;;;###autoload
(defun ora-dollars ()
  (interactive)
  (cond ((region-active-p)
         (lispy--surround-region "$" "$"))
        (t
         (insert "$$")
         (backward-char))))

;;;###autoload
(defun ora-brackets ()
  (interactive)
  (cond ((eq major-mode 'term-mode)
         (term-send-raw-string "[]")
         (term-send-raw-string ""))
        ((region-active-p)
         (lispy--surround-region "[" "]"))
        (t
         (insert "[]")
         (backward-char))))

;;;###autoload
(defun ora-braces ()
  (interactive)
  (if (region-active-p)
      (progn
        (lispy--surround-region "{" "}")
        (backward-char)
        (forward-list))
    (insert "{}")
    (backward-char)))

;;;###autoload
(defun ora-braces-c++ ()
  "Insert {}.
Threat is as function body when from endline before )"
  (interactive)
  (cond ((eq major-mode 'term-mode)
         (term-send-raw-string "{}")
         (term-send-raw-string ""))
        ((looking-back "\\()\\|try\\|else\\|const\\|:\\)$")
         (insert " {\n\n}")
         (indent-according-to-mode)
         (forward-line -1)
         (indent-according-to-mode))
        ((region-active-p)
         (let ((beg (region-beginning))
               (end (region-end)))
           (deactivate-mark)
           (goto-char beg)
           (insert "{")
           (goto-char (1+ end))
           (insert "}")))
        (t
         (insert "{}")
         (indent-according-to-mode)
         (backward-char))))

;;;###autoload
(defun ora-angles-c++ ()
  (interactive)
  "Insert <>.
Take care of nested C++ templates."
  (cond
    ((looking-back "^")
     (insert "#include <>"))
    ((looking-back "template")
     (insert " <>"))
    ((looking-at ">")
     (insert "<> ")
     (backward-char))
    (t (insert "<>")))
  (backward-char))

;;;###autoload
(defun ora-angles ()
  (interactive)
  "Insert <>."
  (cond ((memq major-mode '(c++-mode c-mode))
         (ora-angles-c++))
        ((region-active-p)
         (lispy--surround-region "<" ">"))
        (t
         (insert "<>")
         (backward-char))))

(provide 'ins)
