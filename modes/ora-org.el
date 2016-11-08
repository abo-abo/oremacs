;;* Requires
(setq org-export-backends '(html latex))
(setq org-export-with-sub-superscripts nil)
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
(require 'org-pomodoro)
(setq org-attach-file-list-property nil)
(setq org-reveal-hlevel 2)

(require 'org-bullets)
(setcdr org-bullets-bullet-map nil)
(setq org-hide-emphasis-markers t)

;;;###autoload
(defun ora-org-hook ()
  (worf-mode)
  (org-bullets-mode)
  (org-indent-mode)
  (add-to-list 'prettify-symbols-alist
               '(":PROPERTIES:" . ":"))
  (prettify-symbols-mode)
  (setq completion-at-point-functions '(org-completion-refs t)))

;;;###autoload
(defun ora-org-agenda-hook ())

;;* Keys
;;** org-mode-map
(define-key org-mode-map (kbd "C-,") nil)
(define-key org-mode-map (kbd "C-'") nil)
(define-key org-mode-map (kbd "C-TAB") nil)
(define-key org-mode-map (kbd "C-M-i") nil)
(define-key org-mode-map (kbd "C-c C-r") nil)
(define-key org-mode-map [C-tab] nil)
(define-key org-mode-map (kbd "<f2> a") 'org-archive)
(define-key org-mode-map (kbd "χ") 'worf-back-to-heading)
(define-key org-mode-map (kbd "C-σ") 'org-edit-special)
(define-key org-mode-map (kbd "C-a") 'ora-move-beginning-of-line)
(define-key org-mode-map (kbd "M-r") 'org-ctrl-c-ctrl-c)
(define-key org-src-mode-map (kbd "C-c C-c") 'org-edit-src-exit)
(define-key org-mode-map (kbd "C-c C-v") nil)
(define-key org-mode-map (kbd "C-c C-q") 'counsel-org-tag)
(define-key org-agenda-mode-map (kbd "<backspace>") 'ora-org-agenda-unmark-backward)

(defun ora-org-agenda-unmark-backward ()
  (interactive)
  (forward-line -1)
  (org-agenda-bulk-unmark)
  (forward-line -1))

;; (define-key org-mode-map (kbd "$") 'ora-dollars)

;;** org-agenda-mode-map
(require 'org-agenda)

(let ((map org-agenda-mode-map))
  ;; unbind
  (define-key map "a" 'worf-reserved)
  (define-key map "b" 'worf-reserved)
  (define-key map "c" 'worf-reserved)
  (define-key map "d" 'worf-reserved)
  (define-key map "e" 'worf-reserved)
  (define-key map "f" 'worf-reserved)
  (define-key map "n" 'worf-reserved)
  (define-key map "o" 'worf-reserved)
  (define-key map "u" 'worf-reserved)
  (define-key map "w" 'worf-reserved)
  (define-key map "y" 'worf-reserved)
  (define-key map "z" 'worf-reserved)
  ;; arrows
  (define-key map "j" 'org-agenda-next-item)
  (define-key map "k" 'org-agenda-previous-item)
  (define-key map "h" 'org-agenda-earlier)
  (define-key map "l" 'org-agenda-later)
  ;; worf
  (define-key map "s" 'worf-schedule)
  (define-key map "N" 'worf-agenda-narrow)
  (define-key map "W" 'worf-agenda-widen)
  (define-key map "t" 'worf-todo)
  ;; misc
  (define-key map "p" 'ora-org-pomodoro)
  (define-key map (kbd "C-j") 'org-open-at-point)
  (define-key map "i" 'org-agenda-clock-in)
  (define-key map "o" 'org-agenda-clock-out)
  (define-key map "0" 'digit-argument)
  (define-key map "1" 'digit-argument)
  (define-key map "v" 'hydra-org-agenda-view/body)
  (define-key map "x" 'hydra-org-agenda-ex/body)
  (define-key map "S" 'org-save-all-org-buffers)
  (define-key map "T" 'worf-clock-in-and-out)
  ;; disable
  (define-key map "f" nil))

(defhydra hydra-org-agenda-ex (:color blue :columns 2)
  "x"
  ("a" org-agenda-archive-default-with-confirmation "archive")
  ("b" org-agenda-earlier "earlier")
  ("c" org-agenda-goto-calendar "calendar")
  ("e" org-agenda-set-effort "effort")
  ("h" org-agenda-holidays "holidays")
  ("i" org-agenda-diary-entry "diary entry")
  ("j" org-agenda-goto-date "goto date")
  ("k" org-agenda-capture "capture")
  ("l" org-agenda-log-mode "log-mode")
  ("o" delete-other-windows "one window")
  ("r" org-agenda-redo "redo")
  ("u" org-agenda-bulk-unmark "unmark")
  ("z" org-agenda-add-note "note"))

;;* Basic settings
(setq-default org-todo-keywords
              '((sequence "TODO" ;; "NEXT"
                 "|" "DONE" "CANCELLED")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("WAITING" . (:foreground "blue" :weight bold))))
(setq org-return-follows-link nil)
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
(remove-hook 'org-finalize-agenda-hook #'ora-org-agenda-to-appt)
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
(setq org-html-postamble "<enddoc>End.</enddoc>")
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
(setq org-archive-location "archive/gtd.org_archive::")

;;* Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   (shell . t)
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
(setq org-babel-default-header-args:sh
      '((:results . "verbatim")))
(setq org-babel-default-header-args:bash
      '((:results . "verbatim")))

;;* misc functions
(font-lock-add-keywords
 'org-mode
 '(("^ *\\(,\\*\\)" (1 (prog1 ()
                     (compose-region (match-beginning 1)
                                     (match-end 1)
                                     ?*))))))
(setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n")
(csetq org-emphasis-alist org-emphasis-alist)

(defun ora-org-schedule-today ()
  (interactive)
  (org-agenda-schedule 0 "+0d"))

(defun ora-org-schedule-tomorrow ()
  (interactive)
  (org-agenda-schedule 0 "+1d"))

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
        (ora-start-process
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
  ;; (setq appt-time-msg-list nil)
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
  ("t" (hot-expand "<t"))
  ("<" self-insert-command "ins")
  ("o" nil "quit"))

(define-key org-mode-map "<"
  (defun org-self-insert-or-less ()
    (interactive)
    (if (looking-back "^")
        (hydra-org-template/body)
      (self-insert-command 1))))

(font-lock-add-keywords 'org-mode
                        '(("\\\\(\\([^(]*\\)\\\\)" 0 'font-latex-math-face prepend)))

;;* Mode Objects
(defhydra hydra-org-objects (:exit t)
  "org-objects"
  ("t" hydra-org-timer/body "timer")
  ("c" hydra-org-clock/body "clock"))

;;** Timer
(defhydra hydra-org-timer (:exit t
                           :columns 2)
  "org-timer"
  ;; "run"
  ("rr" org-timer-start "run relative")
  ("rd" org-timer-set-timer "run descending")
  ;; "kill"
  ("k" org-timer-stop "kill")
  ;; "pause"
  ("z" org-timer-pause-or-continue "suspend/resume")
  ;; "insert"
  ("is" org-timer "insert simple")
  ("ii" org-timer-item "insert item")
  ("im" org-timer-show-remaining-time "insert as message")
  ;; "change"
  ("c" org-timer-change-times-in-region "change in region")
  ;; "menu"
  ("b" hydra-org-objects/body "back")
  ("q" nil "quit"))

;;** Clock
(defun ora-org-clock-goto ()
  (interactive)
  (ring-insert
   find-tag-marker-ring
   (point-marker))
  (org-clock-goto))

(defhydra hydra-org-clock (:color teal
                           :columns 2)
  "org-clock"
  ;; "run"
  ("ri" org-clock-in "in here")
  ("rj" (org-clock-in '(4)) "in choice")
  ("rl" org-clock-in-last "in last")
  ("ro" org-clock-out "out")
  ;; "kill"
  ("k" org-clock-cancel "kill")
  ;; "goto"
  ("g" ora-org-clock-goto "goto")
  ;; "change"
  ("ce" org-clock-modify-effort-estimate "change estimate")
  ("cs" hydra-org-clock-timestamps/body "timestamps")
  ;; "insert"
  ("ir" org-clock-report "insert report")
  ("it" hydra-org-clock-display/body "display time")
  ;; "menu"
  ("b" hydra-org-objects/body "back")
  ("q" nil "quit"))

(defhydra hydra-org-clock-display (:color teal
                                   :columns 1)
  "org-clock-display"
  ("i" org-clock-display "for buffer")
  ("t" (org-clock-display '(4)) "for today")
  ("j" (org-clock-display '(16)) "for interval")
  ("a" (org-clock-display '(64)) "for all")
  ("k" org-clock-remove-overlays "kill")
  ;; "menu"
  ("b" hydra-org-clock/body "back")
  ("q" nil "quit"))

(defhydra hydra-org-clock-timestamps ()
  "org-clock-timestamps"
  ("h" backward-word "left")
  ("j" org-clock-timestamps-down "down")
  ("k" org-clock-timestamps-up "up")
  ("l" forward-word "right")
  ("b" hydra-org-clock/body "back" :exit t)
  ("q" nil "quit"))

(defun org-agenda-cts ()
  (and (eq major-mode 'org-agenda-mode)
       (let ((args (get-text-property
                    (min (1- (point-max)) (point))
                    'org-last-args)))
         (nth 2 args))))

(defhydra hydra-org-agenda-view (:hint none)
  "
_d_: ?d? day        _g_: time grid=?g?  _a_: arch-trees
_w_: ?w? week       _[_: inactive       _A_: arch-files
_t_: ?t? fortnight  _f_: follow=?f?     _r_: clock report=?r?
_m_: ?m? month      _e_: entry text=?e? _D_: include diary=?D?
_y_: ?y? year       _q_: quit           _L__l__c_: log = ?l?"
  ("SPC" org-agenda-reset-view)
  ("d" org-agenda-day-view (if (eq 'day (org-agenda-cts)) "[x]" "[ ]"))
  ("w" org-agenda-week-view (if (eq 'week (org-agenda-cts)) "[x]" "[ ]"))
  ("t" org-agenda-fortnight-view (if (eq 'fortnight (org-agenda-cts)) "[x]" "[ ]"))
  ("m" org-agenda-month-view (if (eq 'month (org-agenda-cts)) "[x]" "[ ]"))
  ("y" org-agenda-year-view (if (eq 'year (org-agenda-cts)) "[x]" "[ ]"))
  ("l" org-agenda-log-mode (format "% -3S" org-agenda-show-log))
  ("L" (org-agenda-log-mode '(4)))
  ("c" (org-agenda-log-mode 'clockcheck))
  ("f" org-agenda-follow-mode (format "% -3S" org-agenda-follow-mode))
  ("a" org-agenda-archives-mode)
  ("A" (org-agenda-archives-mode 'files))
  ("r" org-agenda-clockreport-mode (format "% -3S" org-agenda-clockreport-mode))
  ("e" org-agenda-entry-text-mode (format "% -3S" org-agenda-entry-text-mode))
  ("g" org-agenda-toggle-time-grid (format "% -3S" org-agenda-use-time-grid))
  ("D" org-agenda-toggle-diary (format "% -3S" org-agenda-include-diary))
  ("!" org-agenda-toggle-deadlines)
  ("[" (let ((org-agenda-include-inactive-timestamps t))
         (org-agenda-check-type t 'timeline 'agenda)
         (org-agenda-redo)
         (message "Display now includes inactive timestamps as well")))
  ("q" (message "Abort") :exit t)
  ("x" org-agenda-exit :exit t)
  ("v" nil))

(setq org-pomodoro-ask-upon-killing nil)

(defun ora-org-pomodoro ()
  (interactive)
  (if (eq major-mode 'org-agenda-mode)
      (progn
        (org-pomodoro)
        (org-save-all-org-buffers))
    (org-pomodoro)))

(require 'org-mu4e nil t)
(setq org-mu4e-link-query-in-headers-mode nil)

(defun ora-org-clock-heading ()
  (let ((str (nth 4 (org-heading-components))))
    (if (not (stringp str))
        (error "Not on a heading")
      (setq str (replace-regexp-in-string
                 "\\[\\[.*?\\]\\[\\(.*?\\)\\]\\]" "\\1"
                 (match-string-no-properties 4)))
      (mapconcat (lambda (s) (substring s 0 1))
                 (split-string str "[- ]+")
                 ""))))
(setq org-clock-heading-function #'ora-org-clock-heading)

(defun org-completion-refs ()
  (when (looking-back "\\\\\\(?:ref\\|label\\){\\([^\n{}]\\)*")
    (let (cands beg end)
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "\\label{\\([^}]+\\)}" nil t)
          (push (match-string-no-properties 1) cands)))
      (save-excursion
        (up-list)
        (setq end (1- (point)))
        (backward-list)
        (setq beg (1+ (point))))
      (list beg end
            (delete (buffer-substring-no-properties beg end)
                    (nreverse cands))))))
(provide 'ora-org)
