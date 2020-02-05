(require 'image-mode)

;;;###autoload
(defun ora-image-hook ())

(defmacro image-view (direction)
  `(lambda ()
     (interactive)
     (quit-window)
     (let ((pt (point))
           filename)
       (or (ignore-errors
             (catch 'filename
               (while (dired-next-line ,direction)
                 (when (image-type-from-file-name
                        (setq filename (dired-get-filename)))
                   (throw 'filename filename)))))
           (goto-char pt))
       (dired-view-file))))

(defun image-view-eog ()
  (interactive)
  (orly-start "eog" (list (buffer-file-name))))

(define-key image-mode-map "j" (image-view 1))
(define-key image-mode-map "k" (image-view -1))
(define-key image-mode-map "x" 'image-view-eog)

(provide 'ora-image)
