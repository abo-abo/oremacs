(use-package company)
(csetq company-idle-delay 0.4)
(csetq company-show-numbers t)
(csetq company-elisp-detect-function-context nil)
(diminish 'company-mode " ❋")
(setq company-minimum-prefix-length 3)

(setq company-frontends
      '(company-pseudo-tooltip-unless-just-one-frontend
        company-preview-if-just-one-frontend))
(setq company-backends
      '(company-capf
        (company-dabbrev-code company-gtags company-etags
                              company-keywords)
        company-files
        company-dabbrev))

(when (featurep 'company-elisp)
  (require 'company-elisp)
  (cl-pushnew 'company-elisp company-backends))

(defun ora-company-number ()
  "Forward to `company-complete-number'.

Unless the number is potentially part of the candidate.
In that case, insert the number."
  (interactive)
  (let* ((k (this-command-keys))
         (re (concat "^" company-prefix k)))
    (if (or (cl-find-if (lambda (s) (string-match re s))
                        company-candidates)
            (> (string-to-number k)
               (length company-candidates))
            (looking-back "[0-9]+\\.[0-9]*" (line-beginning-position)))
        (self-insert-command 1)
      (company-complete-number
       (if (equal k "0")
           10
         (string-to-number k))))))

(defun ora--company-good-prefix-p (orig-fn prefix &optional min-length)
  (unless (and (stringp prefix) (string-match-p "\\`[0-9]+\\'" prefix))
    (funcall orig-fn prefix min-length)))

(ora-advice-add 'company--good-prefix-p :around #'ora--company-good-prefix-p)

(let ((map company-active-map))
  (mapc (lambda (x) (define-key map (format "%d" x) 'ora-company-number))
        (number-sequence 0 9))
  (define-key map " " (lambda ()
                        (interactive)
                        (company-abort)
                        (self-insert-command 1)))
  (define-key map (kbd "<return>") nil))

(provide 'ora-company)
