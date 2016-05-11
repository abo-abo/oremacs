(require 'helm)
(setq helm-display-header-line nil)
(setq helm-mode-line-string "")
(setq helm-candidate-number-limit 100)
(setq helm-always-two-windows t)

(define-key helm-map (kbd "C-r") 'helm-select-3rd-action)
(define-key helm-map (kbd "M-w") 'helm-save-buffer)
(define-key helm-map (kbd "DEL") 'helm-backspace)
(define-key helm-map (kbd "C-M-n") 'helm-follow-action-forward)
(define-key helm-map (kbd "C-M-h") 'helm-follow-action-backward)
(define-key helm-map (kbd "<escape>") 'helm-like-unite/body)
(define-key helm-map (kbd "C-k") 'helm-like-unite/body)
(define-key helm-map (kbd "C-o") 'helm-like-unite/body)

(defun helm-backspace ()
  "Forward to `backward-delete-char'.
On error (read-only), quit without selecting."
  (interactive)
  (condition-case nil
      (backward-delete-char 1)
    (error
     (helm-keyboard-quit))))

(defun helm-save-buffer ()
  "Save `helm-buffer' contents as new kill."
  (interactive)
  (kill-new (with-current-buffer helm-buffer
              (buffer-string))))

(defhydra helm-like-unite (:hint nil
                           :color pink)
  "
Nav ^^^^^^^^^        Mark ^^          Other ^^       Quit
^^^^^^^^^^------------^^----------------^^----------------------
_K_ ^ ^ _k_ ^ ^     _m_ark           _v_iew         _i_: cancel
^↕^ _h_ ^✜^ _l_     _t_oggle mark    _H_elp         _o_: quit
_J_ ^ ^ _j_ ^ ^     _U_nmark all     _d_elete       _s_: swoop-edit
^^^^^^^^^^                           _f_ollow: %(helm-attr 'follow)
"
  ;; arrows
  ("h" helm-beginning-of-buffer)
  ("j" helm-next-line)
  ("k" helm-previous-line)
  ("l" helm-end-of-buffer)
  ;; beginning/end
  ("g" helm-beginning-of-buffer)
  ("G" helm-end-of-buffer)
  ;; scroll
  ("K" helm-scroll-other-window-down)
  ("J" helm-scroll-other-window)
  ;; mark
  ("m" helm-toggle-visible-mark)
  ("t" helm-toggle-all-marks)
  ("U" helm-unmark-all)
  ;; exit
  ("<escape>" keyboard-escape-quit "" :exit t)
  ("o" keyboard-escape-quit :exit t)
  ("i" nil)
  ;; sources
  ("}" helm-next-source)
  ("{" helm-previous-source)
  ;; rest
  ("H" helm-help)
  ("v" helm-execute-persistent-action)
  ("d" helm-persistent-delete-marked)
  ("f" helm-follow-mode)
  ("s" (progn
         (hydra-keyboard-quit)
         (helm-swoop-edit))
       :exit t))

(defun helm-persistent-delete-marked ()
  "Kill buffer without quitting helm."
  (interactive)
  (if (equal (cdr (assoc 'name (helm-get-current-source)))
             "Buffers")
      (with-helm-alive-p
        (helm-attrset 'kill-action '(helm-persistent-kill-buffers . never-split))
        (helm-execute-persistent-action 'kill-action))
    (user-error "Only works for buffers")))

(defun helm-persistent-kill-buffers (_buffer)
  (unwind-protect
       (dolist (b (helm-marked-candidates))
         (helm-buffers-persistent-kill-1 b))
    (with-helm-buffer
      (setq helm-marked-candidates nil
            helm-visible-mark-overlays nil))
    (helm-force-update (helm-buffers--quote-truncated-buffer
                        (helm-get-selection)))))

(provide 'ora-helm)
