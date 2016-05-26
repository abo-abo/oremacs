(require 'python)
(csetq python-indent-guess-indent-offset nil)
(use-package jedi
    :config
  (define-key jedi-mode-map [C-tab] nil)
  (setq jedi:use-shortcuts nil)
  (setq jedi:complete-on-dot t)
  (setq jedi:setup-function nil)
  (setq jedi:mode-function nil))
(require 'ciao nil t)

(require 'lpy)
(define-key python-mode-map (kbd "C-.") nil)
(define-key python-mode-map [f5] 'ora-python-send-file)
(define-key python-mode-map [C-f5] 'ora-python-eval)
(define-key python-mode-map (kbd "C-x C-p") 'jedi:goto-definition)
(define-key python-mode-map (kbd "C-?") 'jedi:show-doc)
(define-key python-mode-map (kbd "C-M-,") 'ora-python-select-cell)
(define-key python-mode-map (kbd "RET") 'newline-and-indent)
(define-key python-mode-map (kbd "C-c C-l") 'ora-python-send)
(define-key python-mode-map (kbd "C-c C-z") 'ora-python-switch-to-shell)
(define-key python-mode-map (kbd "θ") 'ora-python-quotes)
(define-key python-mode-map (kbd "β") 'counsel-jedi)
(define-key python-mode-map (kbd "C-M-j") 'py-jump-local)
(define-key python-mode-map (kbd "C-c C-v") nil)

(defvar ora-no-pip
  (string-match "Command not found\\|no pip in"
                (shell-command-to-string "which pip")))

 ;;;###autoload
(require 'le-python)
(require 'flyspell)
(flyspell-delay-command 'python-indent-dedent-line-backspace)

;;;###autoload
(defun ora-python-hook ()
  (unless ora-no-pip
    (jedi:setup))
  (company-mode)
  (remove-hook 'post-command-hook 'jedi:handle-post-command t)
  (setq lispy-no-space t)
  (setq forward-sexp-function 'ora-c-forward-sexp-function)
  (lpy-mode)
  (setq completion-at-point-functions '(lispy-python-completion-at-point t))
  (setq-local company-backends '(company-dabbrev-code
                                 company-keywords)))

(defun ora-python-switch-to-shell ()
  (interactive)
  (let ((buffer (process-buffer (lispy--python-proc))))
    (if buffer
        (pop-to-buffer buffer)
      (run-python "python")
      (pop-to-buffer "*Python*"))))

(defun ora-python-quotes ()
  (interactive)
  (cond ((region-active-p)
         (let ((beg (region-beginning))
               (end (region-end)))
           (deactivate-mark)
           (goto-char beg)
           (insert "\"")
           (goto-char (1+ end))
           (insert "\"")))

        ((lispy--in-string-p)
         (if (and (looking-back "\"")
                  (looking-at "\""))
             (insert "\"\"\"\"")
           (insert "\\\"\\\""))
         (backward-char 2))

        (t
         (insert "\"\"")
         (backward-char))))

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

;;;###autoload
(defun ora-python-eval-nofocus ()
  "run current script(that requires no input)"
  (interactive)
  (save-buffer)
  (let ((n (buffer-file-name))
        (tprocess (get-process "terminal")))
    (message (shell-command-to-string (concat "python3 " n)))))

;;;###autoload
(defun ora-python-eval ()
  "run current script"
  (interactive)
  (save-buffer)
  (delete-other-windows)
  (split-window-vertically)
  (other-window 1)
  (let ((n (buffer-file-name)))
    (progn
      (let ((terminal-process (ora-terminal)))
        (term-simple-send terminal-process "clear")
        (term-simple-send terminal-process n)))))

(defun ora-python-in-comment-p ()
  (save-excursion
    (beginning-of-line 1)
    (looking-at "^#")))

(defun ora-python-select-cell ()
  (interactive)
  (goto-char
   (if (re-search-backward "^\\s-*##[^#]" nil t)
       (match-end 0)
     (point-min)))
  (while (and (ora-python-in-comment-p)
              (eq 0 (forward-line 1)))
    nil)
  (set-mark (point))
  (goto-char
   (if (re-search-forward "^\\s-*\\(##[^#]\\)" nil t)
       (- (match-beginning 1) 2)
     (point-max))))

(defun ora-python-send-file ()
  (interactive)
  (save-buffer)
  (python-shell-send-file (buffer-file-name))
  (pop-to-buffer "*Python*"))

(defun py-tag-name (tag)
  (let* ((class (semantic-tag-class tag))
         (str (cl-case class
                (function
                 (let ((args (semantic-tag-get-attribute tag :arguments)))
                   (format "%s %s (%s)"
                           (propertize "def" 'face 'font-lock-builtin-face)
                           (propertize (car tag) 'face 'font-lock-function-name-face)
                           (mapconcat #'car args ", "))))
                (variable
                 (car tag))
                (type
                 (propertize (car tag) 'face 'fa-face-type-definition))
                (include
                 (format "%s %s"
                         (propertize "import" 'face 'font-lock-preprocessor-face)
                         (car tag)))
                (code
                 (let* ((beg)
                        (end)
                        (ov (semantic-tag-overlay tag))
                        (buf (cond
                               ((and (overlayp ov)
                                     (bufferp (overlay-buffer ov)))
                                (setq beg (overlay-start ov))
                                (setq end (overlay-end ov))
                                (overlay-buffer ov))
                               ((arrayp ov)
                                (setq beg (aref ov 0))
                                (setq end (aref ov 1))
                                (current-buffer))))
                        str)
                   (when (and buf
                              (setq str
                                    (ignore-errors
                                      (with-current-buffer buf
                                        (buffer-substring-no-properties beg end))))
                              (string-match (format "^%s ?=" (car tag)) str))
                     (concat (car tag) "="))))
                (t
                 (error "Unknown class for tag: %S" tag)))))
    str))

(defun py-jump-local (arg)
  "Select a tag to jump to from tags defined in current buffer.
When ARG is non-nil, regenerate tags."
  (interactive "P")
  (require 'semantic-directory)
  (let* ((file-list (cl-remove-if
                     (lambda (x)
                       (string-match "^\\.#" x))
                     (append (file-expand-wildcards "*.py"))))
         (sd-force-reparse arg)
         (ready-tags
          (or ;; (and (null arg) (gethash file-list moo-jump-local-cache))
           (let ((tags (sd-fetch-tags file-list)))
             (when (memq major-mode '(python-mode))
               (setq tags
                     (delq nil
                           (mapcar
                            (lambda (x)
                              (let ((s (py-tag-name x)))
                                (when s
                                  (cons
                                   (moo-format-tag-line
                                    s (semantic-tag-get-attribute x :truefile))
                                   x))))
                            tags))))
             (puthash file-list tags moo-jump-local-cache)
             tags)))
         (preselect (car (semantic-current-tag)))
         (preselect (and preselect
                         (if (memq moo-select-method '(helm helm-fuzzy))
                             (regexp-quote preselect)
                           preselect))))
    (moo-select-candidate
     ready-tags
     #'moo-action-jump
     preselect)))

;; (font-lock-add-keywords
;;  'python-mode
;;  '(("`\\(\\(?:\\sw\\|\\s_\\|\\\\.\\)\\(?:\\sw\\|\\s_\\|\\\\.\\)+\\)'" 1 font-lock-constant-face prepend)))

;; (font-lock-add-keywords 'python-mode
;;                         '(("^\\(#\\*+ .*\\)$" 1 'org-level-1 prepend)))
