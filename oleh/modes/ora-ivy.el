(require 'ivy)

(defhydra hydra-ivy (:hint nil
                     :color pink)
  "
^^^^^^          ^Actions^    ^Dired^      ^Quit^
^^^^^^^^^^^^^^------------------------------------------------------
^ ^ _k_ ^ ^     _._ repeat   _m_ark       _i_: cancel  _v_: recenter
_h_ ^✜^ _l_     _r_eplace    _,_ unmark   _o_: quit
^ ^ _j_ ^ ^     _u_ndo
"
  ;; arrows
  ("h" ivy-beginning-of-buffer)
  ("j" ivy-next-line)
  ("k" ivy-previous-line)
  ("l" ivy-end-of-buffer)
  ;; actions
  ("." hydra-repeat)
  ("r" ivy-replace)
  ("u" ivy-undo)
  ("v" swiper-recenter-top-bottom)
  ;; dired
  ("m" ivy-dired-mark)
  ("," ivy-dired-unmark)
  ;; exit
  ("o" keyboard-escape-quit :exit t)
  ("i" nil))

(define-key ivy-minibuffer-map (kbd "C-o") 'hydra-ivy/body)
(define-key ivy-minibuffer-map (kbd "<return>") 'ivy-alt-done)

(defun ivy-dired-mark (arg)
  (interactive "p")
  (dotimes (_i arg)
    (with-selected-window swiper--window
      (dired-mark 1))
    (ivy-next-line 1)
    (ivy--exhibit)))

(defun ivy-dired-unmark (arg)
  (interactive "p")
  (dotimes (_i arg)
    (with-selected-window swiper--window
      (dired-unmark 1))
    (ivy-next-line 1)
    (ivy--exhibit)))

(defun ivy-replace ()
  (interactive)
  (let ((from (with-selected-window swiper--window
                (move-beginning-of-line nil)
                (when (re-search-forward
                       (ivy--regex ivy-text) (line-end-position) t)
                  (match-string 0)))))
    (if (null from)
        (user-error "No match")
      (let ((rep (read-string (format "Repace [%s] with: " from))))
        (with-selected-window swiper--window
          (undo-boundary)
          (replace-match rep t t))))))

(defun ivy-undo ()
  (interactive)
  (with-selected-window swiper--window
    (undo)))

(provide 'ora-ivy)
