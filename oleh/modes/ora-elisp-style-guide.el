(setq indent-tabs-mode nil)
(put 'defface 'lisp-indent-function 1)
(put 'define-minor-mode 'lisp-indent-function 1)
(eval-after-load 'cl-indent
  `(progn
     (put 'cl-flet 'common-lisp-indent-function
          (get 'flet 'common-lisp-indent-function))
     (put 'cl-labels 'common-lisp-indent-function
          (get 'labels 'common-lisp-indent-function))
     (put 'if 'common-lisp-indent-function 2)))

(setq lisp-indent-function 'common-lisp-indent-function)
;; (setq lisp-indent-function 'lisp-indent-function)

(provide 'ora-elisp-style-guide)
