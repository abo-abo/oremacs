;;* Requires
(require 'pora-org nil t)
(use-package async)
(require 'ora-org-babel)
(require 'ora-org-roam)
(require 'ora-org-journal)
(require 'ora-org-pomodoro)
(setq org-export-backends '(html latex))
(setq org-export-with-sub-superscripts nil)
(setq org-catch-invisible-edits 'smart)
(setq org-fontify-done-headline nil)
(require 'org)
(add-to-list 'load-path (expand-file-name "git/org-mode/contrib/lisp/" emacs-d))
(require 'org-src)
(use-package alert
  :defer t)

(use-package worf
  :config
  (setq worf-visit-function
        (defun ora-worf-visit-function (file)
          (let ((ext (file-name-extension file)))
            (if (string= ext "pdf")
                (counsel-locate-action-extern file)
              (find-file file))))))

(use-package org-download
  :config
  (org-download-enable)
  (setq org-download-display-inline-images t)
  (setq org-download-method 'attach))

(use-package orca)

(use-package org-bullets
  :config
  (setcdr org-bullets-bullet-map nil))

(setq org-reveal-hlevel 2)
(setq org-attach-file-list-property nil)
(setq org-attach-use-inheritance t)
(setq org-hide-emphasis-markers t)
(put 'org-hide-emphasis-markers 'safe-local-variable 'identity)

;;;###autoload
(defun ora-org-hook ()
  (worf-mode)
  (org-bullets-mode)
  (org-indent-mode)
  (setq fill-column 90)
  (auto-fill-mode)
  (add-to-list 'prettify-symbols-alist
               '(":PROPERTIES:" . ":"))
  (prettify-symbols-mode)
  (when (file-equal-p default-directory org-roam-directory)
    (when (string-match-p "[а-я]" (buffer-string))
      (ispell-change-dictionary "en_US,uk_UA"))
    (wucuo-start))
  (ora-org-hide-archive-heading)
  (setq-local tab-always-indent 'complete))

(defun ora-org-hide-archive-heading ()
  (save-excursion
    (when (progn
            (goto-char (point-min))
            (search-forward "* Archive" nil t))
      (outline-flag-subtree t))))

(setq org-agenda-max-entries nil)
;; Hide tasks that are scheduled in the future.
(setq org-agenda-todo-ignore-scheduled 'future)
(setq org-agenda-todo-ignore-time-comparison-use-seconds t)
;; Hide the deadline prewarning prior to scheduled date.
(setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)

;; (setq org-agenda-skip-scheduled-if-deadline-is-shown t)
;; (setq org-agenda-skip-timestamp-if-deadline-is-shown t)
;; (setq org-agenda-skip-additional-timestamps-same-entry t)

(setq org-agenda-todo-ignore-with-date t)

;;;###autoload
(defun ora-org-agenda-hook ())

;;* Keys
;;** org-mode-map
(define-key org-mode-map (kbd "C-,") nil)
(define-key org-mode-map (kbd "C-'") nil)
(define-key org-mode-map (kbd "C-TAB") nil)
(define-key org-mode-map (kbd "C-M-i") 'ora-org-complete-symbol)
(define-key org-mode-map (kbd "C-m") 'newline)
(define-key org-mode-map (kbd "C-c C-r") nil)
(define-key org-mode-map [C-tab] nil)
(define-key org-mode-map (kbd "<f2> a") 'org-archive)
(define-key org-mode-map (kbd "χ") 'worf-back-to-heading)
(define-key org-mode-map (kbd "C-σ") 'org-edit-special)
(define-key org-mode-map (kbd "C-a") 'ora-move-beginning-of-line)
(define-key org-mode-map (kbd "M-r") 'org-ctrl-c-ctrl-c)
(define-key org-src-mode-map (kbd "C-c C-c") nil)
(define-key org-src-mode-map (kbd "C-σ") 'org-edit-src-exit)
(ora-advice-add 'org-edit-src-exit :after (lambda (&rest _) (save-buffer)))
(define-key org-mode-map (kbd "C-c C-v") nil)
(define-key org-mode-map (kbd "C-c C-q") 'counsel-org-tag)
(define-key org-agenda-mode-map (kbd "<backspace>") 'ora-org-agenda-unmark-backward)

(defun ora-org-agenda-unmark-backward ()
  (interactive)
  (forward-line -1)
  (org-agenda-bulk-unmark)
  (forward-line -1))

;;** org-agenda-mode-map
(require 'org-agenda)

(let ((map org-agenda-mode-map))
  ;; unbind
  (define-key map "a" 'worf-reserved)
  (define-key map "b" 'worf-reserved)
  (define-key map "c" 'worf-reserved)
  (define-key map "d" 'org-agenda-goto-date)
  (define-key map "e" 'worf-reserved)
  (define-key map "f" 'worf-reserved)
  (define-key map "n" 'worf-reserved)
  (define-key map "o" 'org-agenda-show)
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
  (define-key map (kbd "C-j") 'org-open-at-point)
  (define-key map "i" 'org-agenda-clock-in)
  (define-key map "O" 'org-agenda-clock-out)
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
              '((sequence
                 "TODO" "NEXT" "PROG"
                 "WAIT" "LIST"
                 "|" "DONE" "DROP(r)")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("NEXT" . (:foreground "red" :weight bold))
        ("PROG" . (:foreground "red" :weight bold))
        ("WAIT" . (:foreground "blue" :weight bold))
        ("LIST" . (:foreground "orange" :weight bold))))
(setq org-startup-indented t)
(setq org-startup-folded nil)
(setq org-cycle-separator-lines 0)

(setq org-return-follows-link t)
(setq org-link-search-must-match-exact-headline nil)
;; open links in the same window
(setf (cdr (assq 'file org-link-frame-setup)) 'find-file)

(setq org-bookmark-names-plist
      '(:last-capture "jc: org-last-capture"
        :last-refile "jr: org-last-refile"))
(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))
(setq-default org-tags-column -96)
(setq org-completion-use-ido t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-string-limit 30)
(setq org-clock-sound "/usr/local/share/tngchime.wav")
(setq org-latex-create-formula-image-program 'dvipng)
(plist-put org-format-latex-options :scale 1.5)
(setq org-image-actual-width 300)

;;* Interactions
(setq org-file-apps
      '((auto-mode . emacs)
        (directory . emacs)
        ("\\.x?html?\\'" . "firefox %s")
        ("\\.pdf\\'" . "evince \"%s\"")
        ("\\.gif\\'" . "eog \"%s\"")
        ("\\.pdf::\\([0-9]+\\)\\'" . "evince \"%s\" -p %1")
        ("\\.mp4\\'" . "vlc \"%s\"")
        ("\\.mkv" . "vlc \"%s\"")))
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
(setq org-edit-src-content-indentation 0)

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
(setq org-latex-inputenc-alist '(("utf8" . "utf8x")))
(setq org-latex-default-packages-alist
      '(("AUTO" "inputenc" t ("pdflatex"))
        ("T1" "fontenc" t ("pdflatex"))
        ("" "graphicx" t)
        ("" "grffile" t)
        ("" "longtable" nil)
        ("" "wrapfig" nil)
        ("" "rotating" nil)
        ("normalem" "ulem" t)
        ("" "amsmath" t)
        ("" "textcomp" t)
        ("" "amssymb" t)
        ("" "capt-of" nil)
        ("hidelinks" "hyperref" nil)))

;;* Files
(setq org-archive-location (expand-file-name
                            "../archive/gtd.org_archive::"
                            plain-org-wiki-directory))

;;* Source blocks
(require 'htmlfontify)
(setq org-src-fontify-natively t)

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

(defvar ora-org-structure-template-alist
  '(("s" "#+begin_src ?\n\n#+end_src")
    ("e" "#+begin_example\n?\n#+end_example")
    ("q" "#+begin_quote\n?\n#+end_quote")
    ("v" "#+begin_verse\n?\n#+end_verse")
    ("V" "#+begin_verbatim\n?\n#+end_verbatim")
    ("c" "#+begin_center\n?\n#+end_center")
    ("C" "#+begin_comment\n?\n#+end_comment")
    ("l" "#+begin_export latex\n?\n#+end_export")
    ("L" "#+latex: ")
    ("h" "#+begin_export html\n?\n#+end_export")
    ("H" "#+html: ")
    ("a" "#+begin_export ascii\n?\n#+end_export")
    ("A" "#+ascii: ")
    ("i" "#+index: ?")
    ("I" "#+include: %file ?")))

(defun hot-expand (str)
  "Expand org template."
  (let ((beg (point))
        (expansion (cadr (assoc str ora-org-structure-template-alist))))
    (insert expansion)
    (when (re-search-backward "\\?" beg t)
      (delete-char 1))))

(defun org-insert-env (env)
  (insert "\\begin{" env "}\n")
  (save-excursion
    (insert "\n\\end{" env "}")))

(defhydra hydra-org-template (:color blue :hint nil)
  "
_c_enter  _q_uote    _L_aTeX:
_l_atex   _e_xample  _i_ndex:
_a_scii   _v_erse    _I_NCLUDE:
_s_rc     eq_u_ation _H_TML:
_h_tml    ^ ^        _A_SCII:
"
  ("s" (hot-expand "s"))
  ("e" (hot-expand "e"))
  ("q" (hot-expand "q"))
  ("v" (hot-expand "v"))
  ("c" (hot-expand "c"))
  ("l" (hot-expand "l"))
  ("h" (hot-expand "h"))
  ("a" (hot-expand "a"))
  ("L" (hot-expand "L"))
  ("i" (hot-expand "i"))
  ("I" (hot-expand "I"))
  ("H" (hot-expand "H"))
  ("A" (hot-expand "A"))
  ("t" (hot-expand "t"))
  ("u" (org-insert-env "equation"))
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
  ("c" hydra-org-clock/body "clock")
  ("a" ora-org-add-to-agenda "add to agenda")
  ("p" org-pomodoro "pomodoro"))

(defun ora-org-add-to-agenda ()
  (interactive)
  (when (and (buffer-file-name)
             (not (member (buffer-file-name)
                          (mapcar #'expand-file-name org-agenda-files))))
    (add-to-list 'org-agenda-files (buffer-file-name))))

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
  ("D" org-agenda-day-view (if (eq 'day (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("d" (org-agenda nil "d") (if (eq 'day (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("w" (org-agenda nil "w") (if (eq 'week (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("t" org-agenda-fortnight-view (if (eq 'fortnight (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("m" org-agenda-month-view (if (eq 'month (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("y" org-agenda-year-view (if (eq 'year (org-agenda-cts)) "[x]" "[ ]") :exit t)
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

(setq org-clock-idle-time 60)

(defun ora-org-clock-heading ()
  (let ((str (nth 4 (org-heading-components))))
    (if (not (stringp str))
        (error "Not on a heading")
      (setq str (replace-regexp-in-string
                 "\\[\\[.*?\\]\\[\\(.*?\\)\\]\\]" "\\1"
                 (match-string-no-properties 4)))
      (mapconcat (lambda (s) (substring s 0 (min (length s) 2)))
                 (split-string str "[- =]+")
                 "-"))))
(setq org-clock-heading-function #'ora-org-clock-heading)

(add-to-list 'safe-local-variable-values
             '(org-todo-keywords (sequence "TODO" "REVIEW" "|" "DONE")))
(add-to-list 'safe-local-variable-values
             '(org-log-done))
(add-to-list 'safe-local-variable-values
             '(org-todo-key-alist
               (:startgroup)
               ("TODO" . 116)
               ("REVIEW" . 114)
               ("DONE" . 100)
               (:endgroup)))
(put 'python-shell-interpreter 'safe-local-variable 'identity)
(put 'org-archive-location 'safe-local-variable 'identity)
(add-to-list 'safe-local-variable-values
             '(lisp-indent-function . lisp-indent-function))

(csetq org-agenda-window-setup 'current-window)

;;** insert snippets
(use-package org-parser)

(defvar ora-snippet-alist
  '((sh-mode . "~/Dropbox/org/wiki/bash.org")))

(defun ora-insert-snippet-action (x)
  (let ((body (cdr x)))
    (if (string-match "\\`#\\+begin_src.*\n\\([^\0]+\\)#\\+end_src\\'" body)
        (insert (match-string 1 body))
      (error "Unexpected snippet: %s" body)))
  (message x))

(defun ora-insert-snippet ()
  (interactive)
  (let ((file (cdr (assoc major-mode ora-snippet-alist))))
    (if (not (file-exists-p file))
        (error "No snippets for `%S'" major-mode)
      (let* ((parse-tree (org-parser-parse-file file))
             (snippet-heading
              (cl-find-if (lambda (x) (equal '("Snippets") (gethash :text x)))
                          parse-tree))
             (snippets
              (gethash :children snippet-heading))
             (snippet-names-bodies
              (mapcar (lambda (x)
                        (cons
                         (car (gethash :text x))
                         (caar (gethash :body x))))
                      snippets)))
        (ivy-read "snippet: " snippet-names-bodies
                  :action 'ora-insert-snippet-action)))))

(defun ora-org-complete-symbol ()
  (interactive)
  (let* ((element (save-excursion (beginning-of-line) (org-element-at-point)))
         (type (org-element-type element)))
    (if (and (eq type 'src-block)
             (> (line-beginning-position)
                (org-element-property :post-affiliated element))
             (< (line-beginning-position)
                (org-with-wide-buffer
                 (goto-char (org-element-property :end element))
                 (skip-chars-backward " \r\t\n")
                 (line-beginning-position))))
        (org-babel-do-key-sequence-in-edit-buffer (kbd "TAB"))
      (completion-at-point))))

(defun ora-git-refile ()
  (interactive)
  (let* ((default-directory "~/Dropbox/org")
         (ivy-inhibit-action t)
         (fname (counsel-git "org$"))
         (org-agenda-files nil)
         (org-refile-use-cache nil)
         (org-refile-targets `(((,fname) :maxlevel . 3))))
    (org-refile)))

(defun ora-org-grep (s)
  (let ((default-directory emacs-d))
    (counsel-rg s)))

(let ((inhibit-message t))
  (org-add-link-type "grep" 'ora-org-grep))

(defun ora-org-done-p ()
  (save-excursion
    (org-back-to-heading)
    (looking-at "\\*+ \\(DONE\\|CANCELLED\\)")))

(defun ora-org-delete-element (&optional context)
  (setq context (or context (org-element-context)))
  (delete-region
   (org-element-property :begin context)
   (1+ (org-element-property :end context))))

(defun ora-org-cleanup-links ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^\\[\\[" nil t)
      (let* ((context (org-element-context))
             (type (org-element-property :type context))
             (path (org-link-unescape (org-element-property :path context))))
        (when (string= type "file")
          (when (or (not (file-exists-p path))
                    (ora-org-done-p))
            (delete-file path)
            (ora-org-delete-element)))))
    (save-buffer)))

(setq org-link-abbrev-alist
      '(("google" . "http://www.google.com/search?q=")
        ("gmap" . "http://maps.google.com/maps?q=%s")
        ("omap" . "http://nominatim.openstreetmap.org/search?q=%s&polygon=1")))

(defun ora-org-to-html-to-clipboard ()
  "Export region to HTML, and copy it to the clipboard."
  (interactive)
  (let ((org-html-xml-declaration nil)
        (org-html-postamble nil)
        (org-html-preamble nil))
    (org-export-to-file 'html "/tmp/org.html"))
  (apply
   'start-process "xclip" "*xclip*"
   (split-string
    "xclip -verbose -i /tmp/org.html -t text/html -selection clipboard" " ")))

(provide 'ora-org)
