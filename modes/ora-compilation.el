(require 'compile)

;;;###autoload
(defun ora-compilation-hook ())

(define-key compilation-mode-map (kbd "j") 'ora-compilation-next)
(define-key compilation-mode-map (kbd "k") 'ora-compilation-prev)

(defun ora-compilation-next ()
  (interactive)
  (let ((pt (point)))
    (forward-line)
    (if (re-search-forward "[0-9]: info" nil t)
        (beginning-of-line)
      (goto-char pt))
    (save-selected-window
      (compile-goto-error))))

(defun ora-compilation-prev ()
  (interactive)
  (when (re-search-backward "[0-9]: info" nil t)
    (beginning-of-line)
    (save-selected-window
      (compile-goto-error))))

(defface compilation-info-modeline
  '((((class color) (background light))
     :foreground "#bb77cc" :weight bold
     :underline t))
  "Face used by `compile' in the mode line.")

(setq compilation-mode-line-errors
      '(" [" (:propertize (:eval (int-to-string compilation-num-errors-found))
              face compilation-error
              help-echo "Number of errors so far")
        " " (:propertize (:eval (int-to-string compilation-num-warnings-found))
             face compilation-warning
             help-echo "Number of warnings so far")
        " " (:propertize (:eval (int-to-string compilation-num-infos-found))
             face compilation-info-modeline
             help-echo "Number of informational messages so far")
        "]"))
