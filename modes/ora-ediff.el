(require 'ediff)
(require 'diff-mode)
(csetq ediff-window-setup-function 'ediff-setup-windows-plain)
(csetq ediff-split-window-function 'split-window-horizontally)
(csetq ediff-diff-options "--text")
(csetq ediff-diff-options "-w --text")

(defun max-line-width ()
  (let (res)
    (save-excursion
      (goto-char (point-min))
      (end-of-line)
      (setq res (current-column))
      (while (end-of-line 2)
        (setq res (max res (current-column))))
      res)))

(defun ora-ediff-prepare-buffer ()
  (when (memq major-mode '(org-mode emacs-lisp-mode))
    (outline-show-all))
  (when (> (max-line-width) 150)
    (visual-line-mode)))

(add-hook 'ediff-prepare-buffer-hook 'ora-ediff-prepare-buffer)

(defun ora-ediff-jk ()
  (define-key ediff-mode-map "j" 'ediff-next-difference)
  (define-key ediff-mode-map "k" 'ediff-previous-difference))

(add-hook 'ediff-keymap-setup-hook #'ora-ediff-jk)

;;;###autoload
(defun ora-ediff-hook ())

;;;###autoload
(defun ora-diff-hook ())


(defmacro ediff-save-windows (&rest forms)
  `(let ((wnd (current-window-configuration)))
     ,@forms
     (add-hook 'ediff-after-quit-hook-internal
               `(lambda ()
                  (setq ediff-after-quit-hook-internal nil)
                  (set-window-configuration ,wnd)))))

;;;###autoload
(defun ora-ediff-dwim ()
  (interactive)
  (cond ((looking-at "AssertionError: \\(.*\\) != \\(.*\\)")
         (lispy--ediff-regions
          (cons (match-beginning 1)
                (match-end 1))
          (cons (match-beginning 2)
                (match-end 2))
          nil nil "-actual-" "-expected-"))
        ((eq major-mode 'magit-status-mode)
         (magit-diff '("refs/remotes/origin/master" . "master")))
        ((looking-at "^--- \"?\\([^\t\"]+\\)\"?\t.*\n\\+\\+\\+ \"?\\([^\t\"]+\\)")
         (let ((f1 (match-string-no-properties 1))
               (f2 (match-string-no-properties 2)))
           (ediff-save-windows
            (ediff-files f1 f2))))
        (t
         (message "No context for auto-ediff detected :/"))))

(mapc
 (lambda (k)
   (define-key diff-mode-map k
     `(lambda () (interactive)
         (if (region-active-p)
             (replace-regexp "^." ,k nil
                             (region-beginning)
                             (region-end))
           (insert ,k)))))
 (list " " "-" "+"))
