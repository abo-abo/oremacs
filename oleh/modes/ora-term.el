(require 'term)
(setq explicit-shell-file-name "/bin/bash")

;;;###autoload
(defun ora-term-exec-hook ()
  (let* ((buff (current-buffer))
         (proc (get-buffer-process buff)))
    (set-process-sentinel
     proc
     `(lambda (process event)
        (if (string= event "finished\n")
            (kill-buffer ,buff))))))

(define-key term-raw-map "\C-d"
  (lambda ()
    (interactive)
    (if (or (eobp)
            (and (= 1 (- (point-max) (point)))
                 (= 32 (char-before))))
        (term-send-eof)
      (delete-char 1))))
(define-key term-raw-map "ν" 'ace-window)
(define-key term-raw-map (kbd "C-c C-y") 'term-paste)
(define-key term-raw-map "\C-t" nil)
(define-key term-raw-map (kbd "C-M-o") nil)
(define-key term-raw-map (kbd "C-c m") nil)
(define-key term-raw-map (kbd "C-s") 'swiper)

;;;###autoload
(defun ora-term-hook ()
  (when (bound-and-true-p yas-minor-mode)
    (yas-minor-mode -1)))

(mapc (lambda (key) (define-key term-raw-map (kbd key) 'term-send-raw))
      '("φ" "θ" "ω" "ρ"))
