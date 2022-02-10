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
(global-set-key "\C-o" 'ora-open-line)                   ; 'open-line
(keyboard-translate ?\C-h ?\C-p)                         ; swap
(keyboard-translate ?\C-p ?\C-h)                         ; swap
;; (global-set-key "\C-q" 'quoted-insert)                ; default
(global-set-key "\C-r" 'counsel-grep-or-swiper)          ; 'isearch-backward
(global-set-key "\C-s" 'swiper)                          ; 'isearch-forward
(global-set-key "\C-t" 'smex)                            ; 'transpose-chars
(global-set-key "\C-u" 'undo)                            ; 'universal-argument
;; (global-set-key "\C-v" 'scroll-up)                    ; default
;; (global-set-key "\C-w" 'kill-region)                  ; default
;; (global-set-key "\C-x")                               ; default
;; (global-set-key "\C-y" 'yank)                         ; default
(global-set-key (kbd "C-z") 'capitalize-word-toggle)     ; capitili[z]e
(global-set-key (kbd "C-.") 'comment-dwim)

;; alacritty translations
(keyboard-translate (aref (kbd "‣") 0) (aref (kbd "C-,") 0))
(keyboard-translate (aref (kbd "•") 0) (aref (kbd "C-.") 0))
(keyboard-translate (aref (kbd "δ") 0) (aref (kbd "C-:") 0))

(global-set-key (kbd "C-,") 'lispy-kill-at-point)
(global-set-key (kbd "C-'") 'avy-goto-char-timer)
(global-set-key (kbd "C-/") 'toggle-input-method)
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
;; (global-set-key (kbd "C-φ") nil)                            ; [f]
(global-set-key (kbd "C->") 'upcase-word-toggle)               ; [g]
(global-set-key (kbd "C-η") 'switch-to-buffer-other-window)    ; [h]
(global-set-key (kbd "C-;") 'dired-jump)                       ; [j]
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
(global-set-key (kbd "C-c f") 'elfeed)
(global-set-key (kbd "C-c F") 'counsel-org-file)
(global-set-key (kbd "C-c G") 'counsel-git)
(global-set-key (kbd "C-c g") 'ora-counsel-git)
(global-set-key (kbd "C-c h") 'hydra-apropos/body)
(global-set-key (kbd "C-c i") 'counsel-imenu)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c J") 'counsel-file-jump)
(global-set-key (kbd "C-c k") 'counsel-rg)
(global-set-key (kbd "C-c K") 'counsel-ag)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c m") 'counsel-linux-app)
(global-set-key (kbd "C-c n") 'counsel-fzf)
(global-set-key (kbd "C-c o") 'counsel-outline)
(global-set-key (kbd "C-c P") 'counsel-package)
(global-set-key (kbd "C-c r") 'isearch-backward)
(global-set-key (kbd "C-c s") 'isearch-forward-regexp)
(global-set-key (kbd "C-s") 'swiper-isearch)
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
(global-set-key (kbd "C-π") 'avy-resume)
(global-set-key (kbd "C-c .") 'org-time-stamp)
(global-set-key (kbd "C-c R") 'counsel-register)

;;* C-x shortcuts
(global-set-key (kbd "C-x C-r") (lambda () (interactive) (revert-buffer nil t)))
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-x C-l") 'locate)
(global-set-key (kbd "C-x m") 'mu4e-compose-new)
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-x p") 'proced)
(global-set-key (kbd "C-x C-i") 'flyspell-correct-word-before-point)
(global-set-key (kbd "C-x C-i") 'flyspell-correct-at-point)
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
(global-set-key (kbd "C-s-p") 'counsel-rhythmbox-playpause-current-song)

;;* Hydras
(require 'hydra-examples)
(require 'ora-hydra-k)
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

(use-package define-word
  :commands define-word-at-point)

(use-package tea-time
  :config
  (setq tea-time-sound-command "play %s"))

(use-package cook
  :commands cook)

(defhydra hydra-toggle (:color pink :hint nil)
  "
_a_ abbrev-mode:       %`abbrev-mode
_b_ backup-files:      %`make-backup-files
_d_ debug-on-error:    %`debug-on-error
_f_ auto-fill-mode:    %`auto-fill-function
_h_ highlight          %`highlight-nonselected-windows
_t_ truncate-lines:    %`truncate-lines
_w_ whitespace-mode:   %`whitespace-mode
_l_ org link display
"
  ("a" abbrev-mode)
  ("b" (setq make-backup-files (not make-backup-files)))
  ("d" toggle-debug-on-error)
  ("e" evil-mode :exit t)
  ("f" auto-fill-mode)
  ("h" (setq highlight-nonselected-windows (not highlight-nonselected-windows)))
  ("t" toggle-truncate-lines)
  ("w" whitespace-mode)
  ("l" org-toggle-link-display)
  ("i" illiterate)
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

(defun hydra-set-mark ()
  (interactive)
  (if (region-active-p)
      (progn
        (deactivate-mark)
        (hydra-keyboard-quit))
    (call-interactively 'set-mark-command)
    (hydra-region/body)))

(defhydra hydra-region ()
  ("E" forward-sentence)
  ("f" forward-word)
  ("b" backward-word)
  ("w" kill-region :exit t))

(defun ora-open-line ()
  (interactive)
  (require 'auto-yasnippet)
  (let (expr markup)
    (unless (cond
             ((progn
                (unless yas-global-mode
                  (yas-global-mode 1))
                (yas--snippets-at-point))
              (yas-next-field-or-maybe-expand)
              t)
             ((ignore-errors
                (setq aya-invokation-point (point))
                (setq aya-invokation-buffer (current-buffer))
                (setq aya-tab-position (- (point) (line-beginning-position)))
                (cl-letf ((yas-fallback-behavior 'return-nil)
                          ((symbol-function #'slime-after-change-function) #'ignore))
                  (yas-expand))))
             ((funcall 'tiny-expand))
             ;; from `emmet-expand-line'
             ((and
               (require 'emmet-mode)
               (setq expr (emmet-expr-on-line))
               (setq markup (emmet-transform (first expr))))
              (delete-region (second expr) (third expr))
              (emmet-insert-and-flash markup)
              (emmet-reposition-cursor expr))
             ((memq major-mode '(html-mode mhtml-mode))
              (emmet-expand-line nil)))
      (hydra-o/body))))

(defhydra hydra-o (:exit t)
  "outl"
  ("o" aya-open-line)
  ("j" lispy-insert-outline-below)
  ;; ("j" zo-insert-outline-below)
  ("h" lispy-insert-outline-left)
  ("p" lispy-insert-prev-outline-body)
  ("f" ora-org-roam-find-file "file")
  ("i" ora-roam-insert "ins")
  ("r" org-roam-random-note "rnd")
  ("b" ora-org-roam-find-backlink "back")
  ("t" ora-roam-todo "todo")
  ("C-o" nil nil))
(hydra-set-property 'hydra-o :verbosity 1)

(defun lispy-insert-prev-outline-body ()
  (interactive)
  (save-excursion
    (insert
     (save-excursion
       (zo-up 1)
       (mapconcat
        'identity
        (cl-remove-if
         (lambda (s)
           (string-match-p "^;;" s))
         (split-string
          (string-trim
           (lispy--string-dwim
            (worf--bounds-subtree)))
          "\n"
          t))
        "\n")))))

(provide 'keys)
