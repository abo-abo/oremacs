(use-package ace-link
  :config (ace-link-setup-default))
;;* Ace Window
(require 'ace-window)
(csetq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(csetq aw-background nil)

(csetq aw-flip-keys '("n" "ν"))
(add-to-list 'aw-dispatch-alist '(?ν aw-flip-window))

;;** Display pop-up buffers with `ace-window'
;; https://github.com/abo-abo/ace-window/pull/187
;; (setq display-buffer-base-action '((display-buffer-reuse-window
;;                                     ace-display-buffer)))
(setq display-buffer-alist '(("\\*Org Attach\\[R"
                              ;; see also: `helm-split-window-default-fn'
                              (display-buffer-pop-up-window))
                             ("\\*help\\[R" (display-buffer-reuse-mode-window
                                             ace-display-buffer))
                             ("\\*helm"
                              ;; see also: `helm-split-window-default-fn'
                              (display-buffer-pop-up-window))
                             ("magit-diff:" (ace-display-buffer)
                              (inhibit-same-window . t))))

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
