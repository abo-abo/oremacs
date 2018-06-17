(require 'clojure-mode)
(csetq clojure-indent-style :always-align)
(csetq clojure-indent-style :always-indent)
(csetq clojure-indent-style :align-arguments)
(defun add-classpath (&rest files)
  (let* ((cp (getenv "CLASSPATH"))
         (paths (when (stringp cp)
                  (nreverse (split-string cp ":" t)))))
    (dolist (file files)
      (cl-pushnew (expand-file-name file) paths
                  :test #'equal))
    (setq cp (mapconcat #'identity (nreverse paths) ":"))
    (setenv "CLASSPATH" cp)))

(add-classpath
 "~/git/java/clojure-1.8.0-sources"
 "~/git/java/openjvm-8-src")


;;;###autoload
(defun ora-clojure-hook ()
  (lispy-mode 1)
  (company-mode 1)
  (setq company-backends
        '(company-capf company-dabbrev-code company-keywords company-files))
  (setq add-log-current-defun-function
        #'lisp-current-defun-name))

(use-package cider
    :load-path "~/git/cider")
(require 'cider-interaction)

(define-key clojure-mode-map (kbd "C-:") nil)
(define-key clojure-mode-map (kbd "β") 'counsel-clj)
(define-key clojure-mode-map (kbd "&") 'clojure-ampersand)
(define-key clojure-mode-map (kbd "C-c C-l") 'cider-load-file)
(define-key clojure-mode-map (kbd "C-c C-z") 'cider-switch-to-repl-buffer)
(define-key cider-mode-map (kbd "M-TAB") 'iedit-mode)

(defun clojure-ampersand ()
  (interactive)
  (when (looking-back "\\sw\\( *\\)")
    (delete-region (match-beginning 1)
                   (match-end 1))
    (insert " "))
  (if (looking-back "%")
      (insert "&")
    (insert "& ")))

(require 'request)
(declare-function request "ext:request")

;;;###autoload
(defun 4clojure-login (user pwd)
  "Log in to http://www.4clojure.com."
  (interactive (list (read-string "username:")
                     (read-string "password:")))
  (message "%s"
           (request
            "http://www.4clojure.com/login?location=%%2F"
            :type "POST"
            :data `(("user" . ,user) ("pwd" . ,pwd)))))

(font-lock-add-keywords
 'clojure-mode
 '(("^;;\\*+ \\([^\n]*\\)$" 1 font-lock-constant-face prepend)))
