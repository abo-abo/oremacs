(setq paradox-column-width-version 14)
(setq paradox-column-width-package 30)

(define-key package-menu-mode-map "j" 'next-line)
(define-key package-menu-mode-map "k" 'previous-line)

;;;###autoload
(defun ora-package-menu-hook ()
  (setq tabulated-list-format
        [("Package" 28 package-menu--name-predicate)
         ("Version" 18 nil)
         ("Status" 10 package-menu--status-predicate)
         ("Description" 50 nil)])
  (tabulated-list-init-header))

