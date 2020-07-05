;;* Navigation
;;;###autoload
(defun ora-move-beginning-of-line ()
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

;;;###autoload
(defun ora-open-file-at-point (event)
  (interactive "e")
  (posn-set-point (event-end event))
  (require 'ffap)
  (let ((f (ffap-guesser))
        (w (cl-find-if (lambda (w)
                         (with-current-buffer (window-buffer w)
                           (eq major-mode 'image-mode)))
                       (window-list)))
        b)
    (when f
      (if (string-match-p "^http" f)
          (browse-url f)
        (setq b (find-file-noselect (expand-file-name f)))
        (if w
            (progn
              (select-window w)
              (switch-to-buffer b))
          (pop-to-buffer b))))))

(defun ora-thing-at-point ()
  (if (region-active-p)
      (buffer-substring-no-properties
       (region-beginning)
       (region-end))
    (substring-no-properties
     (thing-at-point 'word))))

;;;###autoload
(defun ora-open-wikipedia ()
  (interactive)
  (browse-url
   (format "https://wikipedia.org/wiki/%s"
           (ora-thing-at-point))))

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

;;;###autoload
(defun ora-c-forward-sexp-function (arg)
  (if (looking-at "^#")
      (forward-ifdef arg)
    (let ((forward-sexp-function nil))
      (forward-sexp arg)
      (while (looking-at "[.-]")
        (forward-sexp)))
    (when (and (eq (char-after) ?.)
               (looking-back "[0-9]+" (line-beginning-position)))
      (forward-char)
      (skip-chars-forward "0-9"))))

(defun ora-dirs-in (dir)
  "Return the list of directories in DIR."
  (delq nil
        (mapcar
         (lambda (x)
           (let (y)
             (when (file-directory-p
                    (setq y (expand-file-name x dir)))
               (cons x y))))
         (cl-set-difference
          (directory-files dir)
          '("." "..")
          :test #'equal))))

;;;###autoload
(defun ora-project ()
  (interactive)
  (ivy-read
   "Project: "
   (delete-dups
    (append
     (ora-dirs-in (expand-file-name "git/" emacs-d))
     (ora-dirs-in "~/git/")))
   :action (lambda (x) (find-file (cdr x)))))

;;* Regex
(defun re-seq (regexp string)
  "Return a list of matches to REGEXP in STRING."
  (save-match-data
    (let ((start 0)
          res)
      (while (string-match regexp string start)
        (push (let ((n-matches (/ (length (match-data)) 2)))
                (mapcar (lambda (i)
                          (match-string i string))
                        (number-sequence 0 (1- n-matches))))
              res)
        (setq start (match-end 0)))
      (nreverse res))))

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
        (delete-other-windows)
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
(defun ora-goto-hook-file ()
  "Opens hooks.el at point specific to current `major-mode'"
  (interactive)
  (let* ((str-mode-hook (format "%s-hook" major-mode))
         (hook-fn-name
          (format "ora-%s-hook" (substring (symbol-name major-mode) 0 -5)))
         (hook-fn (intern-soft hook-fn-name)))
    (if hook-fn
        (ora-elisp-follow hook-fn-name)
      (find-file (concat emacs-d "hooks.el"))
      (goto-char (point-min))
      (search-forward str-mode-hook nil t))))

(defcustom ora-dired-rsync-limit nil
  "Limit rsync transfer rate."
  :type
  '(choice
    (const :tag "None" nil)
    (integer :tag "500kbps" 500)))

;;;###autoload
(defun ora-dired-rsync (dest)
  (interactive
   (list (expand-file-name
          (read-file-name "Rsync to:" (dired-dwim-target-directory)))))
  ;; store all selected files into "files" list
  (let ((files (dired-get-marked-files nil current-prefix-arg))
        (rsync-command
         (concat
          "rsync"
          (if ora-dired-rsync-limit
              (format " --bwlimit=%s" ora-dired-rsync-limit)
            "")
          " -arvzu --delete --progress ")))
    ;; add all selected file names as arguments to the rsync command
    (dolist (file files)
      (setq rsync-command
            (concat rsync-command
                    (if (string-match "^/ssh:\\(.*:\\)\\(.*\\)$" file)
                        (format " -e ssh \"%s%s\""
                                (match-string 1 file)
                                (shell-quote-argument (match-string 2 file)))
                      (shell-quote-argument file)) " ")))
    ;; append the destination
    (setq rsync-command
          (concat rsync-command
                  (if (string-match "^/ssh:\\(.*?\\)\\([^:]+\\)$" dest)
                      (format " -e ssh %s'\"%s\"'"
                              (match-string 1 dest)
                              (match-string 2 dest))
                    (shell-quote-argument dest))))
    ;; run the async shell command
    (let ((default-directory (expand-file-name "~")))
      (async-shell-command rsync-command
                           (format "rsync to %s" dest)))
    (message rsync-command)
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
        (save-buffer)
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
(defun ora-nw-yank ()
  (interactive)
  (shell-command-on-region (point) (point) "xsel" (current-buffer) t))

;;* Bookmarks
;;;###autoload
(defun bmk/magit-status ()
  "Bookmark for `magit-status'."
  (interactive)
  (when (and (buffer-file-name)
             ;; (equal system-name "firefly")
             )
    (delete-trailing-whitespace)
    (save-buffer))
  (call-interactively 'magit-status))

;;;###autoload
(defun bmk/scratch ()
  "Bookmark for *scratch*."
  (interactive)
  (switch-to-buffer
   (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun bmk/remote-shell ()
  (interactive)
  (require 'tramp)
  (let ((hosts (delq nil (mapcar
                          (lambda (x) (and x (cdr x) (cadr x)))
                          (tramp-parse-sconfig "~/.ssh/config")))))
    (ivy-read "ssh: " hosts
              :action (lambda (h)
                        (dired (concat "/ssh:" h ":/"))
                        (ora-dired-open-term)))))

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
(defun ora-ediff-buffers ()
  (interactive)
  (if (= 2 (length (window-list)))
      (ediff-buffers (window-buffer (nth 1 (window-list)))
                     (current-buffer))
    (call-interactively 'ediff-buffers)))


;;;###autoload
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
            '("" "modes" "git/org-fu"))

    (cd "personal")
    (setq generated-autoload-file (expand-file-name "loaddefs.el"))
    (update-directory-autoloads "")))

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
    (unless (window-minibuffer-p)
      (ivy-switch-buffer))))

;;;###autoload
(defun youtube-dl ()
  (interactive)
  (let* ((str (current-kill 0))
         (default-directory "~/Downloads")
         (proc (get-buffer-process (ansi-term "/bin/bash"))))
    (term-send-string
     proc
     (concat "cd ~/Downloads && youtube-dl --mark-watched "
             (if (string-match "https://www.npo.nl/" str) "" "-f mp4 ")
             str
             "\n"))))

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
    (term-send-string proc
                      "eval \"$(rbenv init -)\";rbenv local 2.5.1; jekyll serve --limit_posts 1\n")
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

(defvar ora-custom-setq-history nil)

;;;###autoload
(defun ora-custom-setq ()
  "Set a custom variable, with completion."
  (interactive)
  (let ((sym (intern
              (ivy-read "Variable: "
                        (counsel-variable-list)
                        :history 'ora-custom-setq-history)))
        sym-type
        cands)
    (if (and (boundp sym)
             (setq sym-type (get sym 'custom-type))
             (cond
               ((and (consp sym-type)
                     (memq (car sym-type) '(choice radio)))
                (setq cands (delq nil (mapcar #'lispy--setq-doconst (cdr sym-type)))))
               ((eq sym-type 'boolean)
                (setq cands '(("nil" . nil) ("t" . t))))
               (t nil)))
        (let ((res (ivy-read (format "Set (%S): " sym)
                             cands
                             :preselect (symbol-name (symbol-value sym)))))
          (when res
            (setq res
                  (if (assoc res cands)
                      (cdr (assoc res cands))
                    (read res)))
            (eval `(setq ,sym ,res))))
      (setq this-command 'eval-expression)
      (let* ((minibuffer-completing-symbol t)
             (expr (minibuffer-with-setup-hook
                       (lambda ()
                         (add-hook 'completion-at-point-functions #'elisp-completion-at-point nil t)
                         (run-hooks 'eval-expression-minibuffer-setup-hook)
                         (goto-char (minibuffer-prompt-end))
                         (forward-char 6)
                         (insert (format "%S " sym)))
                     (read-from-minibuffer "Eval: " (format "(setq '%S)"
                                                            (symbol-value sym))
                                           read-expression-map t
                                           'read-expression-history))))
        (eval-expression expr)))))

;;;###autoload
(defun ora-quote-github-issues ()
  (interactive)
  (let ((base "https://github.com/abo-abo/swiper/issues/"))
    (goto-char (point-min))
    (while (re-search-forward "\\([^[]\\)#\\([0-9]+\\)" nil t)
      (replace-match
       (format "%s[[%s%s][#%s]]"
               (match-string 1)
               base
               (match-string 2)
               (match-string 2)))
      (goto-char (match-end 0))
      (when (and (eolp) (not (eq (char-before) ?.)))
        (insert ".")))
    (goto-char (point-min))
    (while (re-search-forward "\n\n+\\*" nil t)
      (replace-match "\n*" nil t))
    (goto-char (point-min))
    (while (< (point) (point-max))
      (outline-next-visible-heading 1)
      (worf-copy-heading-id t))
    (goto-char (point-min))
    (while (re-search-forward "\\*\\*\\* " nil t)
      (unless (looking-back "-----\n\\** ?")
        (end-of-line 0)
        (insert "\n-----")))))

;;;###autoload
(defun ora-rename-pdf-bibtex ()
  (interactive)
  (when (and (eq major-mode 'dired-mode)
             (equal (file-name-extension (dired-get-filename)) "pdf"))
    (let* ((entry (substring-no-properties (current-kill 0)))
           (title (when (string-match "^ *title={\\(.*?\\)}" entry)
                    (match-string 1 entry)))
           (authors (when (string-match "^ *author={\\(.*?\\)}" entry)
                      (match-string 1 entry)))
           (year (when (string-match "^ *year={\\(.*?\\)}" entry)
                   (match-string 1 entry))))
      (setq title (replace-regexp-in-string "/" "-" title))
      (if (and title authors year)
          (let ((authors (mapconcat (lambda (x)
                                      (if (string-match "\\(.*?\\), \\(.*\\)" x)
                                          (format "%c %s"
                                                  (aref (match-string 2 x) 0)
                                                  (match-string 1 x))
                                        x))
                                    (split-string authors " +and +")
                                    ", ")))
            (dired-rename-file (dired-get-filename)
                               (format "[%s] %s (%s).pdf" authors title year) t)
            (revert-buffer))
        (error "Could not rename file")))))

;;;###autoload
(defun ora-start-process (cmd)
  (start-process
   cmd nil shell-file-name
   shell-command-switch
   (format "nohup 1>/dev/null 2>/dev/null %s" cmd)))

(defun ora-remove-blocks (re-beg re-end)
  (let (beg)
    (goto-char (point-min))
    (while (re-search-forward re-beg nil t)
      (setq beg (match-beginning 0))
      (unless (re-search-forward re-end)
        (error "unmatched"))
      (delete-region beg (point)))))

(defun ora-replace-all (from to)
  (goto-char (point-min))
  (while (re-search-forward from nil t)
    (replace-match to)))

(defun ora-clean-up-pandoc ()
  (interactive)
  (ora-remove-blocks "\n?#\\+begin_html" "^#\\+end_html")
  (ora-replace-all "^-  " "- ")
  (ora-replace-all "^   " "  ")
  (ora-replace-all "\n\\{3,\\}" "\n\n")
  (goto-char (point-min))
  (while (eq (forward-paragraph) 0)
    (fill-paragraph))
  (save-buffer))

(defun show-message (str)
  (switch-to-buffer (get-buffer-create "*lispy-message*"))
  (special-mode)
  (let ((inhibit-read-only t))
    (delete-region (point-min) (point-max))
    (insert str)
    (goto-char (point-min))))

;;;###autoload
(defun git-shortlog ()
  (interactive)
  (let* ((fmt (mapconcat #'identity '("%h" "%s" "%an" "%ad") "%x09"))
         (out (shell-command-to-string
               (format
                "git log --pretty=format:'%s' -n 100 --date=relative" fmt)))
         (commits
          (mapcar (lambda (s) (split-string s "\t" t))
                  (split-string out "\n" t)))
         (ws
          (reduce
           (lambda (a b)
             (list (max (nth 0 a) (length (nth 0 b)))
                   (max (nth 1 a) (length (nth 1 b)))
                   (max (nth 2 a) (length (nth 2 b)))
                   (max (nth 3 a) (length (nth 3 b)))))
           commits
           :initial-value '(0 0 0 0)))
         (ww (window-width))
         (mw (- ww 3
                (nth 0 ws)
                18
                (nth 3 ws))))
    (show-message
     (mapconcat (lambda (x)
                  (destructuring-bind (h m a d) x
                    (concat
                     h " "
                     (truncate-string-to-width m mw nil ?\  t) " "
                     (truncate-string-to-width a 18 nil ?\  t) " "
                     d)))
                commits
                "\n"))))
(global-set-key (kbd "C-c S") 'git-shortlog)

(defun ora-recompile-startup-warnings ()
  (let (ws)
    (with-current-buffer "*Messages*"
      (goto-char (point-min))
      (while (re-search-forward
              "Source file `\\([^']+\\)' newer than byte-compiled file"
              nil t)
        (push (match-string 1) ws))
      ws)))

;;;###autoload
(defun ora-recompile-startup ()
  "Fix byte-compilation warnings emitted by lread.c."
  (interactive)
  (let ((ws (ora-recompile-startup-warnings)))
    (dolist (w ws)
      (let ((default-directory (file-name-directory w)))
        (if (file-exists-p "Makefile")
            (progn
              (message "cd %S && make compile" default-directory)
              (sc "make compile"))
          (message "(byte-compile-file %S)" w)
          (byte-compile-file w t))))))

(defun ora-pid-class (key)
  (let ((classes '(:none "0" :realtime "1" :best-effort "2" :idle "3")))
    (plist-get classes key)))

;;;###autoload
(defun ora-firefox-io-idle ()
  "Make sure Firefox doesn't use too much IO resulting in audio lag."
  (interactive)
  (let* ((pids (split-string (sc "pidof firefox")))
         (ppid (car (last pids)))
         (curr (string-trim (sc (format "ionice -p %s" ppid)))))
    (counsel--run "ionice" "-p" ppid "-c" (ora-pid-class :idle))
    (message "last status: %s" curr)))

;;;###autoload
(defun ora-rhythmbox-io-best ()
  (interactive)
  (let ((pid (string-trim (sc "pidof rhythmbox")))
        (curr (string-trim (sc (format "ionice -p %s" pid)))))
    (counsel--run "ionice" "-p" pid "-c" (ora-pid-class :best-effort) "-n" "0")
    (message "last status: %s" curr)))

(defmacro dbg (f)
  "Debug a defun."
  (let* ((args (nth 2 f))
         (dbgs
          (mapcar
           (lambda (arg)
             `(put 'dbg ',arg ,arg))
           (delete '&optional (copy-sequence args)))))
    (if (stringp (nth 3 f))
        (setcdr (nthcdr 3 f)
                (append dbgs (nthcdr 4 f)))
      (setcdr (nthcdr 2 f)
              (append dbgs (nthcdr 3 f))))
    f))

(defun ora-org-table-yank ()
  (interactive)
  (let* ((clip (current-kill 0))
         (cells (mapcar (lambda (s) (replace-regexp-in-string "\\." "" s))
                        (split-string clip "\n" t))))
    (save-excursion
      (dolist (cell cells)
        (insert cell)
        (org-table-align)
        (next-line 1)))))

(defun ora-advice-unadvice (sym)
  (advice-mapc (lambda (advice _props) (advice-remove sym advice)) sym))

;;;###autoload
(defun ipinfo (ip)
  "Return ip info from ipinfo.io for IP."
  (interactive "sEnter IP to query (blank for own IP): ")
  (require 'request)
  (request
      (concat "https://ipinfo.io/" ip)
      :headers '(("User-Agent" . "Emacs ipinfo.io Client")
                 ("Accept" . "application/json")
                 ("Content-Type" . "application/json;charset=utf-8"))
      :parser 'json-read
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  (message
                   (mapconcat
                    (lambda (e)
                      (format "%10s: %s" (capitalize (symbol-name (car e))) (cdr e)))
                    data "\n"))))
      :error (cl-function
              (lambda (&rest args &key error-thrown &allow-other-keys)
                (message "Can't receive ipinfo. Error %S " error-thrown)))))
