(require 'comint)

(define-key comint-mode-map (kbd "<tab>") 'completion-at-point)
(define-key comint-mode-map (kbd "C-k") 'ora-comint-kill-line)
(define-key comint-mode-map (kbd "M-.") 'ora-comint-goto-link)

(defun ora-compilation-next-error-function (_orig-fn n &optional reset)
  "Advance to the next error message and visit the file where the error was.
This is the value of `next-error-function' in Compilation buffers."
  (interactive "p")
  (when reset
    (setq compilation-current-error nil))
  (let* ((screen-columns compilation-error-screen-columns)
         (first-column compilation-first-column)
         (last 1)
         (msg (compilation-next-error (or n 1) nil
                                      (or compilation-current-error
                                          compilation-messages-start
                                          (point-min))))
         (loc (compilation--message->loc msg))
         (end-loc (compilation--message->end-loc msg))
         (marker (point-marker)))
    (unless loc
      (user-error "No next error"))
    (setq compilation-current-error (point-marker)
          overlay-arrow-position
          (if (bolp)
              compilation-current-error
            (copy-marker (line-beginning-position))))
    ;; If loc contains no marker, no error in that file has been visited.
    ;; If the marker is invalid the buffer has been killed.
    ;; So, recalculate all markers for that file.
    (unless (and (compilation--loc->marker loc)
                 (marker-buffer (compilation--loc->marker loc))
                 ;; FIXME-omake: For "omake -P", which automatically recompiles
                 ;; when the file is modified, the line numbers of new output
                 ;; may not be related to line numbers from earlier output
                 ;; (earlier markers), so we used to try to detect it here and
                 ;; force a reparse.  But that caused more problems elsewhere,
                 ;; so instead we now flush the file-structure when we see
                 ;; omake's message telling it's about to recompile a file.
                 ;; (or (null (compilation--loc->timestamp loc)) ;A fake-loc
                 ;;     (equal (compilation--loc->timestamp loc)
                 ;;            (setq timestamp compilation-buffer-modtime)))
                 )
      (with-current-buffer
          (let ((f (caar (compilation--loc->file-struct loc))))
            (cond ((bufferp f)
                   (caar (compilation--loc->file-struct loc)))
                  ((file-exists-p f)
                   (find-file-noselect f))
                  (t
                   (apply #'compilation-find-file
                          marker
                          (caar (compilation--loc->file-struct loc))
                          (cadr (car (compilation--loc->file-struct loc)))
                          (compilation--file-struct->formats
                           (compilation--loc->file-struct loc))))))
        (let ((screen-columns
               ;; Obey the compilation-error-screen-columns of the target
               ;; buffer if its major mode set it buffer-locally.
               (if (local-variable-p 'compilation-error-screen-columns)
                   compilation-error-screen-columns screen-columns))
              (compilation-first-column
               (if (local-variable-p 'compilation-first-column)
                   compilation-first-column first-column)))
          (save-restriction
            (widen)
            (goto-char (point-min))
            ;; Treat file's found lines in forward order, 1 by 1.
            (dolist (line (reverse (cddr (compilation--loc->file-struct loc))))
              (when (car line) ; else this is a filename without a line#
                (compilation-beginning-of-line (- (car line) last -1))
                (setq last (car line)))
              ;; Treat line's found columns and store/update a marker for each.
              (dolist (col (cdr line))
                (if (compilation--loc->col col)
                    (if (eq (compilation--loc->col col) -1)
                        ;; Special case for range end.
                        (end-of-line)
                      (compilation-move-to-column (compilation--loc->col col)
                                                  screen-columns))
                  (beginning-of-line)
                  (skip-chars-forward " \t"))
                (if (compilation--loc->marker col)
                    (set-marker (compilation--loc->marker col) (point))
                  (setf (compilation--loc->marker col) (point-marker)))
                ;; (setf (compilation--loc->timestamp col) timestamp)
                ))))))
    (compilation-goto-locus marker (compilation--loc->marker loc)
                            (compilation--loc->marker end-loc))
    (setf (compilation--loc->visited loc) t)))

(advice-add 'compilation-next-error-function :around #'ora-compilation-next-error-function)


;;;###autoload
(defun ora-comint-hook ()
  (setq completion-at-point-functions
        '(bash-completion-dynamic-complete
          comint-c-a-p-replace-by-expanded-history
          shell-environment-variable-completion
          shell-command-completion
          shell-c-a-p-replace-by-expanded-directory
          shell-filename-completion
          comint-filename-completion))
  (make-variable-buffer-local 'comint-preoutput-filter-functions)
  (shell-dirtrack-mode 1))

(defun ora-fontify-shell-links (str)
  (replace-regexp-in-string
   "\e\\]8;[^;]*;\\(.*?\\)\e\\\\\\(.*?\\)\e\\]8;;\e\\\\?"
   (lambda (s)
     (let ((url (match-string-no-properties 1 s))
           (text (match-string-no-properties 2 s)))
       (propertize text
                   'face 'url
                   'url url
                   'action (lambda (x) (browse-url (button-get x 'url)))
                   'category 'default-button
                   'button '(t))))
   str))

(add-hook 'comint-preoutput-filter-functions 'ora-fontify-shell-links)

(defun ora-comint-kill-line ()
  (interactive)
  (let* ((offset (- (point) (line-beginning-position)))
         (line (buffer-substring-no-properties
                (line-beginning-position) (line-end-position)))
         (bnd (with-temp-buffer
                (sh-mode)
                (insert line)
                (goto-char (point-min))
                (forward-char offset)
                (lispy--bounds-string))))
    (if bnd
        (kill-region
         (point) (+ (line-beginning-position) (cdr bnd) -2))
      (kill-region (point) (line-end-position)))))

(defun ora-comint-goto-link ()
  (interactive)
  (let (fname line)
    (when (cond ((save-excursion
                   (beginning-of-line)
                   (looking-at "\\(/?\\)\\(.*\\):\\([0-9]+\\):"))
                 (setq root-p (match-string-no-properties 1))
                 (setq fname (match-string-no-properties 2))
                 (setq line (match-string-no-properties 3))
                 (if (string= root-p "")
                     (setq fname (expand-file-name fname))
                   (setq fname (concat root-p fname))))
                ((save-excursion
                   (beginning-of-line)
                   (re-search-forward "lineno=\\([0-9]+\\).*pathname=\\(.*\\) pid" (line-end-position) t))
                 (setq line (match-string-no-properties 1))
                 (setq fname (match-string-no-properties 2))))
      (xref-push-marker-stack)
      (find-file fname)
      (goto-char (point-min))
      (forward-line (1- (string-to-number line)))
      (lpy-beginning-of-line))))

(provide 'ora-comint)
