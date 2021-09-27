(setf (cdr (assoc :results org-babel-default-inline-header-args)) "output silent")
(setf (cdr (assoc :results org-babel-default-inline-header-args)) "value replace")

(font-lock-add-keywords
 'org-mode
 '(("\\(src_\\)\\([^[{]+\\)\\(\\(?:\\[:.*\\]\\)?\\)\\({\\)\\([^}]*\\)\\(}\\)"
    ;; src
    (1 'default)
    ;; lang
    (2 'default)
    ;; headers
    (3 'font-lock-comment-face)
    (4 'font-lock-comment-face)
    (5 'default)
    (6 'font-lock-comment-face))))

(provide 'ora-org-babel-inline)
