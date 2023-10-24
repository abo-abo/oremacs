(require 'projectile)
(require 'hydra)

(defhydra hydra-projectile (:color teal
                            :hint nil
                            :body-pre (hydra-set-property 'hydra-projectile :verbosity 0))
  "
%s(projectile-project-root)
  _f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
  _d_: dir             _j_: grep              _b_: switch to buffer  _x_: remove known project
  _r_: recent file     _o_: multi-occur       _K_: Kill all buffers  _X_: cleanup non-existing
"
  ("a" counsel-ag)
  ("b" projectile-switch-to-buffer)
  ("c" projectile-invalidate-cache)
  ("d" projectile-find-dir)
  ("f" projectile-find-file)
  ("j" counsel-git-grep)
  ("i" projectile-ibuffer)
  ("K" projectile-kill-buffers)
  ("o" projectile-multi-occur)
  ("p" projectile-switch-project)
  ("r" projectile-recentf)
  ("x" projectile-remove-known-project)
  ("X" projectile-cleanup-known-projects)
  ("z" projectile-cache-current-file)
  ("q" nil "cancel" :color blue)
  ("C-h" nil)
  ("h" hydra-projectile-more-verbosity :exit nil))

(defun hydra-projectile-more-verbosity ()
  (interactive)
  (if (eq 0 (hydra-get-property 'hydra-projectile :verbosity))
      (hydra-set-property 'hydra-projectile :verbosity 2)))

(global-set-key (kbd "C-h") 'hydra-projectile/body)
(global-set-key (kbd "C-h") nil)


(defun compilation-find-file-projectile-find-compilation-buffer (orig-fun marker filename directory &rest formats)
  "Advice around compilation-find-file.
We enhance its functionality by appending the current project's directories
to its search path. This way when filenames in compilation buffers can't be
found by compilation's normal logic they are searched for in project
directories."
  (let* ((root (projectile-project-root))
         (compilation-search-path
          (cond
           ((equal root "/home/oleh/git/monorepo/")
            '("/home/oleh/git/monorepo/" "/home/oleh/git/monorepo/tools/wavecli/"))
           ((projectile-project-p)
            (append compilation-search-path (list root)
                      (mapcar (lambda (f) (expand-file-name f root))
                              (projectile-current-project-dirs))))
           (t
            compilation-search-path))))
    (apply orig-fun `(,marker ,filename ,directory ,@formats))))
(provide 'ora-projectile)
