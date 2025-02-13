(require 'restclient)

(add-to-list 'auto-mode-alist '("\\.rest\\'" . restclient-mode))

;;;###autoload
(defun ora-restclient ()
  "Work with `rest' in the *restclient* buffer."
  (interactive)
  (with-current-buffer (get-buffer-create "*restclient*")
    (restclient-mode)
    (pop-to-buffer (current-buffer))))

(provide 'ora-http)
