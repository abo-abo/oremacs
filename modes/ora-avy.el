;;* Ace Window
(require 'ace-window)
(csetq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(csetq aw-background nil)

(csetq aw-flip-keys '("n" "ν"))
(add-to-list 'aw-dispatch-alist '(?ν aw-flip-window))

;;* Avy
(avy-setup-default)
(csetq avy-all-windows t)
(csetq avy-all-windows-alt nil)
(csetq avy-styles-alist '((avy-goto-char-2 . post)
                          (ivy-avy . pre)
                          (avy-goto-line . pre)))

;;* Lispy
(csetq avy-keys-alist
       `((lispy-ace-symbol . ,aw-keys)))

(defhydra hydra-avy (:color teal)
  ("j" avy-goto-char "char")
  ("w" avy-goto-word-0 "word-0")
  ("SPC" avy-goto-whitespace-end "ws")
  ("e" avy-goto-word-1 "word-1")
  ("l" avy-goto-line "line")
  ("s" avy-goto-char-timer "timer")
  ("f" counsel-find-file)
  ("q" nil))

(defhydra hydra-avy-cycle ()
  ("j" avy-next "next")
  ("k" avy-prev "prev")
  ("q" nil "quit"))

(global-set-key (kbd "C-M-'") 'hydra-avy-cycle/body)

(provide 'ora-avy)
