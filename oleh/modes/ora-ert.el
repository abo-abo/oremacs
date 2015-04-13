(require 'ert)

(define-key ert-results-mode-map "J"
  'ert-results-jump-between-summary-and-result)
(define-key ert-results-mode-map "j" 'ert-results-next-test)
(define-key ert-results-mode-map "n" nil)
(define-key ert-results-mode-map "k" 'ert-results-previous-test)
(define-key ert-results-mode-map "p" nil)
(define-key ert-results-mode-map "o" 'ace-link-help)
(define-key ert-results-mode-map "H"
  'ert-results-describe-test-at-point)
(define-key ert-results-mode-map "h" 'backward-char)
(define-key ert-results-mode-map "s"
  'ert-results-pop-to-should-forms-for-test-at-point)
(define-key ert-results-mode-map "l"
  'forward-char)

;;;###autoload
(defun ora-ert-results-hook ())
