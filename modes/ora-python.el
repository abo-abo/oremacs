(require 'python)
(setq-default python-shell-interpreter "python3")
;; python-shell-first-prompt-hook
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
    (setq jedi:mode-function nil)
    (setcar jedi:install-server--command "pip3")
    (setq jedi:server-command (list "python3" jedi:server-script))))
(require 'ciao nil t)

(require 'lpy)
(setq python-shell-prompt-detect-enabled nil)
(require 'warnings)
(add-to-list 'warning-suppress-log-types
             '(python python-shell-completion-native-turn-on-maybe))
(setq python-shell-prompt-detect-failure-warning nil)
;; when set to nil, completions to functions end with "(", very annoying
(setq python-shell-completion-native-enable t)
(define-key python-mode-map (kbd "C-.") nil)
(define-key python-mode-map (kbd "C-x C-p") 'jedi:goto-definition)
(define-key python-mode-map (kbd "C-?") 'jedi:show-doc)
(define-key python-mode-map (kbd "RET") 'newline-and-indent)
(define-key python-mode-map (kbd "θ") 'lpy-quotes)
(define-key python-mode-map (kbd "β") 'counsel-jedi)
(define-key python-mode-map (kbd "C-M-j") 'lpy-goto)
(define-key python-mode-map (kbd "C-c C-v") nil)
(define-key python-mode-map (kbd "C-c C-r") nil)
(define-key python-mode-map (kbd "C-m") 'python-newline-dedent)
(define-key inferior-python-mode-map (kbd "C-c M-o") 'comint-clear-buffer)

(defun python-newline-dedent ()
  (interactive)
  (if (bolp)
      (newline)
    (newline-and-indent)
    (unless (or (bolp)
                (lispy--in-string-p))
      (python-indent-dedent-line-backspace 1))))

(require 'le-python)
(require 'flyspell)
(flyspell-delay-command 'python-indent-dedent-line-backspace)
(require 'company-jedi)

;;;###autoload
(defun ora-python-hook ()
  (setq-local company-backends '(company-dabbrev-code company-keywords))
  (setq python-environment-virtualenv
        '("virtualenv" "--system-site-packages" "--quiet" "--python" "/usr/bin/python3"))
  (unless ora-no-pip
    (jedi:setup)
    (setq jedi:environment-root "jedi")
    (setq jedi:environment-virtualenv python-environment-virtualenv)
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

;;* Jython stuff
(setq python-shell-completion-setup-code
      "
def __PYTHON_EL_get_completions(text):
    import readline
    comps = []
    completer = readline.get_completer()
    try:
        if getattr(completer, 'PYTHON_EL_WRAPPED', False):
            completer.print_mode = False
        i = 0
        while True:
            completion = completer(text, i)
            if not completion:
                break
            i += 1
            comps.append(completion)
    finally:
        if getattr(completer, 'PYTHON_EL_WRAPPED', False):
            completer.print_mode = True
    comps.remove('0__dummy_completion__')
    comps.remove('1__dummy_completion__')
    seen = set()
    seen_add = seen.add
    return [x for x in comps if not (x in seen or seen_add(x))]")

;;;###autoload
(defun ora-inferior-python-hook ()
  (setq next-error-function 'ora-comint-next-error-function))

(defun ora-comint-next-error-function (n &optional reset)
  (interactive "p")
  (when reset
    (setq compilation-current-error nil))
  (let* ((msg (compilation-next-error (or n 1) nil
                                      (or compilation-current-error
                                          compilation-messages-start
                                          (point-min))))
         (loc (compilation--message->loc msg))
         (file (caar (compilation--loc->file-struct loc)))
         (buffer (find-file-noselect file)))
    (pop-to-buffer buffer)
    (goto-char (point-min))
    (forward-line (1- (cadr loc)))
    (back-to-indentation)
    (unless (bolp)
      (backward-char))))

(defun python-font-lock-syntactic-face-function (state)
  "Speed up `python-font-lock-syntactic-face-function'.
Don't call `python-info-docstring-p'."
  (if (nth 3 state)
      font-lock-string-face
    font-lock-comment-face))
