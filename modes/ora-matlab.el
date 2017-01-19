(setq matlab-mode-verify-fix-functions nil)
(define-key matlab-mode-map (kbd "C-h") nil)
(define-key matlab-mode-map (kbd "C-M-i") nil)
(define-key matlab-mode-map (kbd "<f5>") 'matlab-run-file)
(define-key matlab-mode-map (kbd "θ") 'ora-single-quotes)
(define-key matlab-mode-map (kbd "φ") 'matlab-parens)
(define-key matlab-mode-map (kbd "β") 'counsel-matlab)
(define-key matlab-mode-map (kbd "C-,") 'matlab-kill-at-point)
(define-key matlab-mode-map (kbd "C-c C-z") 'ora-matlab-switch-to-shell)

(defun matlab-parens ()
  (interactive)
  (cond ((region-active-p)
         (lispy--surround-region "(" ")"))

        (t
         (unless (equal "0" (matlab-eval (format "fboundp('%s')" (thing-at-point 'symbol t))))
           (just-one-space))
         (insert "()")
         (backward-char))))

(require 'ob-matlab)

(defun org-babel-execute:matlab (body params)
  "Execute a block of matlab code with Babel."
  (let ((vars (cdr (assoc :var params))))
    (when (symbolp (car vars))
      (let ((name (symbol-name (car vars))))
        (setq body
              (concat
               (format "%s = [];\n" name)
               (mapconcat (lambda (x)
                            (format "%s(end+1,:) = [%s];" name
                                    (mapconcat #'number-to-string x " ")))
                          (cdr vars)
                          "\n")
               "\n" body)))))
  (matlab-eval body))

(defun ora-matlab-switch-to-shell ()
  (interactive)
  (let ((wnd (cl-find-if (lambda (w) (string= "*MATLAB*" (buffer-name (window-buffer w))))
                         (window-list))))
    (if wnd
        (select-window wnd)
      (other-window 1)
      (matlab-shell))))

;;;###autoload
(defun ora-matlab-shell-hook ()
  (setcar font-lock-defaults '(matlab-font-lock-keywords
                               matlab-gaudy-font-lock-keywords))
  (define-key matlab-shell-mode-map (kbd "θ") 'ora-single-quotes)
  (define-key matlab-shell-mode-map (kbd "RET") 'ora-matlab-ret)
  (define-key matlab-shell-mode-map (kbd "C-r") 'ora-matlab-history)
  (define-key matlab-shell-mode-map [mouse-1] 'matlab-shell-html-click))

;;;###autoload
(defun counsel-matlab ()
  "MATLAB completion at point."
  (interactive)
  (let* ((bnd (bounds-of-thing-at-point
               'symbol))
         (str (if bnd
                  (buffer-substring-no-properties
                   (car bnd)
                   (cdr bnd))
                ""))
         (pt (point))
         (cands (mapcar #'car (matlab-shell-completion-list str))))
    (goto-char pt)
    (setq bnd (bounds-of-thing-at-point 'symbol))
    (if bnd
        (progn
          (setq counsel-completion-beg
                (move-marker (make-marker) (car bnd)))
          (setq counsel-completion-end
                (move-marker (make-marker) (cdr bnd))))
      (setq counsel-completion-beg nil)
      (setq counsel-completion-end nil))
    (ivy-read "Symbol name: " cands
              :action #'counsel--el-action)))

(require 'soap)
(dolist (k '("=" "+" "-" "<" ">" ","))
  (define-key matlab-mode-map k 'soap-command))

;;;###autoload
(defun ora-matlab-hook ()
  (setcar font-lock-defaults '(matlab-font-lock-keywords
                               matlab-gaudy-font-lock-keywords)))
(defvar ora-matlab-shell-history nil)

(defvar ora-matlab-needs-rehash nil)
(defun ora-matlab-after-save ()
  (when (eq major-mode 'matlab-mode)
    (setq ora-matlab-needs-rehash t)))

(when (memq system-type '(windows-nt cygwin))
  (add-hook 'after-save-hook 'ora-matlab-after-save))

(defun ora-matlab-ret ()
  (interactive)
  (push (comint-get-old-input-default) ora-matlab-shell-history)
  (setq ora-matlab-shell-history (delete-dups ora-matlab-shell-history))
  (when ora-matlab-needs-rehash
    (setq ora-matlab-needs-rehash nil)
    (matlab-eval "rehash"))
  (comint-send-input))

(defun ora-matlab-cd ()
  (interactive)
  (ivy-read "cd: " 'read-file-name-internal
            :action (lambda (x) (matlab-eval (format "cd %s" x)))))

(defun ora-matlab-history ()
  (interactive)
  (ivy-read "cmd: " ora-matlab-shell-history
            :action (lambda (x)
                      (with-ivy-window
                        (comint-delete-input)
                        (insert x)))
            :unwind (lambda ()
                      (unless (eq ivy-exit 'done)
                        (with-ivy-window
                          (comint-delete-input))))))

(setq matlab-really-gaudy-font-lock-keywords nil)

(defun matlab-run-file ()
  (interactive)
  (let ((buffer (current-buffer))
        (dir default-directory))
    (unless (matlab-shell-active-p)
      (matlab-shell))
    (switch-to-buffer buffer)
    (save-window-excursion
      (switch-to-buffer (concat "*" matlab-shell-buffer-name "*"))
      (matlab-shell-send-string (format "addpath('%s');\n"
                                        dir)))
    (matlab-shell-save-and-go)))

(defun matlab-kill-at-point ()
  (interactive)
  (cond
    ((matlab-cursor-in-string)
     (let (beg end)
       (setq beg
             (if (looking-at "'")
                 (point)
               (re-search-backward "'")))
       (forward-char 1)
       (setq end (re-search-forward "'"))
       (kill-region beg end)))
    ((lispy--in-comment-p)
     (let (beg)
       (beginning-of-line 1)
       (while (looking-at "^ *%")
         (beginning-of-line 0))
       (forward-line 1)
       (setq beg (point))
       (while (progn (beginning-of-line 2)
                     (looking-at "^ *%")))
       (kill-region beg (1- (point)))))
    (t
     (lispy-kill-at-point))))

(setq matlab-fill-code nil)
(provide 'ora-matlab)
