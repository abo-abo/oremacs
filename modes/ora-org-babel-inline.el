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

(font-lock-add-keywords
 'org-mode
 '(("\\({{{results(\\)\\(.*\\)\\()}}}\\)"
    (0
     (progn
       (compose-region (+ (match-beginning 1) 0) (+ (match-beginning 1) 1) "-")
       (compose-region (+ (match-beginning 1) 1) (+ (match-beginning 1) 2) ">")
       (compose-region (+ (match-beginning 1) 2) (match-end 1) " ")
       (compose-region
        (match-beginning 3)
        (match-end 3)
        "."))))))

(provide 'ora-org-babel-inline)
