(setq matlab-mode-verify-fix-functions nil)
(define-key matlab-mode-map (kbd "C-h") nil)
(define-key matlab-mode-map (kbd "C-M-i") nil)
(define-key matlab-mode-map (kbd "<f5>") 'matlab-run-file)
(define-key matlab-mode-map (kbd "θ") 'ora-single-quotes)
(define-key matlab-mode-map (kbd "β") 'counsel-matlab)
(define-key matlab-mode-map (kbd "C-,") 'matlab-kill-at-point)
(define-key matlab-mode-map (kbd "C-'") (lambda()(interactive)(insert "'")))
(define-key matlab-mode-map (kbd "C-c C-z") 'ora-matlab-switch-to-shell)

(defun ora-matlab-switch-to-shell ()
  (interactive)
  (other-window 1)
  (matlab-shell))

;;;###autoload
(defun ora-matlab-shell-hook ()
  (setcar font-lock-defaults '(matlab-font-lock-keywords
                               matlab-gaudy-font-lock-keywords))
  (define-key matlab-shell-mode-map (kbd "β") 'counsel-matlab)
  (define-key matlab-shell-mode-map (kbd "<tab>") 'complete-symbol)
  (define-key matlab-shell-mode-map (kbd "RET") 'ora-matlab-ret)
  (define-key matlab-shell-mode-map (kbd "C-r") 'ora-matlab-history)
  (define-key matlab-shell-mode-map [mouse-1] 'matlab-shell-html-click)
  (setq completion-at-point-functions '(ora-matlab-completion-at-point t)))

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
(defun ora-matlab-hook ())
(defvar ora-matlab-shell-history nil)

(defun ora-matlab-ret ()
  (interactive)
  (push (comint-get-old-input-default) ora-matlab-shell-history)
  (setq ora-matlab-shell-history (delete-dups ora-matlab-shell-history))
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

(defun ora-matlab-completion-at-point ()
  (let ((bnd (bounds-of-thing-at-point 'symbol)))
    (when bnd
      (let* ((beg (car bnd))
             (end (cdr bnd))
             (sym (buffer-substring-no-properties beg end))
             (res (matlab-shell-completion-list sym)))
        ;; (sit-for 0.1)
        (list (car bnd) (cdr bnd) res)))))

;; (setq matlab-really-gaudy-font-lock-keywords nil)

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
  (if (lispy--in-comment-p)
      (let (beg)
        (beginning-of-line 1)
        (while (looking-at "^ *%")
          (beginning-of-line 0))
        (forward-line 1)
        (setq beg (point))
        (while (progn (beginning-of-line 2)
                      (looking-at "^ *%")))
        (kill-region beg (1- (point))))
      (lispy-kill-at-point)))

(setq matlab-fill-code nil)
