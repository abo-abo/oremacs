(eval-when-compile
  (require 'ob-C)
  (require 'ob-ruby)
  (require 'ob-python)
  (require 'ob-scheme)
  (require 'ob-clojure))
(setq org-confirm-babel-evaluate nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   (groovy . t)
   (shell . t)
   (python . t)
   (emacs-lisp . t)
   (latex . t)
   (C . t)
   (J . t)
   (java . t)
   (scheme . t)
   (lisp . t)
   (latex . t)
   (R . t)
   (sql . t)
   (sqlite . t)
   (calc . t)))
(add-to-list 'org-src-lang-modes '("J" . j))

;;* C
(setq org-babel-C-compiler "gcc -std=c99")

;;* Cpp
(setq org-babel-default-header-args:C++
      '((:results . "verbatim")
        (:main . "no")
        (:flags . "-std=c++14")
        (:cache . "yes")))

;;* Java
(setq org-babel-default-header-args:java
      '((:results . "verbatim")
        (:cache . "yes")))

;;* Ruby
(setq org-babel-default-header-args:ruby
      '((:results . "pp output")))

;;* Clojure
(defvar org-babel-default-header-args:clojure
  '((:results . "value") (:tangle . "yes")))

;;* Python
(setq org-babel-default-header-args:python
      '((:results . "output")))
(setq org-babel-python-command "python3")

;;* Bash
(setq org-babel-default-header-args:sh
      '((:results . "verbatim")))
(setq org-babel-default-header-args:bash
      '((:results . "verbatim")))

;; (setf (cdr (assoc :results org-babel-default-header-args)) "output silent")
(setf (cdr (assoc :noweb org-babel-default-header-args)) "yes")


(provide 'ora-org-babel)
