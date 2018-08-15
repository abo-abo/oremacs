;;* require -*- lexical-binding: t -*-
(require 'dired-x)
(require 'dired-aux)
(require 'term)
;;* set
(setq dired-listing-switches
      (if (eq system-type 'windows-nt)
          "-alh"
        "-laGh1v --group-directories-first"))
(advice-add 'dired-internal-noselect :filter-args 'ora-dired-internal-noselect)
(defun ora-dired-internal-noselect (args)
  (cl-destructuring-bind (dir-or-list &optional switches mode) args
    (when (file-remote-p dir-or-list)
      (setq switches "-alh"))
    (list dir-or-list switches mode)))
(setq directory-free-space-args "-Pmh")
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq dired-omit-files
      (format "\\(?:\\.%s\\'\\)\\|%s\\|\\`\\.[^.]\\|\\`_minted"
              (regexp-opt
               '("aux" "log" "pickle" "synctex.gz" "run.xml" "bcf" "am" "in" "blx.bib"
                 "vrb" "opt" "nav" "snm" "out" "ass"))
              (regexp-opt
               '("compile_commands.json"
                 "TAGS"
                 "__pycache__"))))
(setq dired-omit-verbose nil)
(setq dired-garbage-files-regexp
      "\\.idx\\|\\.run\\.xml$\\|\\.bbl$\\|\\.bcf$\\|.blg$\\|-blx.bib$\\|.nav$\\|.snm$\\|.out$\\|.synctex.gz$\\|\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|pyg\\)\\)\\'")
(setq dired-dwim-target t)
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "evince" "okular")
        ("\\.\\(?:djvu\\|eps\\)\\'" "evince")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|svg\\|gif\\|tiff\\|xpm\\|bmp\\)\\'" "eog")
        ("\\.\\(?:xcf\\)\\'" "gimp")
        ("\\.csv\\'" "libreoffice")
        ("\\.tex\\'" "pdflatex" "latex")
        ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|ogv\\|ifo\\|m4v\\|wmv\\|webm\\)\\(?:\\.part\\)?\\'"
         "vlc")
        ("\\.\\(?:mp3\\|flac\\|wv\\)\\'" "rhythmbox")
        ("\\.html?\\'" "firefox")
        ("\\.cue?\\'" "audacious")
        ("\\.\\(?:pptx?\\|odt\\|xlsx?\\|docx?\\)\\'" "libreoffice")
        ("\\.\\(?:zip\\|tgz\\)\\'" "file-roller")))
;;* advice
(defadvice dired-advertised-find-file (around ora-dired-subst-directory activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let* ((orig (current-buffer))
         (filename (dired-get-filename t t))
         (bye-p (file-directory-p filename)))
    ad-do-it
    (when (and bye-p (not (string-match "[/\\\\]\\.$" filename)))
      (kill-buffer orig))))

(defadvice dired-delete-entry (before ora-force-clean-up-buffers (file) activate)
  (let ((buffer (get-file-buffer file)))
    (when buffer
      (kill-buffer buffer))))

(defun ora-dired-sort ()
  "Sort dired listings with directories first."
  (when (file-remote-p default-directory)
    (save-excursion
      (let (buffer-read-only)
        ;; beyond dir. header
        (forward-line 2)
        (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
      (set-buffer-modified-p nil))))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (ora-dired-sort))

;;* rest
(defun ora-dired-get-size ()
  (interactive)
  (let* ((cmd (concat "du -sch "
                      (mapconcat (lambda (x) (shell-quote-argument (file-name-nondirectory x)))
                                 (dired-get-marked-files) " ")))
         (res (shell-command-to-string cmd)))
    (if (string-match "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$" res)
        (message (match-string 1 res))
      (error "unexpected output %s" res))))

(defvar ora-dired-filelist-cmd
  '(("vlc" "-L")))

(defun ora-dired-start-process (cmd &optional file-list)
  (interactive
   (let ((files (dired-get-marked-files t nil)))
     (list
      (cond ((memq system-type '(windows-nt cygwin))
             nil)
            (current-prefix-arg
             (dired-read-shell-command "& on %s: " nil files))
            (t
             (let ((prog (dired-guess-default files)))
               (if (consp prog)
                   (car prog)
                 prog))))
      files)))
  (if (eq system-type 'windows-nt)
      (dolist (file file-list)
        (w32-shell-execute "open" (expand-file-name file)))
    (when (eq system-type 'cygwin)
      (setq cmd "cygstart"))
    (let (list-switch)
      (start-process
       cmd nil shell-file-name
       shell-command-switch
       (format
        "nohup 1>/dev/null 2>/dev/null %s \"%s\""
        (if (and (> (length file-list) 1)
                 (setq list-switch
                       (cadr (assoc cmd ora-dired-filelist-cmd))))
            (format "%s %s" cmd list-switch)
          cmd)
        (mapconcat #'expand-file-name file-list "\" \""))))))

(defun ora-dired-open-term ()
  "Open an `ansi-term' that corresponds to current directory."
  (interactive)
  (let ((current-dir (dired-current-directory)))
    (if (file-remote-p current-dir)
        (let* ((v (tramp-dissect-file-name current-dir t))
               (user (if (arrayp v) (aref v 1) (tramp-file-name-user v)))
               (host (if (arrayp v) (aref v 2) (tramp-file-name-host v)))
               (addr (concat (if user (concat user "@") "") host))
               (dir (if (arrayp v) (aref v 3) (tramp-file-name-localname v)))
               (name (format "*shell  %s*" host))
               (shell (when (assoc name (mash-shell-list))
                        (get-buffer name))))
          (unless shell
            (setq shell (mash-make-shell host 'mash-new-shell))
            (if (string= addr "root@target")
                (term-send-string (get-buffer-process shell) "sshpass -proot ssh -t root@target\n")
              (message (concat "ssh -t " addr "\n"))))
          (comint-send-string (get-buffer-process shell)
                              (format "cd %s\n" (shell-quote-argument dir)))
          (pop-to-buffer shell)
          (comint-send-input))
      (let ((buf (mash-get "def" 'mash-new-shell)))
        (switch-to-buffer buf)
        (goto-char (point-max))
        (delete-region (comint-line-beginning-position) (point))
        (insert (format "cd %s" (shell-quote-argument current-dir)))
        (call-interactively 'comint-send-input))
      ;; (term-send-string
      ;;  (ora-terminal)
      ;;  (format "cd '%s'\n" current-dir))
      )
    (setq default-directory current-dir)))


(require 'hydra)
(defhydra hydra-marked-items (dired-mode-map "")
  "
Number of marked items: %(length (dired-get-marked-files))
"
  ("m" dired-mark "mark"))

(defun ora-ediff-files ()
  (interactive)
  (let ((files (dired-get-marked-files))
        (wnd (current-window-configuration)))
    (if (<= (length files) 2)
        (let ((file1 (car files))
              (file2 (if (cdr files)
                         (cadr files)
                       (read-file-name "file: "
                                       (dired-dwim-target-directory)))))
          (when (file-newer-than-file-p file1 file2)
            (cl-rotatef file1 file2))
          (if (string-match "current ar archive" (sc (format "file %s" file1)))
              (async-shell-command
               (format "hexdump-diffuse %s %s"
                       (shell-quote-argument file1)
                       (shell-quote-argument file2)))
            (ediff-files file1 file2)
            (add-hook 'ediff-after-quit-hook-internal
                      (lambda ()
                        (setq ediff-after-quit-hook-internal nil)
                        (set-window-configuration wnd)))))
      (error "no more than 2 files should be marked"))))

;;* bind and hook
(define-key dired-mode-map "r" 'ora-dired-start-process)
(define-key dired-mode-map "e" 'ora-ediff-files)

(define-key dired-mode-map (kbd "C-t") nil)
(define-key dired-mode-map "i" 'counsel-find-file)
(define-key dired-mode-map "I" 'dired-insert-subdir)
(define-key dired-mode-map "j" 'dired-next-line)
(define-key dired-mode-map "k" 'dired-previous-line)
(define-key dired-mode-map "h" 'dired-do-shell-command)
(define-key dired-mode-map "Y" 'ora-dired-rsync)
(define-key dired-mode-map (kbd "C-j") 'dired-find-file)
(define-key dired-mode-map (kbd "%^") 'dired-flag-garbage-files)
(define-key dired-mode-map (kbd "z") 'ora-dired-get-size)
(define-key dired-mode-map "F" 'find-name-dired)
(define-key dired-mode-map "f" 'dired-goto-file)
(define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
(define-key dired-mode-map (kbd "`") 'ora-dired-open-term)
(define-key dired-mode-map (kbd "'") 'eshell-this-dir)
(define-key dired-mode-map "a" 'ora-dired-up-directory)
(define-key dired-mode-map "!" 'sudired)
(define-key dired-mode-map "h" nil)
(define-key dired-mode-map "O" 'ora-dired-other-window)
(define-key dired-mode-map "T" 'ora-dired-terminal)
(define-key dired-mode-map "&" 'ora-dired-do-async-shell-command)

(defun ora-dired-terminal ()
  (interactive)
  (ora-dired-start-process "gnome-terminal"))

(defun ora-dired-other-window ()
  (interactive)
  (save-selected-window
    (dired-find-file-other-window)))

(defun ora-dired-up-directory ()
  (interactive)
  (let ((buffer (current-buffer)))
    (dired-up-directory)
    (unless (equal buffer (current-buffer))
      (kill-buffer buffer))))

(use-package make-it-so
    :commands make-it-so mis-mode
    :init
    (setq mis-recipes-directory
          (expand-file-name
           "git/make-it-so/recipes/" emacs-d)))
(add-to-list 'dired-compress-file-suffixes
             '("\\.rar\\'" "" "unrar x '%i'"))
(add-to-list 'dired-compress-file-suffixes
             '("\\.7z\\'" "" "7z x '%i'"))
(add-to-list 'dired-compress-file-suffixes
             '("\\.tgz\\'" "" "gzip -dc %i | tar -xv"))

(eval-after-load 'tramp-sh
  '(progn
    (setq tramp-sh-file-name-handler-alist
     (assq-delete-all 'vc-registered tramp-sh-file-name-handler-alist))))

;;;###autoload
(defun ora-dired-hook ()
  (mis-mode 1)
  (dired-omit-mode))

(defun ora-dired-utf8-unix ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (dolist (file files)
      (find-file file)
      (set-buffer-file-coding-system 'utf-8-unix)
      (delete-trailing-whitespace)
      (save-buffer)
      (kill-buffer))))

(defun ora-dired-do-async-shell-command ()
  "Wrap `dired-do-async-shell-command' without popup windows."
  (interactive)
  (advice-add 'shell-command-sentinel :override #'ora-shell-command-sentinel)
  (save-window-excursion
    (call-interactively 'dired-do-async-shell-command)))

(provide 'ora-dired)
