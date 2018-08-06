(setq indent-tabs-mode nil)
(require 'cl-indent)
;; (setq lisp-indent-function 'lisp-indent-function)
(setq lisp-indent-function 'common-lisp-indent-function)

(put 'defalias 'common-lisp-indent-function 1)
(put 'if 'common-lisp-indent-function 2)
(put 'defface 'common-lisp-indent-function 1)
(put 'define-minor-mode 'common-lisp-indent-function 1)
(put 'define-derived-mode 'common-lisp-indent-function 3)
(put 'cl-flet 'common-lisp-indent-function
     (get 'flet 'common-lisp-indent-function))
(put 'cl-labels 'common-lisp-indent-function
     (get 'labels 'common-lisp-indent-function))

(provide 'ora-elisp-style-guide)
