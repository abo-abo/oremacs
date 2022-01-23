(defhydra hydra-k (:exit t :idle 0.8)
  "Misc command launcher."
  ("a" orfu-agenda-day "agenda")
  ("b" org-mark-ring-goto "back" :exit nil)
  ("c" cook "cook :")
  ("d" define-word-at-point "def")
  ("e" ora-ediff-dwim "ediff")
  ("E" eval-expression "eval")
  ("f" hydra--universal-argument "C-u" :exit nil :idle 0.8)
  ("F" ora-flyspell-previous-word "flyspell")
  ("g" counsel-search "incremental search")
  ("G" ora-github "github")
  ;; "h" "i"
  ("j" ora-dired-open-term "jump here")
  ;; "k" "l"
  ("m" hydra-pamparam/body "pamparam")
  ("n" ora-open-wikitionary "wikitionary")
  ("N" ora-open-google-translate "google-translate")
  ("o" ora-toggle-buffer "other")
  ("p" ora-project "project")
  ("P" ora-password "password")
  ("q" nil "quit")
  ("r" flycheck-next-error "errors")
  ("R" counsel-recoll "recoll")
  ("s" hydra-search/body "search")
  ("t" tea-time "tea")
  ("v" hydra-avy/body "avy")
  ("y" avy-copy-region "yank region")
  ("w" plain-org-wiki "wiki")
  ("W" ora-open-wikipedia "wikipedia")
  ("κ" hydra--universal-argument "C-u" :exit nil :idle 0.8))

(autoload 'ora-dired-open-term "ora-dired")
(autoload 'hydra-pamparam/body "pamparam")
(autoload 'hydra-search/body "ora-search")

(defun ora-open-wikitionary ()
  (interactive)
  (browse-url
   (if (eq major-mode 'clojure-mode)
       (let ((str (thing-at-point 'symbol t)))
         (concat "https://clojuredocs.org/clojure.core/"
                 (replace-regexp-in-string "\\?" "_q" str)))
     (concat "https://nl.wiktionary.org/wiki/"
             (ivy-thing-at-point)))))

(defun ora-open-wikipedia ()
  (interactive)
  (browse-url
   (format "https://en.wikipedia.org/wiki/%s"
           (ivy-thing-at-point))))

(defun ora-open-google-translate ()
  (interactive)
  (browse-url
   (format "https://translate.google.com/#nl/en/%s"
           (ivy-thing-at-point))))

(provide 'ora-hydra-k)
