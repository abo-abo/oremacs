(require 'flyspell)

(define-key flyspell-mode-map [(control ?\,)] nil)
(define-key flyspell-mode-map [(control ?\;)] nil)
(define-key flyspell-mode-map (kbd "C-.") nil)
(define-key flyspell-mode-map (kbd "C-M-i") nil)
(setq flyspell-auto-correct-binding (kbd "C-M-;"))

(dolist (mode '(text-mode erc-mode))
  (put mode 'flyspell-mode-predicate 'flyspell-ignore-http-and-https))

(defun flyspell-ignore-http-and-https ()
  "Function used for `flyspell-generic-check-word-predicate' to ignore stuff starting with \"http\" or \"https\"."
  (save-excursion
    (forward-whitespace -1)
    (when (looking-at " ")
      (forward-char)
      (not (looking-at "https?\\b")))))

;;;###autoload
(defun ora-flyspell-previous-word ()
  "Correct the first misspelled word that occurs before point.
But don't look beyond what's visible on the screen."
  (interactive)
  (let ((diff (- (point-max) (point))))
    (save-restriction
      (narrow-to-region (window-start) (window-end))
      (overlay-recenter (point))
      (let ((overlay-list (overlays-in (point-min) (point)))
            (new-overlay 'dummy-value))
        ;; search for previous (new) flyspell overlay
        (while (and new-overlay
                    (or (not (flyspell-overlay-p new-overlay))
                        ;; check if its face has changed
                        ;; (not (eq (get-char-property
                        ;;           (overlay-start new-overlay) 'face)
                        ;;          '(flyspell-incorrect flyspell-duplicate)))
                        ))
          (setq new-overlay (car-safe overlay-list))
          (setq overlay-list (cdr-safe overlay-list)))
        ;; if nothing new exits new-overlay should be nil
        (when new-overlay
          (goto-char (overlay-start new-overlay))
          (flyspell-correct-word-before-point))))
    (goto-char (- (point-max) diff))))

(provide 'ora-flyspell)
