(require 'eww)
(require 'avy)

(defun eww-view-ace ()
  "Select point with ace-jump-mode and make that line the top one."
  (interactive)
  (call-interactively #'avy-goto-char)
  (recenter 0))

(define-key eww-mode-map "j" 'ora-para-down)
(define-key eww-mode-map "k" 'ora-para-up)
(define-key eww-mode-map "l" 'forward-char)
(define-key eww-mode-map "L" 'eww-back-url)
(define-key eww-mode-map "h" 'backward-char)
(define-key eww-mode-map "v" 'recenter-top-bottom)
(define-key eww-mode-map "V" 'eww-view-source)
(define-key eww-mode-map "m" 'eww-follow-link)
(define-key eww-mode-map "a" 'move-beginning-of-line)
(define-key eww-mode-map "e" 'move-end-of-line)
(define-key eww-mode-map "o" 'ace-link-eww)
(define-key eww-mode-map "y" 'eww)
(define-key eww-mode-map "A" 'eww-view-ace)
(define-key eww-mode-map "c" 'counsel-ace-link)

;;;###autoload
(defun ora-eww-hook ())

(csetq shr-width 60)

(defun ora--eww-reader-scale ()
  (text-scale-set 4)
  (set-window-margins nil 30)
  (remove-hook 'eww-after-render-hook 'ora--eww-reader-scale))

;;;###autoload
(defun ora-eww-reader ()
  (interactive)
  (cond ((eq major-mode 'org-mode)
         (let ((context (org-element-context)))
           (when (eq (org-element-type context) 'link)
             (eww (org-element-property :raw-link context))
             (add-hook 'eww-after-render-hook 'ora--eww-reader-scale))))))
