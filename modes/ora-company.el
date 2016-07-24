(require 'company)
(require 'company-elisp)
(csetq company-idle-delay 0.4)
(csetq company-show-numbers t)
(csetq company-elisp-detect-function-context nil)
(diminish 'company-mode " ❋")
(setq company-minimum-prefix-length 3)

(setq company-frontends
      '(company-pseudo-tooltip-unless-just-one-frontend
        company-preview-if-just-one-frontend))

(setq company-backends
      '(company-elisp
        ;; company-semantic
        company-capf
        (company-dabbrev-code company-gtags company-etags
         company-keywords)
        company-files
        company-dabbrev))

(let ((map company-active-map))
  (mapc (lambda (x) (define-key map (format "%d" x)
                 `(lambda () (interactive) (company-complete-number ,x))))
        (number-sequence 0 9))
  (define-key map " " (lambda () (interactive)
                         (company-abort)
                         (self-insert-command 1)))
  (define-key map (kbd "<return>") nil))

(provide 'ora-company)
