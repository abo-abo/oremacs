;;* Clojure
(require 'clojure-mode)
(require 'clojure-semantic)
(csetq clojure-indent-style :always-align)
(csetq clojure-indent-style :always-indent)
(csetq clojure-indent-style :align-arguments)

;;;###autoload
(defun ora-clojure-hook ()
  (lispy-mode 1)
  (company-mode 1)
  (electric-indent-mode -1)
  (setq company-backends
        '(company-capf company-dabbrev-code company-keywords company-files))
  (setq add-log-current-defun-function
        #'lisp-current-defun-name))

(define-key clojure-mode-map (kbd "C-:") nil)
(define-key clojure-mode-map (kbd "β") 'counsel-clj)
(define-key clojure-mode-map (kbd "&") 'clojure-ampersand)
(define-key clojure-mode-map (kbd "C-c C-l") 'cider-load-file)
(define-key clojure-mode-map (kbd "C-c C-z") 'cider-switch-to-repl-buffer)
(define-key clojure-mode-map (kbd "C-c C-r") nil)

;;* CIDER
(require 'cider)

(setq nrepl-use-ssh-fallback-for-remote-hosts t)
(csetq cider-mode-line-show-connection nil)
(define-key cider-mode-map (kbd "C-c C-v") nil)
(csetq cider-font-lock-dynamically nil)
(csetq cider-jack-in-default 'lein)
(defun ora-sesman-current-session (orig-fn &rest args)
  "Use a single REPL for everything.
Avoid having to `cider-connect' every single thing."
  (apply orig-fn args)
  ;; (car (hash-table-values sesman-sessions-hashmap))
  )
(ora-advice-add 'sesman-current-session :around 'ora-sesman-current-session)

(setq cider-jdk-src-paths
      (mapcar #'expand-file-name
              (cl-remove-if-not #'file-exists-p
                                '("~/git/java/openjvm-8-src"
                                  "~/git/java/clojure-1.8.0-sources"))))

(defun add-classpath (&rest files)
  (let* ((cp (getenv "CLASSPATH"))
         (paths (when (stringp cp)
                  (nreverse (split-string cp ":" t)))))
    (dolist (file files)
      (cl-pushnew (expand-file-name file) paths
                  :test #'equal))
    (setq cp (mapconcat #'identity (nreverse paths) ":"))
    (setenv "CLASSPATH" cp)))

;; (add-classpath
;;  "~/git/java/clojure-1.8.0-sources"
;;  "~/git/java/openjvm-8-src")

(defun clojure-ampersand ()
  (interactive)
  (when (looking-back "\\sw\\( *\\)")
    (delete-region (match-beginning 1)
                   (match-end 1))
    (insert " "))
  (if (looking-back "%")
      (insert "&")
    (insert "& ")))

(defvar ora-clojure-font-lock-keywords
  '(("^;; ?\\(\\*[^*\n]?.*\\)$" 1 'org-level-1 prepend)
    ("^;; ?\\(\\*\\*[^*\n]?.*\\)$" 1 'org-level-2 prepend)
    ("^;; ?\\(\\*\\*\\*[^*\n]?.*\\)$" 1 'org-level-3 prepend)
    ("^;; ?\\(\\*\\*\\*\\*[^*\n]?.*\\)$" 1 'org-level-4 prepend)
    ("^;; ?\\(\\*\\*\\*\\*\\*[*\n]?.*\\)$" 1 'org-level-5 prepend)
    (ora-clojure-outline-comment-highlight 1 'default prepend)
    ;; ("`\\([^\n']+\\)'" 1 font-lock-constant-face prepend)
    ))

(defun ora-clojure-outline-comment-highlight (limit)
  (catch 'done
    (while (re-search-forward "^;;\\(?:[^*\n]\\)" limit t)
      (let* ((pt (point))
             (success (save-excursion
                        (and (re-search-backward "^;;\\*" nil t)
                             (null (re-search-forward "^[^;]" pt t))))))
        (when success
          (set-match-data (list (line-beginning-position) (line-end-position)
                                (point) (line-end-position)))
          (end-of-line)
          (throw 'done t))))))
(font-lock-remove-keywords 'clojure-mode ora-clojure-font-lock-keywords)
(font-lock-add-keywords 'clojure-mode ora-clojure-font-lock-keywords)

(use-package spiral
    :config
  (define-key spiral-mode-map (kbd "C-c C-c") nil)
  :disabled)

(require 'pora-clojure nil t)
(provide 'ora-clojure)
