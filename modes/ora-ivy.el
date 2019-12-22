;; -*- lexical-binding: t -*-
(require 'ivy)
(require 'ivy-hydra)
(require 'counsel)
(csetq ivy-display-style 'fancy)
;; (csetq ivy-count-format "(%d/%d) ")
(csetq ivy-use-virtual-buffers t)
(csetq counsel-find-file-ignore-regexp "\\(?:\\`\\(?:\\.\\|__\\)\\|elc\\|pyc$\\)")
(csetq ivy-use-selectable-prompt t)
(define-key ivy-minibuffer-map (kbd "<return>") 'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "C-M-h") 'ivy-previous-line-and-call)
(define-key ivy-minibuffer-map (kbd "C-:") 'ivy-dired)
(define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-occur)
(define-key ivy-minibuffer-map (kbd "C-c C-a") 'ivy-read-action)
(setq ivy-read-action-function #'ivy-hydra-read-action)
(let ((key "C-."))
  (when (boundp 'ivy-dispatching-done-hydra-exit-keys)
    (add-to-list 'ivy-dispatching-done-hydra-exit-keys (list key nil "back")))
  (define-key ivy-minibuffer-map (kbd key) 'ivy-dispatching-done))
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
(when (and (version< "24.5" emacs-version)
           (eq system-type 'gnu/linux)
           (char-displayable-p ?🙒))
  (diminish 'ivy-mode " 🙒"))

(ivy-set-display-transformer 'counsel-describe-function nil)

(defun ivy-dired ()
  (interactive)
  (if ivy--directory
      (ivy-quit-and-run
       (dired ivy--directory)
       (when (re-search-forward
              (regexp-quote
               (substring ivy--current 0 -1)) nil t)
         (goto-char (match-beginning 0))))
    (user-error
     "Not completing files currently")))

(setq ivy-switch-buffer-faces-alist
      '((emacs-lisp-mode . swiper-match-face-1)
        (dired-mode . ivy-subdir)
        (org-mode . org-level-4)))

(setq counsel-grep-base-command "grep -niE %s %s")
(setq counsel-grep-base-command
      "rg -i -M 120 --no-heading --line-number --color never %s %s")
;; TODO: --sort may be slow, since it turns off parallelism
;; but I like --sort because of consistent result display.
;; there's no flickering beteen the input "ivy-f" and "ivy-fo".
(setq counsel-rg-base-command
      "rg --sort path -M 120 --no-heading --line-number --color never %s")

(setq counsel-git-grep-cmd-default
      (concat "git --no-pager grep --full-name -n --no-color -i -e '%s' -- './*' "
              (mapconcat (lambda (x) (format "':!*.%s'" x))
                         '("htm" "so" "a" "TTC" "NDS" "png" "md5") " ")))

(defun ora-counsel-git ()
  (interactive)
  (let ((counsel-git-cmd "rg -0 --files"))
    (counsel-git)))

(defun ivy-view-backtrace ()
  (interactive)
  (switch-to-buffer "*ivy-backtrace*")
  (delete-region (point-min) (point-max))
  (fundamental-mode)
  (insert ivy-old-backtrace)
  (goto-char (point-min))
  (forward-line 1)
  (let (part parts)
    (while (< (point) (point-max))
      (condition-case nil
          (progn
            (setq part (read (current-buffer)))
            (push part parts)
            (delete-region (point-min) (point)))
        (error
         (progn
           (ignore-errors (up-list))
           (delete-region (point-min) (point)))))))
  (goto-char (point-min))
  (dolist (part parts)
    (lispy--insert part)
    (lispy-alt-multiline)
    (insert "\n")))

(setq counsel-fzf-dir-function
      (lambda ()
        (let ((d (locate-dominating-file default-directory ".git")))
          (if (or (null d)
                  (equal (expand-file-name d)
                         (expand-file-name "~/")))
              default-directory
            d))))

(setq counsel-linux-apps-directories
      '("/usr/local/share/applications/"
        "/usr/share/applications/"))

(define-key ivy-switch-buffer-map (kbd "C-k") 'ivy-switch-buffer-kill)

(defun ora-toggle-ivy-posframe ()
  (interactive)
  (require 'ivy-posframe)
  (if (assoc t ivy-display-functions-alist)
      (setq ivy-display-functions-alist
            (assq-delete-all t ivy-display-functions-alist))
    (add-to-list 'ivy-display-functions-alist '(t . ivy-posframe-display-at-frame-center))
    (ivy-posframe-enable)))

(setq ivy-posframe-font "-PfEd-DejaVu Sans Mono-normal-normal-normal-*-18-*-*-*-m-0-iso10646-1")
(setq ivy-posframe-width 80)

(when (file-exists-p "/home/.ecryptfs/")
  (let ((db-fname (expand-file-name "~/.local/mlocate.db")))
    (setenv "LOCATE_PATH" db-fname)

    (defun ora-counsel-locate ()
      (interactive)
      (when (> (time-to-number-of-days
                (time-subtract
                 (current-time)
                 (nth 5 (file-attributes db-fname))))
               1)
        (orfu-shell
         (format "time updatedb -l 0 -o %s -U $HOME" db-fname) "*updatedb*"))
      (counsel-locate))

    (global-set-key (kbd "C-x l") 'ora-counsel-locate)))

(csetq counsel-org-goto-all-outline-path-prefix 'file-name-nondirectory)

(define-key isearch-mode-map (kbd "C-c s") 'swiper-isearch-toggle)
(define-key swiper-map (kbd "C-c s") 'swiper-isearch-toggle)
(define-key ivy-occur-grep-mode-map (kbd "M-i") #'ora-ivy-occur-grep-iedit)

(defun ora-ivy-occur-grep-iedit ()
  (interactive)
  (when buffer-read-only
    (ivy-wgrep-change-to-wgrep-mode))
  (iedit-mode))

(require 'pora-ivy nil t)
(provide 'ora-ivy)
