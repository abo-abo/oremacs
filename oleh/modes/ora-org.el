;;* Requires
(require 'org)
(require 'org-fu)
(require 'org-weather)
(setq org-weather-location "Eindhoven,NL")
(setq org-weather-api-key "bfb812a56cff56fe7efeea207643a153")
(add-to-list 'load-path (expand-file-name "git/org-mode/contrib/lisp/" emacs-d))
(require 'org-src)
(require 'worf)
(require 'org-download)
(org-download-enable)

;;;###autoload
(defun ora-org-hook ()
  (worf-mode)
  (org-bullets-mode)
  (org-indent-mode))

;;;###autoload
(defun ora-org-agenda-hook ())

;;* Keys
;;** org-mode-map
(define-key org-mode-map (kbd "C-,") nil)
(define-key org-mode-map (kbd "C-'") nil)
(define-key org-mode-map (kbd "C-TAB") nil)
(define-key org-mode-map (kbd "C-M-i") nil)
(define-key org-mode-map [C-tab] nil)
(define-key org-mode-map (kbd "<f2> a") 'org-archive)
(define-key org-mode-map (kbd "χ") 'worf-back-to-heading)
(define-key org-mode-map (kbd "C-σ") 'org-edit-special)
(define-key org-mode-map (kbd "C-a") 'ora-move-beginning-of-line)
(define-key org-mode-map (kbd "M-r") 'org-ctrl-c-ctrl-c)
(define-key org-src-mode-map (kbd "C-c C-c") 'org-edit-src-exit)
(define-key org-mode-map (kbd "C-c C-q") 'counsel-org-tag)

;;** org-agenda-mode-map
(require 'org-agenda)
(define-key org-agenda-mode-map "h" 'previous-line)
(define-key org-agenda-mode-map (kbd "C-j") 'org-open-at-point)
(define-key org-agenda-mode-map "i" 'org-agenda-clock-in)
(define-key org-agenda-mode-map "o" 'org-agenda-clock-out)
(define-key org-agenda-mode-map "0" 'ora-org-schedule-today)
;; was `org-agenda-goto-date'
(define-key org-agenda-mode-map "j" 'org-agenda-next-line)
;; was `org-agenda-capture'
(define-key org-agenda-mode-map "k" 'org-agenda-previous-line)

;;* Basic settings
(setq-default org-todo-keywords
              '((sequence "TODO" "NEXT" "|" "DONE" "CANCELLED")))
(setq org-startup-indented t)
(setq org-startup-folded nil)
(setq org-cycle-separator-lines 0)
(setq org-return-follows-link t)
(setq org-bookmark-names-plist
      '(:last-capture "jc:  org-last-capture"
        :last-refile "jr:  org-last-refile"))
(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))
(setq-default org-tags-column -96)
(setq org-completion-use-ido t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-sound "/usr/local/share/tngchime.wav")
(setq org-latex-create-formula-image-program 'dvipng)
(plist-put org-format-latex-options :scale 1.5)
(setq org-image-actual-width 300)

;;* Interactions
(setq org-file-apps
      '((auto-mode . emacs)
        ("\\.x?html?\\'" . "firefox %s")
        ("\\.pdf\\'" . "evince \"%s\"")
        ("\\.gif\\'" . "eog \"%s\"")
        ("\\.pdf::\\([0-9]+\\)\\'" . "evince \"%s\" -p %1")
        ("\\.pdf.xoj" . "xournal %s")))
(setq system-time-locale "C")
(setq appt-display-diary nil)

;;* appt
(require 'appt)
(appt-activate t)
(setq appt-display-interval 5)
(setq appt-message-warning-time 15)
(setq appt-display-mode-line t)
(display-time)
(setq appt-display-format 'window)
(setq appt-disp-window-function #'ora-appt-display)
(run-at-time "24:01" nil #'ora-org-agenda-to-appt)
(add-hook 'org-finalize-agenda-hook #'ora-org-agenda-to-appt)

;;* TODO settings
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(setq org-enforce-todo-dependencies t)
(setq org-log-done 'time)
(setq org-deadline-warning-days 30)

;;* Agenda settings
(setq org-agenda-span 'day)
(setq org-agenda-remove-tags t)

;;* Export settings
(setq org-export-with-timestamps nil)
(setq org-src-preserve-indentation t)

;;** HTML
(require 'ox-html)
(setq org-html-validation-link nil)
(setq org-html-postamble nil)
(setq org-html-text-markup-alist
      '((bold . "<b>%s</b>")
        (code . "<kbd>%s</kbd>")
        (italic . "<i>%s</i>")
        (strike-through . "<del>%s</del>")
        (underline . "<span class=\"underline\">%s</span>")
        (verbatim . "<code>%s</code>")))
(setq org-html-style-default nil)

;;** LaTeX
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted" nil))
(setq org-latex-listings 'minted)
(setq org-latex-preview-ltxpng-directory ".ltxpng/")
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;;* Files
(setq org-archive-location "archive/%s_archive::")

;;* Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   (sh . t)
   (python . t)
   (emacs-lisp . t)
   (matlab . t)
   (latex . t)
   (C . t)
   (J . t)
   (scheme . t)
   (lisp . t)
   (latex . t)
   (calc . t)))
(require 'j-font-lock)
(add-to-list 'org-src-lang-modes '("J" . j))
(eval-when-compile
  (require 'ob-C)
  (require 'ob-ruby)
  (require 'ob-python)
  (require 'ob-scheme)
  (require 'ob-clojure))
(setq org-babel-C-compiler "gcc -std=c99")
(setq org-babel-default-header-args:ruby '((:results . "pp output")))
(setq org-confirm-babel-evaluate nil)
;; for expanding <s
(setcdr (assoc "s" org-structure-template-alist)
        '("#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>"))
(require 'htmlfontify)
(setq org-src-fontify-natively t)
(csetq org-babel-clojure-backend 'cider)
(defvar org-babel-default-header-args:clojure
  '((:results . "value") (:tangle . "yes")))
(setq org-babel-default-header-args:python
      '((:results . "output")))

;;* misc functions
(font-lock-add-keywords
 'org-mode
 '(("^ *\\(,\\*\\)" (1 (prog1 ()
                     (compose-region (match-beginning 1)
                                     (match-end 1)
                                     ?*))))))
(setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n'")
(csetq org-emphasis-alist org-emphasis-alist)

(defun ora-org-schedule-today ()
  (interactive)
  (org-agenda-schedule 0))

(defun ora-org-popup (title msg &optional icon sound)
  "Show a popup if we're on X, or echo it otherwise; TITLE is the title
of the message, MSG is the context. Optionally, you can provide an ICON and
a sound to be played"
  (interactive)
  (if (eq window-system 'x)
      (progn
        (notifications-notify
         :title title
         :body msg
         :app-icon icon
         :urgency 'low)
        (ora-dired-start-process
         (concat "mplayer -really-quiet " sound " 2> /dev/null")))
    ;; text only version
    (message (concat title ": " msg))))

(defun ora-appt-display (min-to-app new-time msg)
  "our little façade-function for ora-org-popup"
  (ora-org-popup (format "Appointment in %s minute(s)" min-to-app) msg
                 "/usr/share/icons/gnome/32x32/status/appointment-soon.png"
                 "/usr/share/sounds/ubuntu/stereo/phone-incoming-call.ogg"))

(defun ora-org-agenda-to-appt ()
  "Erase all reminders and rebuild reminders for today from the agenda"
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

(defun hot-expand (str)
  "Expand org template."
  (insert str)
  (org-try-structure-completion))

(defhydra hydra-org-template (:color blue :hint nil)
  "
_c_enter  _q_uote    _L_aTeX:
_l_atex   _e_xample  _i_ndex:
_a_scii   _v_erse    _I_NCLUDE:
_s_rc     ^ ^        _H_TML:
_h_tml    ^ ^        _A_SCII:
"
  ("s" (hot-expand "<s"))
  ("e" (hot-expand "<e"))
  ("q" (hot-expand "<q"))
  ("v" (hot-expand "<v"))
  ("c" (hot-expand "<c"))
  ("l" (hot-expand "<l"))
  ("h" (hot-expand "<h"))
  ("a" (hot-expand "<a"))
  ("L" (hot-expand "<L"))
  ("i" (hot-expand "<i"))
  ("I" (hot-expand "<I"))
  ("H" (hot-expand "<H"))
  ("A" (hot-expand "<A"))
  ("<" self-insert-command "ins")
  ("o" nil "quit"))

(defhydra hydra-global-org (:color blue
                            :hint nil)
  "
Timer^^        ^Clock^         ^Capture^
--------------------------------------------------
s_t_art        _w_ clock in    _c_apture
 _s_top        _o_ clock out   _l_ast capture
_r_eset        _j_ clock goto
_p_rint
"
  ("t" org-timer-start)
  ("s" org-timer-stop)
  ;; Need to be at timer
  ("r" org-timer-set-timer)
  ;; Print timer value to buffer
  ("p" org-timer)
  ("w" (org-clock-in '(4)))
  ("o" org-clock-out)
  ;; Visit the clocked task from any buffer
  ("j" org-clock-goto)
  ("c" org-capture)
  ("l" org-capture-goto-last-stored))

(define-key org-mode-map "<"
  (lambda () (interactive)
     (if (looking-back "^")
         (hydra-org-template/body)
       (self-insert-command 1))))

(require 'org-fu)
(provide 'ora-org)
