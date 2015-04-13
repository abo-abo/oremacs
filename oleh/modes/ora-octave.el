(require 'octave)
(require 'ac-octave)

(define-key octave-mode-map (kbd "<f5>") 'octave-send-buffer)
(define-key octave-mode-map (kbd "C-<f5>") 'octave-run-script)
(define-key octave-mode-map (kbd "C-h") nil)
(define-key octave-mode-map (kbd "RET") 'newline-and-indent)

(add-to-list 'ac-sources 'ac-source-octave)

;;;###autoload
(defun ora-octave-hook ()
  (electric-spacing-mode 1)
  (auto-complete-mode 1))

;;;###autoload
(defun octave-script ()
  (interactive)
  (goto-char (point-min))
  (insert "#!/usr/bin/octave -qf\n")
  (save-buffer)
  (octave-mode))

(defun octave-send-buffer ()
  (interactive)
  (save-buffer)
  (octave-send-region (point-min) (point-max)))

(defun octave-run-script ()
  (interactive)
  (shell-command
   (concat "./" (file-name-nondirectory (buffer-file-name)))))


