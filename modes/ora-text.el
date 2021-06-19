(define-key text-mode-map (kbd "C-c C-c") 'server-edit)
(define-key text-mode-map (kbd "<M-up>") 'ora-move-line-up)
(define-key text-mode-map (kbd "<M-down>") 'ora-move-line-down)

(defun ora-move-line-up ()
  (interactive)
  (save-excursion
    (transpose-lines 1))
  (forward-line -1))

(defun ora-move-line-down ()
  (interactive)
  (let ((pt (point)))
    (forward-line 1)
    (if (eobp)
        (goto-char pt)
      (transpose-lines 1)
      (goto-char pt)
      (forward-line 1))))

;;;###autoload
(defun ora-text-hook ()
  ;; (unless (eq system-type 'windows-nt)
  ;;   (flyspell-mode))
  )

(add-hook 'before-save-hook #'ora-to-ascii)

(defun ora-to-ascii ()
  (when (derived-mode-p 'text-mode)
    (format-replace-strings
     '(("\x201C" . "\"")
       ("\x201D" . "\"")
       ("\x2018" . "'")
       ("\x2019" . "'")
       ;; en-dash
       ("\x2013" . "-")
       ;; em-dash
       ("\x2014" . "-")))))
