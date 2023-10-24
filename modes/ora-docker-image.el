(require 'docker-image)

(setq docker-image-columns
      '((:name "Repository"
               :width 65
               :template "{{ json .Repository }}"
               :sort nil
               :format nil)
        (:name "Created"
               :width 20
               :template "{{ json .CreatedAt }}"
               :sort nil
               :format (lambda (x)
                         (format-time-string
                          "%F %T"
                          (date-to-time x))))
        (:name "Size"
               :width 7
               :template "{{ json .Size }}"
               :sort docker-utils-human-size-predicate
               :format nil)
        (:name "Id"
               :width 13
               :template "{{ json .ID }}"
               :sort nil
               :format nil)
        (:name "Tag"
               :width 40
               :template "{{ json .Tag }}"
               :sort nil
               :format nil)))

;;;###autoload
(defun ora-docker-image-hook ())

(define-key tablist-minor-mode-map "j" 'tablist-next-line)
;; `tablist-do-kill-lines'
(define-key tablist-minor-mode-map "k" 'tablist-previous-line)

(provide 'ora-docker-image)
