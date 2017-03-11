(require 'python)
(csetq python-indent-guess-indent-offset nil)
(defvar ora-no-pip
  (string-match "Command not found\\|no pip in"
                (shell-command-to-string "which pip")))
(unless ora-no-pip
  (use-package jedi
      :config
    (define-key jedi-mode-map [C-tab] nil)
    (setq jedi:use-shortcuts nil)
    (setq jedi:complete-on-dot t)
    (setq jedi:setup-function nil)
    (setq jedi:mode-function nil)))
(require 'ciao nil t)

(require 'lpy)
;; when set to nil, completions to functions end with "(", very annoying
(setq python-shell-completion-native-enable t)
(define-key python-mode-map (kbd "C-.") nil)
(define-key python-mode-map (kbd "C-x C-p") 'jedi:goto-definition)
(define-key python-mode-map (kbd "C-?") 'jedi:show-doc)
(define-key python-mode-map (kbd "RET") 'newline-and-indent)
(define-key python-mode-map (kbd "C-c C-l") 'ora-python-send)
(define-key python-mode-map (kbd "C-c C-z") 'ora-python-switch-to-shell)
(define-key python-mode-map (kbd "θ") 'lpy-quotes)
(define-key python-mode-map (kbd "β") 'counsel-jedi)
(define-key python-mode-map (kbd "C-M-j") 'lpy-goto)
(define-key python-mode-map (kbd "C-c C-v") nil)
(define-key python-mode-map (kbd "C-c C-r") nil)
(define-key python-mode-map (kbd "C-m") 'newline)
(define-key inferior-python-mode-map (kbd "C-c M-o") 'comint-kill-region)

(require 'le-python)
(require 'flyspell)
(flyspell-delay-command 'python-indent-dedent-line-backspace)
(require 'company-jedi)

;;;###autoload
(defun ora-python-hook ()
  (setq-local company-backends '(company-dabbrev-code company-keywords))
  (unless ora-no-pip
    (jedi:setup)
    (add-to-list 'company-backends 'company-jedi))
  (electric-indent-mode -1)
  (auto-complete-mode -1)
  (company-mode)
  (remove-hook 'post-command-hook 'jedi:handle-post-command t)
  (setq lispy-no-space t)
  (setq forward-sexp-function 'ora-c-forward-sexp-function)
  (lpy-mode)
  (setq completion-at-point-functions '(lispy-python-completion-at-point t))
  (setf (symbol-function #'jedi:handle-post-command) (lambda nil nil)))

(defun ora-get-py-fname ()
  "Get the file name of a visibile `python-mode' buffer."
  (let ((b (window-buffer
            (cl-find-if (lambda (w)
                          (with-current-buffer (window-buffer w)
                            (eq major-mode 'python-mode)))
                        (window-list)))))
    (if b
        (file-name-nondirectory
         (buffer-file-name b))
      "")))

(defun ora-python-switch-to-shell ()
  (interactive)
  (let ((buffer (process-buffer (lispy--python-proc))))
    (if buffer
        (pop-to-buffer buffer)
      (run-python "python")
      (pop-to-buffer "*Python*"))))

(defun ora-python-shell-send-region (start end &optional nomain)
  "Send the region delimited by START and END to inferior Python process."
  (interactive "r")
  (let* ((python--use-fake-loc
          (not buffer-file-name))
         (string (python-shell-buffer-substring start end nomain))
         (process (python-shell-get-or-create-process))
         (_ (string-match "\\`\n*\\(.*\\)" string)))
    (let* ((temp-file-name (python-shell--save-temp-file string))
           (file-name (or (buffer-file-name) temp-file-name)))
      (python-shell-send-file file-name process temp-file-name t)
      (unless python--use-fake-loc
        (with-current-buffer (process-buffer process)
          (compilation-fake-loc (copy-marker start) temp-file-name
                                2))))))

(defun ora-python-send ()
  (interactive)
  (if (region-active-p)
      (ora-python-shell-send-region (region-beginning)
                                    (region-end))
    (ora-python-shell-send-region (point-min)
                                  (point-max))))
