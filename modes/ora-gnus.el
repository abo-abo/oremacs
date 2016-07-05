(require 'gnus)
(require 'gnus-group)
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
  ;; (bbdb-initialize 'message)
  ;; (bbdb-initialize 'gnus)
  ;; (define-key message-mode-map (kbd "<tab>") 'bbdb-complete-mail)
  )

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
