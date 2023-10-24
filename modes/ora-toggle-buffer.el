(defvar ora-toggle-buffer-hook '(ora-toggle-buffer-init))

(defun ora-toggle-buffer-init (fname)
  (cond
   ((string= "init.el" fname)
    "personal/personal-init.el")
   ((string= "personal-init.el" fname)
    "../init.el")
   ((string-match "^ora-\\(.*\\)$" fname)
    (format "../personal/modes/pora-%s" (match-string 1 fname)))
   ((string-match "^pora-\\(.*\\)$" fname)
    (format "../../modes/ora-%s" (match-string 1 fname)))))

(defun ora-toggle-buffer-vc (fname)
  (when vc-parent-buffer
    (buffer-file-name vc-parent-buffer)))

(add-to-list 'ora-toggle-buffer-hook 'ora-toggle-buffer-init)
(add-to-list 'ora-toggle-buffer-hook 'ora-toggle-buffer-vc)

;;;###autoload
(defun ora-toggle-buffer ()
  (interactive)
  (if (null (buffer-file-name))
      (when magit-buffer-revision
        (find-file magit-buffer-file-name))
    (let* ((fname
            (file-name-nondirectory
             (if (eq major-mode 'dired-mode)
                 (directory-file-name default-directory)
               (buffer-file-name))))
           (oname
            (or (run-hook-with-args-until-success
                 'ora-toggle-buffer-hook fname)
                (cond
                 ((and (string-match "\\`test_\\(.*\\.py\\)\\'" fname)
                       (let* ((name (match-string 1 fname))
                              (dir (counsel-locate-git-root))
                              (fs (ivy--filter (format "\\(?:%s\\|\\`%s\\'\\)"
                                                       (concat "/" name) name) (counsel-git-cands dir))))
                         (and (= 1 (length fs))
                              (expand-file-name (car fs) dir)))))
                 ((and (string-match "\\`\\(.*\\.py\\)\\'" fname)
                       (let* ((dir (counsel-locate-git-root))
                              (name (match-string 1 fname))
                              (fs (ivy--filter (concat "/test_" name) (counsel-git-cands dir))))
                         (and (= 1 (length fs))
                              (expand-file-name (car fs) dir)))))))))
      (when oname
        (find-file oname)))))
(provide 'ora-toggle-buffer)
