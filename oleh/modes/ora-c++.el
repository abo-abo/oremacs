(require 'subword)
(diminish 'subword-mode)

(use-package function-args
    :init
  (fa-config-default)
  (setq fa-insert-method 'name-space-parens))
(define-key function-args-mode-map (kbd "M-i") nil)
(define-key function-args-mode-map (kbd "C-2") 'fa-show)
(require 'cc-chainsaw)
(require 'auto-yasnippet)
(require 'auto-complete)
(setq-local ac-delay 0.1)
(setq-default c-basic-offset 4)

;;* Font locking
(defface font-lock-doxygen-face
    '((nil (:foreground "SaddleBrown" :background "#f7f7f7")))
  "Special face to highlight doxygen tags such as <tt>...</tt>
and <code>...</code>."
  :group 'font-lock-highlighting-faces)

(font-lock-add-keywords
 'c++-mode
 '(("\\(<\\(?:code\\|tt\\)>\"?\\)\\([^<]*?\\)\\(\"?</\\(?:code\\|tt\\)>\\)"
    (0 (prog1 ()
         (let* ((expr (match-string-no-properties 2))
                (expr-len (length expr)))
           (if (eq 1 expr-len)
               (compose-region (match-beginning 0)
                               (match-end 0)
                               (aref expr 0))
             (compose-region (match-beginning 1)
                             (1+ (match-end 1))
                             (aref expr 0))
             (compose-region (1- (match-beginning 3))
                             (match-end 3)
                             (aref expr (1- expr-len)))))))
    (0 'font-lock-doxygen-face t))))

(font-lock-add-keywords 'c++-mode
                        '(( ;; (regexp-opt '("true" "false"))
                           "\\<\\(?:\\(?:fals\\|tru\\)e\\)\\>"
                           0 font-lock-keyword-face)))

;;* Configure semantic
(require 'semantic/bovine/c)
(add-to-list 'semantic-lex-c-preprocessor-symbol-file
             "/usr/lib/gcc/x86_64-linux-gnu/4.8/include/stddef.h")
(dolist (x (list "/home/usr/local/trilinos/include/"
                 "/usr/local/boost_1_54_0/"))
  (semantic-add-system-include x 'c++-mode))
(dolist (x (list "/usr/include/pango-1.0/"
                 "/usr/include/glib-2.0/"
                 "/usr/lib/x86_64-linux-gnu/glib-2.0/include/"
                 "/usr/include/cairo/"
                 "/usr/include/gtk-3.0/"
                 "/usr/include/gtk-3.0/gdk/"
                 "/usr/include/gdk-pixbuf-2.0/"
                 "/usr/include/atk-1.0/"))
  (semantic-add-system-include x 'c-mode)
  (semantic-add-system-include x 'c++-mode))
(set-default 'semantic-case-fold t)
(defconst emacs-src-dir "~/git/gnu-emacs/")
(semantic-add-system-include (expand-file-name "src/" emacs-src-dir) 'c-mode)
(semantic-add-system-include (expand-file-name "lib/" emacs-src-dir) 'c-mode)

;;* Keymaps
;;** Base
(define-key c-mode-base-map "\C-c\C-c" nil)
(define-key c-mode-base-map (kbd "C-/") nil)
(define-key c-mode-base-map (kbd "C-x C-p")
  (lambda ()
    (interactive)
    (ring-insert find-tag-marker-ring (point-marker))
    (call-interactively 'semantic-ia-fast-jump)))
(define-key c-mode-base-map (kbd "C-M-h") 'hs-toggle-hiding)
(define-key c-mode-base-map "σ" 'ora-braces-c++)
(define-key c-mode-base-map "3"
  (lambda ()
    (interactive)
    (if (region-active-p)
        (call-interactively 'ccc-align-function-arguments)
      (self-insert-command 1))))
(define-key c-mode-base-map (kbd "DEL") 'ccc-electric-del)
;;** C
(define-key c-mode-base-map [f5] 'ccc-run)
(define-key c-mode-base-map (kbd "M-r") 'ccc-run)
(define-key c-mode-map (kbd "M-.") 'semantic-ia-fast-jump)
(define-key c-mode-map (kbd "β") 'moo-complete)

;;** C++
(define-key c++-mode-map (kbd "β") 'moo-complete)
(define-key c++-mode-map (kbd "M-q") 'ccc-align-function-arguments)
(define-key c++-mode-map (kbd "C-M-g") 'hydra-gud/body)
(define-key c++-mode-map (kbd "M-.") 'semantic-ia-fast-jump)
(define-key c++-mode-map (kbd "C-2") 'fa-show)
;; (define-key c++-mode-map (kbd "κ c") 'ccc-ensure-public)
;; (define-key c++-mode-map (kbd "κ e") 'ccc-ensure-private)
;; (define-key c++-mode-map (kbd "κ d") 'ccc-ensure-protected)
;; (define-key c++-mode-map (kbd "κ r") 'semantic-symref-symbol)
(define-key c++-mode-map (kbd "C-x C-n") 'ccc-jump-to-definition)
(define-key c++-mode-map (kbd "C-c C-z") 'ora-c++-to-gud)
(define-key c++-mode-map "." 'ccc-smart-dot)
(define-key ivy-minibuffer-map
    "υ" (lambda ()
          (interactive)
          (let ((function-body
                 (with-selected-window swiper--window
                   (ccc-function-implementation))))
            (when function-body
              (setq aya-current function-body)
              (exit-minibuffer)))))

(require 'soap)
(dolist (k '("+" "-" "*" "/" "%" "&" "|" "<" "=" ">" ","))
  (define-key c++-mode-map (kbd k) 'soap-command))

(dolist (k '("+" "-" "*" "/" "%" "&" "|" "<" "=" ">" ","))
  (define-key c-mode-map (kbd k) 'soap-command))

;;** Hooks
;;;###autoload
(defun ora-c-common-hook ()
  (google-set-c-style)
  (google-make-newline-indent)
  (subword-mode))

;;;###autoload
(defun ora-c-hook ()
  (setq ccc-compile-cmd "gcc -g -O2 -std=c99"))

;;;###autoload
(defun ora-c++-hook ()
  (auto-complete-mode 1)
  (c-toggle-auto-newline)
  (hs-minor-mode))

;;* gud
(require 'gud)
(defun ora-c++-to-gud ()
  (interactive)
  (pop-to-buffer gud-comint-buffer))

(defhydra hydra-gud (:color amaranth)
  ;; vi
  ("h" backward-char)
  ("j" next-line)
  ("k" previous-line)
  ("l" forward-char)
  ;; gud
  ("t" gud-tbreak "tbreak")
  ("b" gud-break "break")
  ("d" gud-remove "nbr")
  ("p" gud-print "print" :color blue)
  ("m" gud-until "move")
  ("n" gud-next "next")
  ("c" gud-cont "cont")
  ("o" gud-finish "out")
  ("r" gud-run "run")
  ("q" nil "quit"))

(provide 'ora-c++)
