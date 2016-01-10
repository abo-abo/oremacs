;;* Navigation
;;;###autoload
(defun ora-para-down (arg)
  (interactive "p")
  (if (bolp)
      (progn
        (forward-paragraph arg)
        (forward-line 1))
    (line-move arg)))

;;;###autoload
(defun ora-para-up (arg)
  (interactive "p")
  (if (bolp)
      (progn
        (forward-line -1)
        (backward-paragraph arg)
        (forward-line 1))
    (line-move (- arg))))

;;;###autoload
(defun ora-move-beginning-of-line ()
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

(defun ora-backward-delete-whitespace ()
  (interactive)
  (save-match-data
    (let ((st (point))
          (en (progn
                (re-search-backward "[^ \t\r\n]+" nil t)
                (forward-char 1)
                (point))))
      (if (= st en)
          (progn
            (while (looking-back ")")
              (backward-char))
            (backward-kill-word 1))
        (delete-region st en)))))
;;* Regex
;;;###autoload
(defun ora-occur ()
  "Call `occur' with a sane default."
  (interactive)
  (push (ora-region-str-or-symbol) regexp-history)
  (call-interactively 'occur))

(defun ora-region-str-or-symbol ()
  "Return the contents of region or current symbol."
  (if (region-active-p)
      (buffer-substring-no-properties
       (region-beginning)
       (region-end))
    (let ((sym (thing-at-point 'symbol)))
      (when (stringp sym)
        (regexp-quote sym)))))

(defvar ora-qr-beg nil
  "Placeholder for query start.")

;;;###autoload
(defun ora-query-replace-regex (from)
  (interactive
   (list
    (read-regexp
     "Query replace"
     (let ((bounds (lispy--bounds-dwim)))
       (setq ora-qr-beg (car bounds))
       (when ora-qr-beg
         (kill-new
          (buffer-substring-no-properties
           ora-qr-beg
           (cdr bounds))))))))
  (when ora-qr-beg
    (goto-char ora-qr-beg)
    (setq ora-qr-beg))
  (deactivate-mark)
  (query-replace-regexp
   from
   (query-replace-read-to from "Query replace" nil)))

;;;###autoload
(defun ora-query-replace (from)
  (interactive
   (list
    (read-regexp
     "Query replace"
     (let ((bounds (lispy--bounds-dwim)))
       (setq ora-qr-beg (car bounds))
       (when ora-qr-beg
         (kill-new
          (buffer-substring-no-properties
           ora-qr-beg
           (cdr bounds))))))))
  (when ora-qr-beg
    (goto-char ora-qr-beg)
    (setq ora-qr-beg))
  (deactivate-mark)
  (query-replace
   from
   (query-replace-read-to from "Query replace" nil)))

;;;###autoload
(defun ora-replace-regexp (arg)
  "Works on current line if there's no region.
When ARG is non-nil launch `query-replace-regexp'."
  (interactive "P")
  (destructuring-bind (from to &rest)
      (query-replace-read-args "Replace regexp" nil)
    (if arg
        (query-replace-regexp from to)
      (let ((st (if (region-active-p)
                    (region-beginning)
                  (line-beginning-position)))
            (en (if (region-active-p)
                    (region-end)
                  (line-end-position))))
        (progn (goto-char st)
               (while (re-search-forward from en t)
                 (incf en (- (length to)
                             (length (match-string 0))))
                 (replace-match to)))))))

;;;###autoload
(defun og (string directory)
  "Search using ag in a given DIRECTORY for a given search STRING,
with STRING defaulting to the symbol under point.

If called with a prefix, prompts for flags to pass to ag."
  (interactive (list (read-from-minibuffer "Search string: ")
                     (read-directory-name "Directory: ")))
  (require 'ag)
  (ag/search string directory))

;;;###autoload
(defun ora-unfill-paragraph ()
  "Transform a paragraph into a single line."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil t)))

;;* Launchers
;;;###autoload
(defun ora-ctrltab ()
  "List buffers and give it focus."
  (interactive)
  (if (string= "*Buffer List*" (buffer-name))
      ;; Go to next line. Go to first line if end is reached.
      (progn
        (revert-buffer)
        (if (>= (line-number-at-pos)
                (count-lines (point-min) (point-max)))
            (goto-char (point-min))
          (forward-line)))
    (list-buffers)
    (switch-to-buffer "*Buffer List*")
    (delete-other-windows)
    (forward-line)))

;;;###autoload
(defun ora-terminal ()
  "Switch to terminal. Launch if nonexistent."
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash"))
  (get-buffer-process "*ansi-term*"))

;;;###autoload
(defun ora-goto-hook-file ()
  "Opens hooks.el at point specific to current `major-mode'"
  (interactive)
  (let* ((str-mode-hook (format "%s-hook" major-mode))
         (hook-fn-name
          (format "ora-%s-hook" (substring (symbol-name major-mode) 0 -5)))
         (hook-fn (intern-soft hook-fn-name)))
    (if hook-fn
        (ora-elisp-follow hook-fn-name)
      (find-file (concat emacs-d "oleh/hooks.el"))
      (goto-char (point-min))
      (search-forward str-mode-hook nil t))))

;;;###autoload
(defun ora-dired-rsync (dest)
  (interactive
   (list (expand-file-name
          (read-file-name "Rsync to:" (dired-dwim-target-directory)))))
  ;; store all selected files into "files" list
  (let ((files (dired-get-marked-files nil current-prefix-arg))
        ;; the rsync command
        (tmtxt/rsync-command "rsync -arvz --progress "))
    ;; add all selected file names as arguments to the rsync command
    (dolist (file files)
      (setq tmtxt/rsync-command
            (concat tmtxt/rsync-command
                    (shell-quote-argument file)
                    " ")))
    ;; append the destination
    (setq tmtxt/rsync-command
          (concat tmtxt/rsync-command
                  (shell-quote-argument dest)))
    ;; run the async shell command
    (async-shell-command tmtxt/rsync-command "*rsync*")
    ;; finally, switch to that window
    (other-window 1)))

;;;###autoload
(defun ora-describe-keys ()
  (interactive)
  (with-output-to-temp-buffer "*Bindings*"
    (dolist (letter-group (list
                           (cl-loop for c from ?a to ?z
                                    collect (string c))
                           (cl-loop for c from ?A to ?Z
                                    collect (string c))
                           (cl-loop for c from ?α to ?ω
                                    collect (string c))))
      (dolist (prefix '("" "C-" "M-" "C-M-"))
        (princ (mapconcat
                (lambda (letter)
                  (let ((key (concat prefix letter)))
                    (format ";; (global-set-key (kbd \"%s\") '%S)"
                            key
                            (key-binding (kbd key)))))
                letter-group
                "\n"))
        (princ "\n\n")))))

;;;###autoload
(defun illiterate ()
  "Useful to completely revert an `org-mode' file."
  (interactive)
  (let ((coding-system-for-read 'utf-8))
    (if (eq major-mode 'fundamental-mode)
        (revert-buffer nil t)
      (let ((pt (1+ (length
                     (encode-coding-string
                      (buffer-substring-no-properties (point-min) (point))
                      'utf-8))))
            (file-name (buffer-file-name)))
        (kill-buffer (current-buffer))
        (find-file-literally file-name)
        (goto-char pt)))))

;;;###autoload
(defun melpa ()
  (interactive)
  (let ((package-archives
         '(("melpa" . "http://melpa.milkbox.net/packages/"))))
    (package-list-packages)))

;;;###autoload
(defun ora-test-emacs ()
  (interactive)
  (require 'async)
  (async-start
   (lambda () (shell-command-to-string
               "emacs --batch --eval \"
(condition-case e
    (progn
      (load \\\"~/.emacs\\\")
      (message \\\"-OK-\\\"))
  (error
   (message \\\"ERROR!\\\")
   (signal (car e) (cdr e))))\""))
   `(lambda (output)
      (if (string-match "-OK-" output)
          (when ,(called-interactively-p 'any)
            (message "All is well"))
        (switch-to-buffer-other-window "*startup error*")
        (delete-region (point-min) (point-max))
        (insert output)
        (search-backward "ERROR!")))))

;;;###autoload
(defun ora-figlet-region (&optional b e)
  (interactive "r")
  (shell-command-on-region b e "toilet" (current-buffer) t))

;;;###autoload
(defun ora-reinit-semantic ()
  (interactive)
  (goto-char (point-min))
  (search-forward "(defconst semantic-c-by--keyword-table")
  (eval-defun nil)
  (search-forward "(defconst semantic-c-by--token-table")
  (eval-defun nil)
  (search-forward "(defconst semantic-c-by--parse-table")
  (eval-defun nil))

;;;###autoload
(defun ora-nw-yank ()
  (interactive)
  (shell-command-on-region (point) (point) "xsel" (current-buffer) t))

;;;###autoload
(defun ora-install-gcl ()
  (interactive)
  (shell-command
   (format "cd \"%setc/\" && wget http://gnu.xl-mirror.nl/gcl/gcl.info.tgz && tar xzf gcl.info.tgz && rm -f gcl.info.tgz"
           emacs-d)))

;;* Bookmarks
;;;###autoload
(defun bmk/magit-status ()
  "Bookmark for `magit-status'."
  (interactive)
  (when (buffer-file-name)
    (delete-trailing-whitespace)
    (save-buffer))
  (call-interactively 'magit-status)
  ;; (magit-status nil)
  )

;;;###autoload
(defun bmk/scratch ()
  "Bookmark for *scratch*."
  (interactive)
  (switch-to-buffer
   (get-buffer-create "*scratch*")))

;;;###autoload
(defun bmk/function (bookmark)
  "Handle a function bookmark BOOKMARK."
  (funcall (bookmark-prop-get bookmark 'function)))

(defun ora-bookmark+-to-bookmark ()
  "Strip bookmark+-specific properties."
  (setq bookmark-alist
        (mapcar
         (lambda (x)
           (delq nil
                 (list
                  (substring-no-properties (car x))
                  (assoc 'filename x)
                  (assoc 'front-context-string x)
                  (assoc 'rear-context-string x)
                  (assoc 'position x)
                  (assoc 'function x)
                  (assoc 'handler x))))
         bookmark-alist)))

;;* Utility
;;;###autoload
(defun ora-eval-other-window (arg123)
  "Eval current expression in the context of other window.
Expression has to be of type (setq X BODY)
In case 'setq isn't present, add it."
  (interactive "P")
  (lexical-let ((sexp (save-match-data
                        (lispy--setq-expression))))
    (when arg123
      (setq sexp `(progn ,sexp "OK")))
    (other-window 1)
    (eval-expression sexp)
    (other-window -1)))

;;;###autoload
(defun ora-describe-hash (variable &optional buffer)
  "Display the full documentation of VARIABLE (a symbol).
Returns the documentation as a string, also.
If VARIABLE has a buffer-local value in BUFFER (default to the current buffer),
it is displayed along with the global value."
  (interactive
   (let ((v (variable-at-point))
         (enable-recursive-minibuffers t)
         val)
     (setq val (completing-read
                (if (and (symbolp v)
                         (hash-table-p (symbol-value v)))
                    (format
                     "Describe hash-map (default %s): " v)
                  "Describe hash-map: ")
                obarray
                (lambda (atom) (and (boundp atom)
                                    (hash-table-p (symbol-value atom))))
                t nil nil
                (if (hash-table-p v) (symbol-name v))))
     (list (if (equal val "")
               v (intern val)))))
  (with-output-to-temp-buffer (help-buffer)
    (maphash (lambda (key value)
               (pp key)
               (princ " => ")
               (pp value)
               (terpri))
             (symbol-value variable))))

;;;###autoload
(defun ora-toggle-window-dedicated ()
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p
          window
          (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))

;;;###autoload
(defun update-all-autoloads ()
  (interactive)
  (cd emacs-d)
  (let ((generated-autoload-file
         (expand-file-name "loaddefs.el")))
    (when (not (file-exists-p generated-autoload-file))
      (with-current-buffer (find-file-noselect generated-autoload-file)
        (insert ";;") ;; create the file with non-zero size to appease autoload
        (save-buffer)))
    (mapcar #'update-directory-autoloads
            '("" "oleh" "oleh/modes" "git/org-fu"))))

;;;###autoload
(defun align-cols (start end max-cols)
  "Align text between point and mark as columns.
Columns are separated by whitespace characters.
Prefix arg means align that many columns. (default is all)"
  (interactive "r\nP")
  (save-excursion
    (let ((p start)
          pos
          end-of-line
          word
          count
          (max-cols (if (numberp max-cols) (max 0 (1- max-cols)) nil))
          (pos-list nil)
          (ref-list nil))
      ;; find the positions
      (goto-char start)
      (while (< p end)
        (beginning-of-line)
        (setq count 0)
        (setq end-of-line (save-excursion (end-of-line) (point)))
        (re-search-forward "^\\s-*" end-of-line t)
        (setq pos (current-column))     ;start of first word
        (if (null (car ref-list))
            (setq pos-list (list pos))
          (setq pos-list (list (max pos (car ref-list))))
          (setq ref-list (cdr ref-list)))
        (while (and (if max-cols (< count max-cols) t)
                    (re-search-forward "\\s-+" end-of-line t))
          (setq count (1+ count))
          (setq word (- (current-column) pos))
          ;; length of next word including following whitespaces
          (setq pos (current-column))
          (if (null (car ref-list))
              (setq pos-list (cons word pos-list))
            (setq pos-list (cons (max word (car ref-list)) pos-list))
            (setq ref-list (cdr ref-list))))
        (while ref-list
          (setq pos-list (cons (car ref-list) pos-list))
          (setq ref-list (cdr ref-list)))
        (setq ref-list (nreverse pos-list))
        (forward-line)
        (setq p (point)))
      ;; aling the cols starting with last row
      (setq pos-list (copy-sequence ref-list))
      (setq start
            (save-excursion (goto-char start) (beginning-of-line) (point)))
      (goto-char end)
      (beginning-of-line)
      (while (>= p start)
        (beginning-of-line)
        (setq count 0)
        (setq end-of-line (save-excursion (end-of-line) (point)))
        (re-search-forward "^\\s-*" end-of-line t)
        (goto-char (match-end 0))
        (setq pos (nth count pos-list))
        (while (< (current-column) pos)
          (insert-char ?\040 1))
        (setq end-of-line (save-excursion (end-of-line) (point)))
        (while (and (if max-cols (< count max-cols) t)
                    (re-search-forward "\\s-+" end-of-line t))
          (setq count (1+ count))
          (setq pos (+ pos (nth count pos-list)))
          (goto-char (match-end 0))
          (while (< (current-column) pos)
            (insert-char ?\040 1))
          (setq end-of-line (save-excursion (end-of-line) (point))))
        (forward-line -1)
        (if (= p (point-min)) (setq p (1- p))
          (setq p (point)))))))

;;;###autoload
(defun ora-comment-and-insert ()
  (interactive)
  (lispy-mark)
  (let ((str (buffer-substring-no-properties
              (region-beginning)
              (region-end))))
    (comment-dwim nil)
    (newline-and-indent)
    (insert str)))

;;;###autoload
(defun ora-dired-org-to-pdf ()
  (interactive)
  (let ((files
         (if (eq major-mode 'dired-mode)
             (dired-get-marked-files)
           (let ((default-directory (read-directory-name "dir: ")))
             (mapcar #'expand-file-name
                     (file-expand-wildcards "*.org"))))))
    (mapc
     (lambda (f)
       (with-current-buffer
           (find-file-noselect f)
         (org-latex-export-to-pdf)))
     files)))

;;;###autoload
(defun wmctrl-720p ()
  (interactive)
  (shell-command "
wmctrl -r \"emacs@firefly\" -b remove,maximized_vert;
wmctrl -r \"emacs@firefly\" -b remove,maximized_horz;
wmctrl -r \"emacs@firefly\" -e \"1,0,0,1280,720\""))

;;;###autoload
(defun ora-kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

;;;###autoload
(defun ora-save-and-switch-buffer (&optional arg)
  (interactive "P")
  (when (and (buffer-file-name)
             (not (bound-and-true-p archive-subfile-mode))
             (not buffer-read-only))
    (save-buffer))
  (if arg
      (let ((current-prefix-arg 4))
        (call-interactively #'magit-status))
    (ivy-switch-buffer)))

;;;###autoload
(defun youtube-dl ()
  (interactive)
  (let* ((str (current-kill 0))
         (default-directory "~/Downloads")
         (proc (get-buffer-process (ansi-term "/bin/bash"))))
    (term-send-string
     proc
     (concat "cd ~/Downloads && youtube-dl " str "\n"))))

;;;###autoload
(defun ora-directory-parent (dir)
  "Return parent of directory DIR."
  (unless (equal "/" dir)
    (file-name-directory (directory-file-name dir))))

(defvar ora-pretty-alist
  `(("rangle" . ?\⟩)
    ,@(cl-pairlis '("alpha" "beta" "gamma" "delta" "epsilon" "zeta" "eta"
                    "theta" "iota" "kappa" "lambda" "mu" "nu" "xi"
                    "omicron" "pi" "rho" "sigma_final" "sigma" "tau"
                    "upsilon" "phi" "chi" "psi" "omega")
                  (mapcar
                   (lambda (x) (make-char 'greek-iso8859-7 x))
                   (number-sequence 97 121)))))

;;;###autoload
(defun ora-pretty-things ()
  "Compose chars according to `ora-pretty-alist'."
  (mapc
   (lambda (x)
     (let ((word (car x))
           (char (cdr x)))
       (font-lock-add-keywords
        nil
        `((,(concat "\\(^\\|[^a-zA-Z0-9]\\)\\(" word "\\)[a-zA-Z]")
            (0 (progn
                 (decompose-region
                  (match-beginning 2)
                  (match-end 2))
                 nil)))))
       (font-lock-add-keywords
        nil
        `((,(concat "\\(^\\|[^a-zA-Z0-9]\\)\\(" word "\\)[^a-zA-Z]")
            (0 (progn
                 (compose-region
                  (1- (match-beginning 2))
                  (match-end 2)
                  ,char)
                 nil)))))))
   ora-pretty-alist))

;;;###autoload
(defun ora-fontify-glyph (item glyph)
  `((,item
     (0 font-lock-keyword-face t)
     (0 (prog1
            (compose-region (match-beginning 0)
                            (match-end 0)
                            ,glyph) nil)))))

;;;###autoload
(defun ora-elisp-follow (name)
  "Jump to the definition of the function (or variable) at point."
  (interactive (list (thing-at-point 'symbol)))
  (cond (name
         (let ((symbol (intern-soft name))
               (search (lambda (fun sym)
                         (let* ((r (save-excursion (funcall fun sym)))
                                (buffer (car r))
                                (point (cdr r)))
                           (cond ((not point)
                                  (error "Found no definition for %s in %s"
                                         name buffer))
                                 (t
                                  (switch-to-buffer buffer)
                                  (goto-char point)
                                  (recenter 1)))))))
           (ring-insert find-tag-marker-ring (point-marker))
           (cond ((fboundp symbol)
                  (push-mark)
                  (funcall search 'find-function-noselect symbol))
                 ((boundp symbol)
                  (push-mark)
                  (funcall search 'find-variable-noselect symbol))
                 ((or (featurep symbol) (locate-library symbol))
                  (push-mark)
                  (find-library name))
                 (t
                  (error "Symbol not bound: %S" symbol)))))
        (t (message "No symbol at point"))))

(defun char-upcasep (letter)
  (eq letter (upcase letter)))

;;;###autoload
(defun capitalize-word-toggle ()
  (interactive)
  (let ((start
         (car
          (save-excursion
            (backward-word)
            (bounds-of-thing-at-point 'symbol)))))
    (if start
        (save-excursion
          (goto-char start)
          (funcall
           (if (char-upcasep (char-after))
               'downcase-region
             'upcase-region)
           start (1+ start)))
      (capitalize-word -1))))

;;;###autoload
(defun upcase-word-toggle ()
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'symbol))
        (regionp
         (if (eq this-command last-command)
             (get this-command 'regionp)
           (put this-command 'regionp nil)))
        beg end)
    (cond
      ((or (region-active-p) regionp)
       (setq beg (region-beginning)
             end (region-end))
       (put this-command 'regionp t))
      (bounds
       (setq beg (car bounds)
             end (cdr bounds)))
      (t
       (setq beg (point)
             end (1+ beg))))
    (save-excursion
      (goto-char (1- beg))
      (and (re-search-forward "[A-Za-z]" end t)
           (funcall (if (char-upcasep (char-before))
                        'downcase-region
                      'upcase-region)
                    beg end)))))

;;;###autoload
(defun named-term (name)
  (interactive "sName: ")
  (ansi-term "/bin/bash" name))

;;;###autoload
(defun jekyll-serve ()
  (interactive)
  (let* ((default-directory
          (if (string-match "_posts/$" default-directory)
              (ora-directory-parent default-directory)
            default-directory))
         (buffer (if (get-buffer "*jekyll*")
                     (switch-to-buffer "*jekyll*")
                   (ansi-term "/bin/bash" "jekyll")))
         (proc (get-buffer-process buffer)))
    (term-send-string proc "jekyll serve --limit_posts 1\n")
    (sit-for 3)
    (browse-url "localhost:4000")))

;;;###autoload
(defun sudired ()
  (interactive)
  (require 'tramp)
  (let ((dir (expand-file-name default-directory)))
    (if (string-match "^/sudo:" dir)
        (user-error "Already in sudo")
      (dired (concat "/sudo::" dir)))))

;;;###autoload
(defun ora-insert-date (date)
  "Insert DATE using the current locale."
  (interactive (list (calendar-read-date)))
  (insert (calendar-date-string date)))

;;;###autoload
(defun ora-insert-date-from (&optional days)
  "Insert date that is DAYS from current."
  (interactive "p")
  (message "%d" days)
  (when (eq days 1)
    (setq days 0))
  (insert
   (calendar-date-string
    (calendar-gregorian-from-absolute
     (+ (calendar-absolute-from-gregorian (calendar-current-date))
        days)))))

;;;###autoload
(defun ora-set-transparency (alpha-level)
  (interactive "p")
  (message (format "Alpha level passed in: %s" alpha-level))
  (let ((alpha-level (if (< alpha-level 2)
                         (read-number "Opacity percentage: " 85)
                       alpha-level))
        (myalpha (frame-parameter nil 'alpha)))
    (set-frame-parameter nil 'alpha alpha-level))
  (message (format "Alpha level is %d" (frame-parameter nil 'alpha))))

;;;###autoload
(defun ora-hide-ctrl-M ()
  "Hides the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;;;###autoload
(defun ora-lookup-key (key)
  (let ((minors
         (cl-remove-if-not
          #'functionp
          (mapcar (lambda (map) (lookup-key map key))
                  (current-minor-mode-maps))))
        (local (lookup-key (current-local-map) key))
        (global (lookup-key (current-global-map) key)))
    (delq nil
          (list minors
                (and (functionp local) major-mode)
                (and (functionp global) 'global)))))

;;;###autoload
(defun ora-pretty-quote-glyphs ()
  (let ((tbl (make-display-table)))
    (aset tbl 8220 (vector (make-glyph-code ?\" 'default)))
    (aset tbl 8221 (vector (make-glyph-code ?\" 'default)))
    (aset tbl 8216 (vector (make-glyph-code ?\` 'default)))
    (aset tbl 8217 (vector (make-glyph-code ?\' 'default)))
    (setq standard-display-table tbl)))

;;* Advices
;;;###autoload
(defadvice kill-compilation (after ora-disable-compiling-message activate)
  (setq compilation-in-progress nil))

;; (defadvice raise-frame (after ora-fix-raise-frame (&optional frame) activate)
;;   "Work around some bug? in raise-frame/Emacs/GTK/Metacity/something.
;; Katsumi Yamaoka posted this in
;; http://article.gmane.org/gmane.emacs.devel:39702"
;;   (call-process
;;    "wmctrl" nil nil nil "-i" "-R"
;;    (frame-parameter (or frame (selected-frame)) 'outer-window-id)))

;;;###autoload
(defun ora-custom-setq ()
  "Set a custom variable, with completion."
  (interactive)
  (let ((sym (intern
              (ivy-read "Variable: "
                        (counsel-variable-list))))
        sym-type
        cands)
    (when (and (boundp sym)
               (setq sym-type (get sym 'custom-type)))
      (cond
        ((and (consp sym-type)
              (memq (car sym-type) '(choice radio)))
         (setq cands (mapcar #'lispy--setq-doconst (cdr sym-type))))
        ((eq sym-type 'boolean)
         (setq cands
               '(("nil" . nil) ("t" . t))))
        (t
         (error "Unrecognized custom type")))
      (let ((res (ivy-read (format "Set (%S): " sym) cands)))
        (when res
          (setq res
                (if (assoc res cands)
                    (cdr (assoc res cands))
                  (read res)))
          (eval `(setq ,sym ,res)))))))
