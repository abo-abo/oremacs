(require 'info)
(setq Info-additional-directory-list
      (list (expand-file-name "etc/info/" emacs-d)))

(define-key Info-mode-map "w" 'forward-word)
(define-key Info-mode-map "b" 'backward-word)
(define-key Info-mode-map "t" 'hydra-info-to/body)
(define-key Info-mode-map "u" 'Info-history-back)
(define-key Info-mode-map "c" 'counsel-ace-link)
(define-key Info-mode-map "H" 'Info-history-back)

;;;###autoload
(defun ora-Info-hook ())

(defun ora-open-info (topic bname)
  "Open info on TOPIC in BNAME."
  (if (get-buffer bname)
      (progn
        (switch-to-buffer bname)
        (unless (string-match topic Info-current-file)
          (Info-goto-node (format "(%s)" topic))))
    (info topic bname)))

(defhydra hydra-info-to (:hint nil :color teal)
  "
_o_rg e_l_isp _e_macs _h_yperspec"
  ("o" (ora-open-info "org" "*org info*"))
  ("l" (ora-open-info "elisp" "*elisp info*"))
  ("e" (ora-open-info "emacs" "*emacs info*"))
  ("h" (ora-open-info "gcl" "*hyperspec*")))

(require 'pora-Info nil t)
