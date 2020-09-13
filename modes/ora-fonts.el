(defun ora-set-font (&optional frame)
  (when frame
    (select-frame frame))
  (condition-case nil
      (set-frame-font
       "DejaVu Sans Mono")
    (error
     (ignore-errors
       (set-frame-font
        "Lucida Sans Typewriter")))))
(ora-set-font)
(set-face-attribute 'default nil :height (if (eq system-type 'darwin) 120 113))
(ignore-errors
  (set-fontset-font t nil "Symbola" nil 'append))
(add-hook 'after-make-frame-functions 'ora-set-font)

(provide 'ora-fonts)
