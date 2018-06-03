;; keys -*- lexical-binding: t -*-
;;* Ctrl shortcuts
(global-set-key "\C-a" 'ora-move-beginning-of-line)      ; 'move-beginning-of-line
;; (global-set-key "\C-b" 'backward-char)                ; default
;; (global-set-key "\C-c" 'mode-specific-command-prefix) ; default
;; (global-set-key "\C-d" 'delete-char)                  ; default
;; (global-set-key "\C-e" 'move-end-of-line)             ; default
;; (global-set-key "\C-f" 'forward-char)                 ; default
;; (global-set-key "\C-g" 'keyboard-quit)                ; default
;; (global-set-key "\C-h" nil)                           ; 'help-command
;; (global-set-key "\C-i" 'indent-for-tab-command)       ; default
(global-set-key (kbd "C-i") 'indent-for-tab-command)
;; (global-set-key "\C-j" 'newline)                      ; default
;; (global-set-key "\C-k" 'kill-line)                    ; default
;; (global-set-key "\C-l" 'recenter-top-bottom)          ; default
;; (global-set-key "\C-m" 'newline-and-indent)           ; default
;; (global-set-key "\C-n" 'next-line)                    ; default
(global-set-key "\C-o" 'aya-open-line)                   ; 'open-line
(keyboard-translate ?\C-h ?\C-p)                         ; swap
(keyboard-translate ?\C-p ?\C-h)                         ; swap
;; (global-set-key "\C-q" 'quoted-insert)                ; default
(global-set-key "\C-r" 'swiper)                          ; 'isearch-backward
(global-set-key "\C-s" 'counsel-grep-or-swiper)          ; 'isearch-forward
(global-set-key "\C-t" 'smex)                            ; 'transpose-chars
(global-set-key "\C-u" 'undo)                            ; 'universal-argument
;; (global-set-key "\C-v" 'scroll-up)                    ; default
;; (global-set-key "\C-w" 'kill-region)                  ; default
;; (global-set-key "\C-x")                               ; default
;; (global-set-key "\C-y" 'yank)                         ; default
(global-set-key (kbd "C-z") 'capitalize-word-toggle)     ; capitili[z]e
(global-set-key (kbd "C-.") 'comment-dwim)
(global-set-key (kbd "C-,") 'lispy-kill-at-point)
(global-set-key (kbd "C-'") 'avy-goto-char-timer)
(global-set-key (kbd "C-/") 'hydra-org-objects/body)
(global-set-key (kbd "C-7") 'mc/mark-next-like-this)
;;* Ctrl Meta shortcuts
(global-set-key (kbd "C-M-,") 'lispy-mark)
(global-set-key (kbd "C-M-h") 'backward-list)
;; (global-set-key (kbd "C-M-i") 'completion-at-point)
(global-set-key (kbd "C-M-q") 'ora-unfill-paragraph)
;;* Ctrl Mod4 shortcuts
(global-set-key (kbd "C-θ") 'ora-single-quotes)                ; [q]
(global-set-key (kbd "C-ω") 'aya-create)                       ; [w]
(global-set-key (kbd "C-=") 'eval-expression)                  ; [e]
(global-set-key (kbd "C-ρ") 'ora-eval-other-window)            ; [r]
(global-set-key (kbd "C-~") nil)                               ; [t]
(global-set-key (kbd "C-υ") 'aya-create)                       ; [y]
(global-set-key (kbd "C-ψ") 'moo-jump-local)                   ; [u]
(global-set-key [C-tab] 'ora-ctrltab)                          ; [i]
(global-set-key [C-backspace] 'ora-backward-delete-whitespace) ; [o]
(global-set-key (kbd "C-π") nil)                               ; [p]
(global-set-key (kbd "C--") 'org-capture)                      ; [a]
;; (global-set-key (kbd "C-_") 'undo)                          ; [u]
(global-set-key (kbd "C-:") 'ora-dired-jump)                   ; [d]
(global-set-key (kbd "C->") 'upcase-word-toggle)               ; [g]
(global-set-key (kbd "C-η") 'switch-to-buffer-other-window)    ; [h]
(global-set-key (kbd "C-;") nil)                               ; [j]
(global-set-key (kbd "C-κ") 'ora-kill-current-buffer)          ; [k]
(global-set-key (kbd "C-<") 'rgrep)                            ; [l]
(global-set-key (kbd "C-+") nil)                               ; [z]
(global-set-key (kbd "C-χ") nil)                               ; [x]
(global-set-key (kbd "C-σ") nil)                               ; [c]
(global-set-key (kbd "<C-return>") nil)                        ; [v]
(global-set-key (kbd "C-β") nil)                               ; [b]
(global-set-key (kbd "C-ν") 'ora-angles)                       ; [n]
(global-set-key (kbd "C-μ") 'headlong-bookmark-jump-other)     ; [m]
;;* Mod4 shortcuts
(global-set-key "θ" 'ora-quotes)                             ; [q]
;; (global-set-key "ω" 'self-insert-command)                 ; [w]
;; (global-set-key (kbd "=") 'self-insert-command)           ; [e]
(global-set-key "ρ" 'ora-brackets)                           ; [r]
;; (global-set-key (kbd "~") 'self-insert-command)           ; [t]
(global-set-key "υ" 'aya-expand)                             ; [y]
(global-set-key "ψ" 'universal-argument)                     ; [u]
;; (global-set-key (kbd "TAB") 'self-insert-command)         ; [i]
;; (global-set-key (kbd "DEL") 'self-insert-command)         ; [o]
(global-set-key (kbd "π") 'avy-goto-char)                    ; [p]
;; (global-set-key (kbd "-") 'self-insert-command)           ; [a]
;; (global-set-key (kbd "_") 'self-insert-command)           ; [s]
;; (global-set-key (kbd ":") 'self-insert-command)           ; [d]
(global-set-key "φ" 'ora-parens)                             ; [f]
;; (global-set-key (kbd ">") 'self-insert-command)           ; [g]
(global-set-key "η" 'ora-save-and-switch-buffer)             ; [h]
;; (global-set-key (kbd ";") 'self-insert-command)           ; [j]
(global-set-key "κ" 'hydra-k/body)                           ; [k]
;; (global-set-key (kbd "<") 'self-insert-command)           ; [l]
;; (global-set-key (kbd "+") 'self-insert-command)           ; [z]
(global-set-key "χ" 'lispy-right)                            ; [x]
(global-set-key "σ" 'ora-braces)                             ; [c]
;; (global-set-key (kbd "RET") 'newline)                     ; [v]
(global-set-key "β" nil)                                     ; [b]
(global-set-key "ν" 'ace-window)                             ; [n]
(global-set-key "μ" 'headlong-bookmark-jump)                 ; [m]
;;* Meta shortcuts
(global-set-key (kbd "M-%") 'ora-query-replace)
(global-set-key (kbd "M-.") nil)
(global-set-key (kbd "M-t") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "M-m") 'lispy-mark-symbol)
(global-set-key (kbd "M-p") 'avy-pop-mark)
(global-set-key (kbd "M-i") 'iedit-mode)
(global-set-key (kbd "M-,") 'pop-tag-mark)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "M-a") 'ace-link)
(global-set-key (kbd "M-u") 'universal-argument)

;;* C-c shortcuts
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'counsel-bookmark)
(global-set-key (kbd "C-c c") (lambda () (interactive) (org-capture nil "t")))
(global-set-key (kbd "C-c d") 'counsel-descbinds)
(global-set-key (kbd "C-c e") 'mu4e)
(global-set-key (kbd "C-c f") 'find-file-in-project)
(global-set-key (kbd "C-c F") 'counsel-org-file)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c h") 'hydra-apropos/body)
(global-set-key (kbd "C-c i") 'counsel-semantic)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-c k") 'counsel-rg)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c m") 'counsel-linux-app)
(global-set-key (kbd "C-c n") 'counsel-fzf)
(global-set-key (kbd "C-c o") 'counsel-outline)
(global-set-key (kbd "C-c q") nil)
(global-set-key (kbd "C-c r") 'isearch-backward)
(global-set-key (kbd "C-c s") 'isearch-forward-regexp)
(global-set-key (kbd "C-c t") 'counsel-load-theme)
(global-set-key (kbd "C-c u") 'swiper-all)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c w") 'counsel-wmctrl)
(global-set-key (kbd "C-c x") nil)
(global-set-key (kbd "C-c y") 'pamparam-drill)
(global-set-key (kbd "C-c E") 'vc-ediff)
(global-set-key (kbd "C-c L") 'counsel-git-log)
(global-set-key (kbd "C-c D") 'ora-insert-date-from)
(global-set-key (kbd "C-c V") 'ivy-pop-view)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-c C-j") 'avy-resume)
(global-set-key (kbd "C-c n") 'counsel-fzf)

;;* C-x shortcuts
(global-set-key (kbd "C-x C-r") (lambda () (interactive) (revert-buffer nil t)))
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-x C-l") 'locate)
;; (global-set-key (kbd "C-x m") 'mu4e-compose-new)
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-x p") 'proced)
(global-set-key (kbd "C-x C-i") 'flyspell-correct-word-before-point)
;;* Functional keys shortcuts
(global-set-key (kbd "<f1> a") 'apropos)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> k") 'kill-buffer)
(global-set-key (kbd "<f2> o") (lambda () (interactive) (search-forward "\"" (line-end-position) t) (ffap)))
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "<f2> C-u") 'helm-ucs)
(global-set-key (kbd "<f2> j") 'counsel-set-variable)
(global-set-key [f5] 'helm-make)
(global-set-key [C-f5] 'compile)
(global-set-key [f6] 'cook)
(global-set-key [f7] 'winner-undo)
(global-set-key [C-f7] 'winner-redo)
(global-set-key [f8] 'bookmark-bmenu-list)
(global-set-key [C-f8] 'bookmark-set)
(global-set-key [f9] 'delete-other-windows)
(global-set-key [C-f9] 'delete-window)
(global-set-key [f11] 'ora-org-clock-out)
(global-set-key [C-f11] 'org-clock-goto)
(global-set-key [f12] 'orfu-agenda-day)
(global-set-key [C-f12] 'orfu-agenda-quick)
(global-set-key (kbd "C-<f1>") (lambda () (interactive) (shell-command "setxkbmap ua")))
(global-set-key (kbd "C-<f2>") (lambda () (interactive) (shell-command "setxkbmap us;xmodmap ~/.Xmodmap")))
;;* Misc shortcuts
(define-key universal-argument-map "ψ" 'universal-argument-more)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;;* Hydras
(require 'hydra-examples)
(defhydra hydra-error (global-map "M-g")
  "goto-error"
  ("h" first-error "first")
  ("j" next-error "next")
  ("k" previous-error "prev")
  ("v" recenter-top-bottom "recenter")
  ("q" nil "quit"))
(global-set-key (kbd "M-g g") 'avy-goto-line)
(global-set-key (kbd "C-M-g") 'avy-goto-line)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g s") 'avy-goto-subword-0)

(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out")
  ("r" (text-scale-set 0) "reset")
  ("0" (text-scale-set 0) :bind nil :exit t)
  ("1" (text-scale-set 0) nil :bind nil :exit t))

(defhydra hydra-launcher (:color blue :columns 2)
  "Launch"
  ("h" man "man")
  ("r" (browse-url "http://www.reddit.com/r/emacs/") "reddit")
  ("w" (browse-url "http://www.emacswiki.org/") "emacswiki")
  ("s" shell "shell")
  ("q" nil "cancel"))

(defhydra hydra-k (:color blue
                   :idle 0.8)
  "k"
  ("a" orfu-agenda-day "agenda")
  ("c" ora-flyspell-previous-word "correct")
  ("j" dired-jump "dired")
  ("b" hydra-launcher/body "browse")
  ("d" define-word-at-point "def")
  ("e" ora-ediff-dwim "ediff")
  ("E" eval-expression "eval")
  ("m" hydra-pamparam/body "pamparam")
  ("R" counsel-recoll "recoll")
  ("o" ccc-toggle-header-source "other")
  ("g" ora-github "github")
  ("p" ora-project "project")
  ("n" ora-open-wikitionary "wikitionary")
  ("N" ora-open-google-translate "google-translate")
  ("f" (if (region-active-p)
           (vimish-fold (region-beginning) (region-end))
         (hydra-vimish-fold/body)) "fold")
  ("t" tea-time "tea")
  ("w" plain-org-wiki "wiki")
  ("W" ora-open-wikipedia "wikipedia")
  ("q" nil "quit"))

(defhydra hydra-vimish-fold (:color blue
                             :columns 3)
  "fold"
  ("a" vimish-fold-avy "avy")
  ("d" vimish-fold-delete "del")
  ("D" vimish-fold-delete-all "del-all")
  ("u" vimish-fold-unfold "undo")
  ("U" vimish-fold-unfold-all "undo-all")
  ("f" vimish-fold "fold")
  ("r" vimish-fold-refold "refold")
  ("R" vimish-fold-refold-all "refold-all")
  ("t" vimish-fold-toggle "toggle" :exit nil)
  ("T" vimish-fold-toggle-all "toggle-all" :exit nil)
  ("j" vimish-fold-next-fold "down" :exit nil)
  ("k" vimish-fold-previous-fold "up" :exit nil)
  ("q" nil "quit"))

(defhydra hydra-toggle (:color pink :hint nil)
  "
_a_ abbrev-mode:       %`abbrev-mode
_d_ debug-on-error:    %`debug-on-error
_f_ auto-fill-mode:    %`auto-fill-function
_h_ highlight          %`highlight-nonselected-windows
_t_ truncate-lines:    %`truncate-lines
_w_ whitespace-mode:   %`whitespace-mode
_l_ org link display:  %`org-descriptive-links
"
  ("a" abbrev-mode)
  ("d" toggle-debug-on-error)
  ("f" auto-fill-mode)
  ("h" (setq highlight-nonselected-windows (not highlight-nonselected-windows)))
  ("t" toggle-truncate-lines)
  ("w" whitespace-mode)
  ("l" org-toggle-link-display)
  ("q" nil "quit"))

(global-set-key (kbd "C-c C-v") 'hydra-toggle/body)

(defhydra hydra-window (:color red
                        :columns nil)
  "window"
  ("h" windmove-left nil)
  ("j" windmove-down nil)
  ("k" windmove-up nil)
  ("l" windmove-right nil)
  ("H" hydra-move-splitter-left nil)
  ("J" hydra-move-splitter-down nil)
  ("K" hydra-move-splitter-up nil)
  ("L" hydra-move-splitter-right nil)
  ("v" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right))
       "vert")
  ("x" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down))
       "horz")
  ("t" transpose-frame "'" :exit t)
  ("o" delete-other-windows "one" :exit t)
  ("a" ace-window "ace")
  ("s" ace-swap-window "swap")
  ("d" ace-delete-window "del")
  ("i" ace-maximize-window "ace-one" :exit t)
  ("b" ido-switch-buffer "buf")
  ("m" headlong-bookmark-jump "bmk")
  ("q" nil "cancel")
  ("u" (progn (winner-undo) (setq this-command 'winner-undo)) "undo")
  ("f" nil))

(defhydra hydra-apropos (:color blue
                         :hint nil)
  "
_m_an              _c_ommand
_a_propos          _l_ibrary
_d_ocumentation    _u_ser-option
_v_ariable     valu_e_"
  ("m" man)
  ("a" apropos)
  ("d" apropos-documentation)
  ("v" apropos-variable)
  ("c" apropos-command)
  ("l" apropos-library)
  ("u" apropos-user-option)
  ("e" apropos-value))
(global-set-key (kbd "C-M-o") 'hydra-window/body)
(global-set-key (kbd "C-M-k") 'hydra-pause-resume)
(global-set-key (kbd "C-M-k") 'ora-kill-current-buffer)
(global-set-key (kbd "C-M-y") 'counsel-hydra-heads)
(global-set-key (kbd "C-M-j") 'counsel-semantic)
(global-set-key (kbd "C-x SPC") 'hydra-rectangle/body)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-t") 'counsel-M-x)
(global-set-key (kbd "C-SPC") 'hydra-set-mark)
(global-set-key (kbd "C-SPC") 'set-mark-command)
(global-set-key (kbd "<down-mouse-3>") 'ora-open-file-at-point)
;; unbind 'mouse-buffer-menu
(global-set-key [C-down-mouse-1] 'ignore)


(provide 'keys)
