(require 'python)
(require 'jedi)
(csetq python-indent-guess-indent-offset nil)
(setq jedi:use-shortcuts t)
(setq jedi:complete-on-dot t)
(setq jedi:setup-function nil)
(setq jedi:mode-function nil)

(require 'soap)
(dolist (k '("+" "-" "*" "/" "%" "&" "|" "<" "=" ">" ","))
  (define-key python-mode-map (kbd k) 'soap-command))
(define-key python-mode-map [C-.] 'comment-dwim)
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
(define-key python-mode-map (kbd "C-M-j") 'helm-semantic)
(define-key jedi-mode-map [C-tab] nil)

;;;###autoload
(defun ora-python-hook ()
  (jedi:setup))

(defun ora-python-switch-to-shell ()
  (interactive)
  (let ((buffer (get-buffer "*Python*")))
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
