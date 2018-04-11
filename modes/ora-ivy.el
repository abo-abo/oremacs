;; -*- lexical-binding: t -*-
(require 'ivy)
(require 'ivy-hydra)
(require 'counsel)
(csetq ivy-display-style 'fancy)
;; (csetq ivy-count-format "(%d/%d) ")
(csetq ivy-use-virtual-buffers t)
(csetq counsel-find-file-ignore-regexp "\\`\\.")
(define-key ivy-minibuffer-map (kbd "<return>") 'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "C-M-h") 'ivy-previous-line-and-call)
(define-key ivy-minibuffer-map (kbd "C-:") 'ivy-dired)
(define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-occur)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
(define-key read-expression-map (kbd "C-r") 'counsel-minibuffer-history)
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
(setq counsel-rg-base-command
      "rg -i -M 120 --no-heading --line-number --color never %s .")

(setq counsel-git-grep-cmd-default
      (concat "git --no-pager grep --full-name -n --no-color -i -e '%s' -- './*' "
              (mapconcat (lambda (x) (format "':!*.%s'" x))
                         '("htm" "so" "a" "TTC" "NDS" "png" "md5") " ")))
(setq counsel-git-grep-projects-alist
      (list
       (cons "/home/oleh/Dropbox/source/site-lisp/"
             (concat "/home/oleh/Dropbox/source/site-lisp/etc/git-multi-grep '%s' "
                     "/home/oleh/Dropbox/source/site-lisp 'git/*'"))
       (cons "/home/oleh/git/ivy-dependencies/"
             (concat "/home/oleh/Dropbox/source/site-lisp/etc/git-multi-grep '%s' "
                     "/home/oleh/git/ivy-dependencies '*'"))))
(setq counsel-git-cmd "rg --files")

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

(provide 'ora-ivy)
