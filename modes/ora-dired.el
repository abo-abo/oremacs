;;* require -*- lexical-binding: t -*-
(require 'dired-x)
(require 'dired-aux)
(require 'term)
(require 'tramp)

;;* set
(ora-advice-add 'dired-internal-noselect :filter-args 'ora-dired-internal-noselect)
(defun ora-dired-internal-noselect (args)
  (cl-destructuring-bind (dir-or-list &optional switches mode) args
    (when (file-remote-p dir-or-list)
      (setq switches "-alh"))
    (list dir-or-list switches mode)))
;; not needed since Emacs-27
(setq directory-free-space-args "-Pmh")
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq dired-omit-verbose nil)

(defun ora-omit-regex (names postfixes prefixes &optional dotfiles)
  (mapconcat #'identity
             (delq nil
                   (list
                    (and postfixes (format "\\(?:\\.%s\\)" (regexp-opt postfixes)))
                    (and prefixes (format "\\(?:\\`%s\\)" (regexp-opt prefixes)))
                    (and names (regexp-opt names))
                    (and dotfiles "\\`\\.[^.]")))
             "\\|"))

(setq dired-omit-files
      (ora-omit-regex
       '("compile_commands.json"
         "TAGS"
         "__pycache__"
         ;; OSv deployments
         "Capstanfile"
         ;; Heroku deployments
         "Procfile")
       '("aux" "log" "pickle" "synctex.gz" "run.xml" "bcf" "am" "in" "blx.bib"
         "vrb" "opt" "nav" "snm" "out" "ass")
       '("_minted" "__")
       t))

(setq dired-garbage-files-regexp
      "\\.idx\\|\\.run\\.xml$\\|\\.bbl$\\|\\.bcf$\\|.blg$\\|-blx.bib$\\|.nav$\\|.snm$\\|.out$\\|.synctex.gz$\\|\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|pyg\\)\\)\\'")
(setq dired-dwim-target t)
(require 'dired-guess)

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

(defadvice dired-readin (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (ora-dired-sort))

;;* rest
(defun ora-dired-show-octal-permissions ()
  "Show current item premissons, e.g. for later use in chmod."
  (interactive)
  (let* ((fname (car (dired-get-marked-files)))
         (fname (if (file-remote-p fname)
                    (tramp-file-name-localname
                     (tramp-dissect-file-name
                      fname))
                  fname))
         (r (counsel--command "stat" "-c" "%a %n" fname)))
    (message (car (split-string r " ")))))

(defun ora-dired-get-size ()
  (interactive)
  (let* ((cmd (concat "du -sch "
                      (mapconcat (lambda (x) (shell-quote-argument (file-name-nondirectory x)))
                                 (dired-get-marked-files) " ")))
         (res (shell-command-to-string cmd)))
    (if (string-match "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$" res)
        (message (match-string 1 res))
      (error "unexpected output %s" res))))

(setq tramp-use-ssh-controlmaster-options nil)
;; (setq tramp-remote-process-environment
;;       (delete "ENV=''" tramp-remote-process-environment))
(setq tramp-verbose 1)
;; (setq tramp-ssh-controlmaster-options
;;       "-o ControlMaster=auto -o ControlPath='~/.ssh/controlmasters/%%r@%%h:%%p' -o ControlPersist=600")

(defun ora-dired-open-term ()
  "Open an `ansi-term' that corresponds to current directory."
  (interactive)
  (if (file-remote-p default-directory)
      (let* ((v (tramp-dissect-file-name default-directory t))
             (host (if (arrayp v) (aref v 2) (tramp-file-name-host v)))
             (dir (if (arrayp v) (aref v 3) (tramp-file-name-localname v)))
             (name (format "*shell  %s*" host))
             (shell (when (assoc name (mash-shell-list))
                      (get-buffer name)))
             (cmd (format "cd %s\n" (shell-quote-argument dir))))
        (if shell
            (progn
              (pop-to-buffer shell)
              (comint-send-string (get-buffer-process shell) cmd)
              (comint-send-input))
          (setq shell (mash-make-shell host 'mash-new-shell cmd))))
    (let ((dir (expand-file-name default-directory))
          (buf (mash-get "def" 'mash-new-shell)))
      (switch-to-buffer buf)
      (goto-char (point-max))
      (delete-region (comint-line-beginning-position) (point))
      (insert (format "cd %s" (shell-quote-argument dir)))
      (call-interactively 'comint-send-input))))

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
(define-key dired-mode-map "r" 'dig-start)
(define-key dired-mode-map "e" 'ora-ediff-files)

(define-key dired-mode-map (kbd "C-t") nil)
(define-key dired-mode-map "i" 'counsel-find-file)
(define-key dired-mode-map "I" 'dired-insert-subdir)
(define-key dired-mode-map "j" 'dired-next-line)
(define-key dired-mode-map "k" 'dired-previous-line)
(define-key dired-mode-map "h" 'dired-do-shell-command)
(define-key dired-mode-map "Y" 'ora-dired-rsync)
(define-key dired-mode-map "R" 'ora-dired-do-rename)
(define-key dired-mode-map (kbd "C-j") 'dired-find-file)
(define-key dired-mode-map (kbd "%^") 'dired-flag-garbage-files)
(define-key dired-mode-map (kbd "z") 'ora-dired-get-size)
(define-key dired-mode-map "F" 'find-name-dired)
(define-key dired-mode-map "f" 'dired-goto-file)
(define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
(define-key dired-mode-map (kbd "`") 'ora-dired-open-term)
(define-key dired-mode-map (kbd "'") 'mash-here)
(define-key dired-mode-map "a" 'ora-dired-up-directory)
(define-key dired-mode-map "!" 'sudired)
(define-key dired-mode-map "h" nil)
(define-key dired-mode-map "O" 'ora-dired-other-window)
(define-key dired-mode-map "P" 'ora-dired-show-octal-permissions)
(define-key dired-mode-map "T" 'ora-dired-terminal)
(define-key dired-mode-map "&" 'ora-dired-do-async-shell-command)

(defun ora-dired-terminal ()
  (interactive)
  (orly-start "gnome-terminal"))

(defun ora-dired-other-window ()
  (interactive)
  (if (string= (buffer-name) "*Find*")
      (find-file-other-window
       (file-name-directory (dired-get-file-for-visit)))
    (save-selected-window
      (dired-find-file-other-window))))

(defun ora-dired-up-directory ()
  (interactive)
  (let ((this-directory default-directory)
        (buffer (current-buffer)))
    (dired-up-directory)
    (unless (cl-find-if
             (lambda (w)
               (with-selected-window w
                 (and (eq major-mode 'dired-mode)
                      (equal default-directory this-directory))))
             (delete (selected-window) (window-list)))
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
(add-to-list 'dired-compress-file-suffixes
             '("\\.tar\\'" "" "tar -xf %i"))
(add-to-list 'dired-compress-file-suffixes
             '("\\.tar.xz\\'" "" "tar -xpvf %i"))

(eval-after-load 'tramp-sh
                 '(progn
                   (setq tramp-sh-file-name-handler-alist
                    (assq-delete-all 'vc-registered tramp-sh-file-name-handler-alist))))
(add-to-list 'backup-directory-alist
             `(,tramp-file-name-regexp . nil))
(setq tramp-chunksize 8192)

(autoload 'org-download-enable "org-download")
(add-hook 'dired-mode-hook 'org-download-enable)

;;;###autoload
(defun ora-dired-hook ()
  (mis-mode 1)
  (dired-omit-mode 1))

(defun ora-dired-utf8-unix ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (dolist (file files)
      (find-file file)
      (set-buffer-file-coding-system 'utf-8-unix)
      (delete-trailing-whitespace)
      (save-buffer)
      (kill-buffer))))

;;;###autoload
(defun ora-dired-jump ()
  (interactive)
  (let* ((file (buffer-file-name))
         (archive-file
          (when (and file (string-match "\\`\\(.*jar\\|.*zip\\):" file))
            (match-string 1 file))))
    (with-no-warnings
      (ring-insert find-tag-marker-ring (point-marker)))
    (if (null archive-file)
        (dired-jump nil file)
      (dired-jump nil archive-file)
      (dired-find-file))))

(defun ora-shell-command-sentinel (process _signal)
  (when (memq (process-status process) '(exit signal))
    (advice-remove 'shell-command-sentinel 'ora-shell-command-sentinel)
    (message (with-current-buffer (process-buffer process)
               (string-trim (buffer-string))))))

(defun ora-dired-do-async-shell-command ()
  "Wrap `dired-do-async-shell-command' without popup windows."
  (interactive)
  (ora-advice-add 'shell-command-sentinel :override #'ora-shell-command-sentinel)
  (save-window-excursion
    (call-interactively 'dired-do-async-shell-command)))

(defun ora-dired-do-rename ()
  (interactive)
  (let ((target (dired-dwim-target-directory)))
    (if (file-remote-p target)
        (progn
          (dired-rsync target)
          (message "pls remove"))
      (dired-do-rename))))

(require 'pora-dired nil t)
(provide 'ora-dired)
