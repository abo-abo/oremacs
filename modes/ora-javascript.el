(require 'js)
(use-package rjsx-mode)
(require 'auto-complete)
(require 'lpy-soap)

(csetq js2-basic-offset 2)
(csetq js2-mode-show-parse-errors nil)
(csetq js2-mode-show-strict-warnings nil)
(csetq js-indent-level 2)

(define-key js-mode-map (kbd "<f5>") 'js-f5)
(define-key js-mode-map (kbd "C-<f5>") 'js-C-f5)
(define-key js-mode-map (kbd "=") 'ora-js-assign)
(define-key js-mode-map (kbd "M-o") 'back-to-indentation)
(define-key js-mode-map (kbd "σ") 'ora-braces)
(define-key js-mode-map (kbd "e") 'ora-indium-eval)

(defun ora-indium-eval ()
  (interactive)
  (cond ((region-active-p)
         (indium-eval-region (region-beginning) (region-end)))
        (t
         (self-insert-command 1))))

(defun ora-js-assign ()
  (interactive)
  (cond
   ((lispy-after-string-p ")")
    (insert " ="))
   ((and (eq major-mode 'rjsx-mode)
         (condition-case nil
             (save-excursion (rjsx-jump-opening-tag))
           (error nil)))
    (insert "="))
   ((lispy-after-string-p "!")
    (backward-delete-char 1)
    (just-one-space)
    (insert "!= "))
   ((lispy-after-string-p "<")
    (delete-char -1)
    (insert " <= "))
   ((looking-back "\\sw\\( ?\\+ ?\\)" (line-beginning-position))
    (delete-region (match-beginning 1)
                   (match-end 1))
    (insert " += "))
   ((lispy-after-string-p "[")
    (insert "="))
   (t
    (lpy-soap-default-action "="))))

(define-key js-mode-map (kbd "M-.") 'xref-find-definitions)
(define-key js-mode-map (kbd "C-j") 'newline-and-indent)
(define-key js-mode-map (kbd "C-M-j") 'counsel-imenu)
(define-key js-mode-map (kbd "C-c C-y") 'ora-yank-json)

(defun ora-yank-json ()
  (interactive)
  (shell-command "xclip -o | jq" (current-buffer)))


(defun ora-rjsx-maybe ()
  (save-excursion
    (goto-char (point-min))
    (when (and (re-search-forward "import React" nil t)
               (not (eq major-mode 'rjsx-mode)))
      (rjsx-mode))))

;;;###autoload
(defun ora-javascript-hook ()
  (unless (eq major-mode 'js2-mode)
    (js2-mode))
  (ora-rjsx-maybe)
  (setq-local avy-subword-extra-word-chars nil)
  (if (string-match-p "\\.json$" (buffer-name))
      (local-set-key (kbd "C-c C-g") 'jsons-print-path)
    (lsp))

  ;; (ignore-errors
  ;;   (moz-minor-mode 1))
  )

(defun ora-js-ide ()
  (interactive)
  (when (file-exists-p ".indium.json")
    (unless (bound-and-true-p indium-interaction-mode)
      (indium-connect)
      (indium-interaction-mode 1))))

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
