(require 'matlab-load)
(require 'matlab)
(define-key matlab-mode-map (kbd "C-h") nil)
(define-key matlab-mode-map (kbd "C-M-i") nil)
(when (keymapp matlab-shell-mode-map)
  (define-key matlab-shell-mode-map (kbd "β") 'counsel-matlab))
(define-key matlab-mode-map (kbd "<f5>") 'matlab-run-file)
(define-key matlab-mode-map (kbd "θ") 'ora-single-quotes)
(define-key matlab-mode-map (kbd "β") 'counsel-matlab)
(define-key matlab-mode-map (kbd "C-'") (lambda()(interactive)(insert "'")))
(define-key matlab-mode-map (kbd "C-c C-z")
  (lambda ()
    (interactive)
    (delete-other-windows)
    (split-window-below)
    (matlab-shell)))

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
      (matlab-shell-send-string (format "userpath('%s');\n"
                                        dir)))
    (matlab-shell-save-and-go)))

(setq matlab-fill-code nil)
