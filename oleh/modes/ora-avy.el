;;* Ace Window
(require 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(setq aw-background nil)
(csetq aw-flip-keys '("n" "ν"))
(add-to-list 'aw-dispatch-alist '(?ν aw-flip-window))

;;* Avy
(avy-setup-default)
(setq avy-all-windows nil)
(setq avy-styles-alist '((avy-goto-char-2 . post)))

;;* Lispy
(setq avy-keys-alist
      `((lispy-ace-symbol . ,aw-keys)))

(provide 'ora-avy)
