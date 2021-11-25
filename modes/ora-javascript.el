(require 'js)
(use-package rjsx-mode)
(require 'auto-complete)
(require 'lpy-soap)

(csetq js2-basic-offset 2)
(csetq js-indent-level 2)

(define-key js-mode-map (kbd "<f5>") 'js-f5)
(define-key js-mode-map (kbd "C-<f5>") 'js-C-f5)
(define-key js-mode-map (kbd "=") 'lpy-soap-command)

(defun ora-rjsx-maybe ()
  (save-excursion
    (goto-char (point-min))
    (when (and (re-search-forward "import React" nil t)
               (not (eq major-mode 'rjsx-mode)))
      (rjsx-mode))))


;;;###autoload
(defun ora-javascript-hook ()
  (semantic-mode -1)
  ;; (add-to-list 'ac-sources 'ac-source-javascript)
  (ora-rjsx-maybe)
  (yas-minor-mode 1)
  (setq-local avy-subword-extra-word-chars nil)
  (auto-complete-mode 1)
  ;; (ignore-errors
  ;;   (moz-minor-mode 1))
  )

(defvar keyword-function
  '(("\\(function\\)\\>" (0 (prog1 ()
                              (compose-region (match-beginning 1)
                                              (match-end 1)
                                              "\u0192"))))))
(font-lock-add-keywords 'js-mode keyword-function)

(defvar ac-source-javascript
  '((candidates . javascript-candidates)))

(defvar *javascript-candidates*)

(defun javascript-candidates ()
  *javascript-candidates*)

(defun refresh-javascript-candidates ()
  (interactive)
  (setq *javascript-candidates*
        (with-current-buffer inferior-moz-buffer
          (erase-buffer)
          (comint-send-string (inferior-moz-process)
                              "children(document)\n")
          (sleep-for 0.1)
          (split-string (buffer-substring-no-properties (point-min) (point-max))))))

(defun js-f5 ()
  (interactive)
  (moz-send-region
   (point-min)
   (point-max))
  (other-window 1))

(defun js-C-f5 ()
  (interactive)
  (moz-send-region
   (point-min)
   (point-max)))
