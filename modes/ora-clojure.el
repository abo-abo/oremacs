;;* Clojure
(require 'anakondo)
(require 'clojure-mode)
(require 'flycheck-clj-kondo)
(require 'clojure-semantic)

(require 'cljr-ivy)

(use-package clj-refactor
  :config
  (remove-hook 'find-file-hook 'cljr--ensure-no-dashes-in-filename)
  (remove-hook 'find-file-hook 'cljr--add-ns-if-blank-clj-file))

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
        #'lisp-current-defun-name)
  (flycheck-mode))

(define-key clojure-mode-map (kbd "C-:") nil)
(define-key clojure-mode-map (kbd "&") 'clojure-ampersand)
(define-key clojure-mode-map (kbd "C-c C-l") 'cider-load-file)
(define-key clojure-mode-map (kbd "C-c C-z") 'cider-switch-to-repl-buffer)
(define-key clojure-mode-map (kbd "C-c C-r") nil)
(define-key clojure-mode-map (kbd "C-c r") 'cljr-ivy)

;;* CIDER
(require 'cider)
(setq nrepl-use-ssh-fallback-for-remote-hosts t)
(csetq cider-mode-line-show-connection nil)
(define-key cider-mode-map (kbd "C-c C-v") nil)
(csetq cider-font-lock-dynamically nil)
(csetq cider-repl-display-help-banner nil)
(csetq cider-jack-in-default 'clojure-cli)
(csetq cider-clojure-cli-aliases nil)
(csetq cider-default-cljs-repl nil)
(csetq cider-default-cljs-repl 'figwheel-main)
(csetq cider-default-cljs-repl 'shadow)
(csetq cider-figwheel-main-default-options ":dev")

(defun add-classpath (&rest files)
  (let* ((cp (getenv "CLASSPATH"))
         (paths (when (stringp cp)
                  (nreverse (split-string cp ":" t)))))
    (dolist (file files)
      (cl-pushnew (expand-file-name file) paths
                  :test #'equal))
    (setq cp (mapconcat #'identity (nreverse paths) ":"))
    (setenv "CLASSPATH" cp)))

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
  '((ora-clojure-outline-comment-highlight 1 'default prepend)
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

(defun ora-cider-current-connection (orig-fn &rest args)
  (if (eq major-mode 'org-mode)
      (cadr (first (sesman--all-system-sessions 'CIDER)))
    (apply orig-fn args)))
(advice-add 'cider-current-connection :around #'ora-cider-current-connection)

(require 'pora-clojure nil t)
(provide 'ora-clojure)
