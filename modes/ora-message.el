(require 'message)
(require 'bbdb)

(defun ivy-set-completion-bounds ()
  (let ((bnd (bounds-of-thing-at-point 'symbol)))
    (if bnd
        (progn
          (buffer-substring-no-properties
           (setq ivy-completion-beg (car bnd))
           (setq ivy-completion-end (cdr bnd))))
        (setq ivy-completion-beg nil)
        (setq ivy-completion-end nil)
        "")))

(defun counsel-bbdb-mail ()
  (interactive)
  (ivy-read "email: " (counsel-bbdb-cands (ivy-set-completion-bounds))
            :action #'ivy-completion-in-region-action))

(defun counsel-bbdb-cands (&optional str)
  (setq str (or str ""))
  (bbdb-buffer)
  (let* ((all-completions (all-completions str bbdb-hashtable
                                           'bbdb-completion-predicate))
         (records (delete-dups
                   (apply 'append (mapcar (lambda (compl)
                                            (gethash compl bbdb-hashtable))
                                          all-completions))))
         dwim-completions)
    (dolist (key all-completions)
      (dolist (record (gethash key bbdb-hashtable))
        (let ((mails (bbdb-record-mail record))
              accept)
          (when mails
            (dolist (field '(fl-name lf-name mail aka organization))
              (cond ((eq field 'fl-name)
                     (if (bbdb-string= key (bbdb-record-name record))
                         (push (car mails) accept)))
                    ((eq field 'lf-name)
                     (if (bbdb-string= key (bbdb-cache-lf-name
                                            (bbdb-record-cache record)))
                         (push (car mails) accept)))
                    ((eq field 'aka)
                     (if (member-ignore-case key (bbdb-record-field
                                                  record 'aka-all))
                         (push (car mails) accept)))
                    ((eq field 'organization)
                     (if (member-ignore-case key (bbdb-record-organization
                                                  record))
                         (push (car mails) accept)))
                    ((eq field 'primary)
                     (if (bbdb-string= key (car mails))
                         (push (car mails) accept)))
                    ((eq field 'mail)
                     (dolist (mail mails)
                       (if (bbdb-string= key mail)
                           (push mail accept))))))
            (dolist (mail (delete-dups accept))
              (push (bbdb-dwim-mail record mail) dwim-completions))))))
    (sort (delete-dups dwim-completions)
          'string-lessp)))

(define-key message-mode-map (kbd "C-M-i") 'counsel-bbdb-mail)

(provide 'ora-message)
