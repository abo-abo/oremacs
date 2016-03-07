(require 'ruby-mode)

(define-key ruby-mode-map [C-f5] 'ora-ruby-compile)
(define-key ruby-mode-map [f5] 'ora-ruby-send-file)
(define-key ruby-mode-map "χ" 'ora-ruby-up)
(define-key ruby-mode-map "]" 'ora-ruby-forward)
(define-key ruby-mode-map "[" 'ora-ruby-backward)
(define-key ruby-mode-map "\C-m" 'newline-and-indent)

;;;###autoload
(defun ora-ruby-hook ()
  (setq-local tab-width 2)
  (electric-spacing-mode 1)
  (add-hook 'local-write-file-hooks
            (lambda ()
              (save-excursion
                (untabify (point-min) (point-max))
                (delete-trailing-whitespace)))))

(defun ora-ruby-send-file ()
  (interactive)
  (save-buffer)
  (ruby-send-region-and-go
   (point-min)
   (point-max)))

(defun ora-ruby-compile ()
  (interactive)
  (ruby-compilation-this-buffer)
  (other-window 1))

(defun ora-ruby-up ()
  (interactive)
  (unless (looking-back "^end")
    (indent-according-to-mode)
    (end-of-line)
    (if (looking-at "\n *end")
        (goto-char (match-end 0))
      (insert "\nend")
      (indent-according-to-mode))))

(defun ora-ruby-forward ()
  (interactive)
  (condition-case nil
      (progn
        (ruby-end-of-block)
        (forward-char 3))
    (error (ora-ruby-up))))

(defun ora-ruby-backward ()
  (interactive)
  (condition-case nil
      (progn
        (when (looking-back "end")
          (backward-char 3))
        (ruby-beginning-of-block))
    (error (progn
             (ora-ruby-up)
             (ruby-beginning-of-block)))))
