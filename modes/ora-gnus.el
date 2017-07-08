(require 'gnus)
(require 'gnus-group)
(require 'message)
(require 'bbdb)
(setq bbdb-complete-mail nil)
;; (define-key message-mode-map (kbd "C-M-i") 'counsel-bbdb-mail)


(setq nnmail-treat-duplicates t)
;;* article
(define-key gnus-article-mode-map "\C-h" nil)
(define-key gnus-article-mode-map "j" 'forward-paragraph)
(define-key gnus-article-mode-map "k" 'backward-paragraph)
(define-key gnus-article-mode-map "v"
  (lambda () (interactive) (recenter 0)))

;;* summary
(define-key gnus-summary-mode-map "j" 'gnus-summary-next-article)
(define-key gnus-summary-mode-map "k" 'gnus-summary-prev-article)
(define-key gnus-summary-mode-map "h" 'gnus-summary-up-thread)
(define-key gnus-summary-mode-map "\C-t" nil)
(define-key gnus-summary-mode-map "v" 'gnus-summary-scroll-up)
(define-key gnus-summary-mode-map (kbd "DEL") 'gnus-summary-clear-mark-backward)
;;* group
(define-key gnus-group-mode-map "k" 'gnus-group-prev-group)
(define-key gnus-group-mode-map "j" 'gnus-group-next-group)
(define-key gnus-group-mode-map "p" 'gnus-group-jump-to-group)
(define-key gnus-group-mode-map "v" (lambda () (interactive) (gnus-group-select-group t)))
(define-key gnus-group-mode-map (kbd "C-o") 'ora-list-subscribed-groups)
;;* hooks
;;;###autoload
(defun ora-gnus-group-hook ())

;;;###autoload
(defun ora-gnus-summary-hook ())

;;;###autoload
(defun ora-message-hook ()
  (flyspell-mode)
  (bbdb-initialize 'message)
  ;; (bbdb-initialize 'gnus)
  )

(define-key message-mode-map (kbd "C-c C-v") nil)

;;;###autoload
(defun ora-gnus-article-hook ())

(add-to-list
 'gnus-secondary-select-methods
 '(nnimap "gmail"
   (nnimap-address "imap.gmail.com")
   (nnimap-server-port 993)
   (nnimap-stream ssl)))

(setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

(defun ora-list-subscribed-groups ()
  "List all subscribed groups with or without un-read messages"
  (interactive)
  (gnus-group-list-all-groups 5))

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
  (if (boundp 'mu4e~contacts)
      (ivy-read "email: " mu4e~contacts
                :initial-input (ivy-set-completion-bounds)
                :action #'ivy-completion-in-region-action)
    (ivy-read "email: " (counsel-bbdb-cands (ivy-set-completion-bounds))
              :action #'ivy-completion-in-region-action)))

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

(provide 'ora-gnus)
