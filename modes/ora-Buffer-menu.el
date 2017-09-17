(require 'hydra)
(defhydra hydra-buffer-menu (:color pink
                             :hint nil)
  "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------                        (__)
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch                         (oo)
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch                      /------\\/
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur                 / |    ||
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only^^    *  /\\---/\\
_~_: modified      ^ ^                ^ ^                ^^                                 ~~   ~~
"
  ("m" Buffer-menu-mark)
  ("u" Buffer-menu-unmark)
  ("U" Buffer-menu-backup-unmark)
  ("d" Buffer-menu-delete)
  ("D" Buffer-menu-delete-backwards)
  ("s" Buffer-menu-save)
  ("~" Buffer-menu-not-modified)
  ("x" Buffer-menu-execute)
  ("b" Buffer-menu-bury)
  ("g" revert-buffer)
  ("T" Buffer-menu-toggle-files-only)
  ("O" Buffer-menu-multi-occur :color blue)
  ("I" Buffer-menu-isearch-buffers :color blue)
  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
  ("c" nil "cancel")
  ("v" Buffer-menu-select "select" :color blue)
  ("o" Buffer-menu-other-window "other-window" :color blue)
  ("q" quit-window "quit" :color blue))

(define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body)
(define-key Buffer-menu-mode-map "k" 'previous-line)
(define-key Buffer-menu-mode-map "j" 'next-line)

(define-key bookmark-bmenu-mode-map "k" 'previous-line)
(define-key bookmark-bmenu-mode-map "j" 'next-line)
(define-key bookmark-bmenu-mode-map "s" 'bookmark-bmenu-save)

(setq Buffer-menu-name-width 30)
(setq Buffer-menu-size-width 12)
(setq Buffer-menu-mode-width 18)

;;;###autoload
(defun ora-Buffer-menu-hook ())

;;;###autoload
(defun ora-bmenu-hook ())

(defun list-buffers--format-default (size)
  (if (> size 1000000)
      (let* ((rest (mod size 1000))
             (thousands (/ size 1000))
             (millions (/ thousands 1000))
             (thousands-rest (mod thousands 1000)))
        (format "%d,%03d,%03d" millions thousands-rest rest))
    (number-to-string size)))

(setq list-buffers-buffer-size-function 'list-buffers--format-default)
