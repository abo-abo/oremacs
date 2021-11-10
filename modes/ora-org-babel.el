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
   (js . t)
   (scheme . t)
   (lisp . t)
   (latex . t)
   (R . t)
   (sql . t)
   (sqlite . t)
   (calc . t)))
(add-to-list 'org-src-lang-modes '("J" . j))

(defun ora-org-babel-insert-result (orig-fn result &optional result-params info hash lang)
  (let ((inline-p (let ((context (org-element-context)))
                    (and (memq (org-element-type context)
                               '(inline-babel-call inline-src-block))
                         context))))
    (if inline-p
        (let ((existing-result (org-babel-where-is-src-block-result t nil hash)))
          (if existing-result
              (goto-char existing-result)
            (goto-char (org-element-property :end inline-p))
            (skip-chars-backward " \t")
            (insert " "))
          (insert (format "{{{results(=%s=)}}}" (if (stringp result) result (prin1-to-string result))))
          (when (boundp 'org-babel-eval-output)
            (lispy-message org-babel-eval-output)))
      (funcall orig-fn result result-params info hash lang))))

(ora-advice-add 'org-babel-insert-result :around #'ora-org-babel-insert-result)

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

;;* Common Lisp
(setq org-babel-default-header-args:lisp
      '((:results . "value")))

;; (setf (cdr (assoc :results org-babel-default-header-args)) "output silent")
(setf (cdr (assoc :noweb org-babel-default-header-args)) "yes")

(require 'ora-org-babel-inline)
(provide 'ora-org-babel)
