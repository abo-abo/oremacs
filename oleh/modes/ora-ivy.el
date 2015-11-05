;; -*- lexical-binding: t -*-
(require 'ivy)
(setq ivy-display-style 'fancy)
;; (setq ivy-count-format "(%d/%d) ")

(define-key ivy-minibuffer-map (kbd "<return>") 'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "C-M-h") 'ivy-previous-line-and-call)
(define-key ivy-minibuffer-map (kbd "C-:") 'ivy-dired)
(define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-occur)

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

(require 'ivy-hydra)
(defhydra hydra-ivy-sb (:hint nil
                        :color pink
                        :inherit (hydra-ivy/heads))
  ("v" (progn
         (setq ivy-use-virtual-buffers (not ivy-use-virtual-buffers))
         (ivy--reset-state ivy-last))))

(defun hydra-ivy-sb-docstring ()
  (hydra--vconcat
   (list
    (eval hydra-ivy/hint)
    (format "Misc
------------
%sirtual: %-3S

"
            (propertize "v" 'face 'hydra-face-pink)
            ivy-use-virtual-buffers))))

(setq hydra-ivy-sb/hint '(hydra-ivy-sb-docstring))

(define-key ivy-switch-buffer-map (kbd "C-o") 'hydra-ivy-sb/body)

(provide 'ora-ivy)
