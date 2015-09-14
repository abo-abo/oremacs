(require 'ivy)
(setq ivy-display-style 'fancy)

(defhydra hydra-ivy-dired (:hint nil
                           :color red)
  "
^^^^^^          ^Actions^    ^Dired^      ^Quit^
^^^^^^^^^^^^^^------------------------------------------------------
^ ^ _k_ ^ ^     _._ repeat   _m_ark       _i_: cancel  _v_: recenter
_h_ ^✜^ _l_     _r_eplace    _,_ unmark   _o_: quit
^ ^ _j_ ^ ^     _u_ndo       ^ ^          _f_: finish
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
  ("i" nil)
  ("f" ivy-done :exit t))

;; (define-key ivy-minibuffer-map (kbd "C-o") 'ivy-hydra-wrapper)
(define-key ivy-minibuffer-map (kbd "<return>") 'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "C-M-h") 'ivy-previous-line-and-call)
(define-key ivy-minibuffer-map (kbd "C-:") 'ivy-dired)

(defun ivy-hydra-wrapper ()
  (interactive)
  (if ivy--directory
      (ivy-quit-and-run
       (dired ivy--directory)
       (run-at-time nil nil
                    'hydra-ivy-dired/body)
       (swiper ivy-text))
    (hydra-ivy-dired/body)))

(defun ivy-dired ()
  (interactive)
  (if ivy--directory
      (ivy-quit-and-run
       (dired ivy--directory)
       (when (re-search-forward
              (regexp-quote
               (substring ivy--current 0 -1)) nil t)
         (goto-char (match-beginning 0))))
    (user-error
     "Not completing files currently")))

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
