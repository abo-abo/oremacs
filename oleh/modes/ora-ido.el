(require 'ido)
;;* Settings
(setq ido-auto-merge-work-directories-length -1)
;; (setq ido-enable-flex-matching t)
;;* Keymaps
;;** buffer
(define-key ido-buffer-completion-map "η" 'ido-next-match)
;; (define-key ido-buffer-completion-map "\C-i" 'ido-buffer-helm)
(define-key ido-buffer-completion-map "β" 'ido-buffer-helm)
;; (define-key ido-buffer-completion-map " " 'ido-restrict-to-matches)
(define-key ido-buffer-completion-map (kbd "C-p") 'ido-fallback-command)
(define-key ido-buffer-completion-map ";" 'hydra-ido/body)
;;** file
(define-key ido-file-dir-completion-map "~" (lambda () (interactive) (ido-set-current-directory "~/") (setq ido-exit 'refresh) (exit-minibuffer)))
(define-key ido-file-dir-completion-map (kbd "φ") 'ido-next-match)
(define-key ido-file-dir-completion-map (kbd ":") 'ido-prev-match)
(define-key ido-file-dir-completion-map (kbd "C-y") 'ido-yank)
;;** common
(define-key ido-common-completion-map (kbd "DEL") 'ido-backspace)
(define-key ido-common-completion-map "\C-n" 'ido-next-match)
(define-key ido-common-completion-map (kbd "\C-p") 'ido-prev-match)
(define-key ido-common-completion-map " " 'self-insert-command)
;;* Functions
(require 'hydra)
(defhydra hydra-ido (:color amaranth
                     :pre (setq hydra-is-helpful nil)
                     :post (setq hydra-is-helpful t))
  ("j" ido-next-match)
  ("k" ido-prev-match)
  ("v" (lambda ()
         (interactive)
         (setq hydra-is-helpful t)
         (ido-exit-minibuffer)))
  ("q" nil))

(defun ido-backspace ()
  "Forward to `backward-delete-char'.
On error (read-only), quit without selecting."
  (interactive)
  (condition-case nil
      (backward-delete-char 1)
    (error
     (minibuffer-keyboard-quit))))

(defun ido-yank ()
  "Forward to `yank'."
  (interactive)
  (if (file-exists-p (current-kill 0))
      (ido-fallback-command)
    (yank)))

(eval-after-load 'smex
  `(defun smex-prepare-ido-bindings ()
     (define-key ido-completion-map (kbd "TAB") 'minibuffer-complete)
     (define-key ido-completion-map (kbd "C-,") 'smex-describe-function)
     (define-key ido-completion-map (kbd "C-w") 'smex-where-is)
     (define-key ido-completion-map (kbd "C-.") 'smex-find-function)
     (define-key ido-completion-map (kbd "C-a") 'move-beginning-of-line)
     (define-key ido-completion-map "β" 'smex-helm)
     (define-key ido-completion-map " " 'smex-helm)))

(provide 'ora-ido)
