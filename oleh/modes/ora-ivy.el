;; -*- lexical-binding: t -*-
(require 'ivy)
(require 'counsel)
(csetq ivy-display-style 'fancy)
;; (csetq ivy-count-format "(%d/%d) ")
(csetq ivy-use-virtual-buffers t)
(csetq counsel-find-file-ignore-regexp "\\`\\.")
(define-key ivy-minibuffer-map (kbd "<return>") 'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "C-M-h") 'ivy-previous-line-and-call)
(define-key ivy-minibuffer-map (kbd "C-:") 'ivy-dired)
(define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-occur)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
(when (and (version< "25" emacs-version)
           (eq system-type 'gnu/linux))
  (diminish 'ivy-mode " 🙒"))

(defun ivy-dired ()
  (interactive)
  (if ivy--directory
      (ivy-quit-and-run
       (dired ivy--directory)
       (when (re-search-forward
              (regexp-quote
               (substring ivy--current 0 -1)) nil t)
         (goto-char (match-beginning 0))))
    (user-error
     "Not completing files currently")))

(defun ivy-insert-action (x)
  (with-ivy-window
    (insert x)))

(ivy-set-actions
 t
 '(("I" ivy-insert-action "insert")))

(provide 'ora-ivy)
