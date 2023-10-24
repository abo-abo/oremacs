(defhydra hydra-k (:exit t :idle 0.8)
  "Misc command launcher."
  ("a" orfu-agenda-day "agenda")
  ("b" (cook '(16)) "book")
  ("c" cook "cook")
  ("d" (cook '(4)) "cook :")
  ("D" docker "docker")
  ("E" eval-expression "eval")
  ("f" hydra-flycheck/body "flycheck")
  ("g" hydra-git/body "git")

  ;; "h" "i"
  ("i" ora-accentize)
  ("j" ora-dired-open-term "jump here")
  ;; "k"
  ("l" hydra-link/body "link")
  ("m" hydra-pamparam/body "pamparam")
  ;; n
  ("o" ora-toggle-buffer "other")
  ("p" ora-project "project")
  ("P" ora-password "password")
  ("q" nil "quit")
  ("r" flycheck-next-error "errors")
  ("R" counsel-recoll "recoll")
  ("s" hydra-search/body "search")
  ("t" tea-time "tea")
  ("v" hydra-avy/body "avy")
  ;; ("y" avy-copy-region "yank region")
  ("y" (insert lispy-last-message) "yank-eval")
  ("W" plain-org-wiki "wiki")
  ("wf" ora-flyspell-previous-word "flyspell")
  ("wd" define-word-at-point "def")
  ("ww" ora-open-wikipedia "wikipedia")
  ("wn" ora-open-wikitionary "wikitionary")
  ("wN" ora-open-google-translate "google-translate")
  ("κ" hydra--universal-argument "C-u" :exit nil :idle 0.8))

(defhydra hydra-flycheck (:exit t)
  ("f" flycheck-mode "toggle")
  ("l" flycheck-list-errors "list")
  ("n" flycheck-next-error "next"))

(defhydra hydra-link (:exit t)
  ("g" git-link "github")
  ("o" org-store-link "org")
  ("p" orly-py-store-link "py"))

(autoload 'ora-dired-open-term "ora-dired")
(autoload 'hydra-pamparam/body "pamparam")
(autoload 'hydra-search/body "ora-search")

(defun ora-open-wikipedia ()
  (interactive)
  (browse-url
   (format "https://en.wikipedia.org/wiki/%s"
           (ivy-thing-at-point))))


(defvar ora-current-foreign-language "pt"
  "iso2 of the current foreign language I'm learning.")

(defun ora-open-wikitionary (arg)
  (interactive "p")
  (let ((word (ivy-thing-at-point)))
    (if (eq arg 2)
        (browse-url
         (concat "https://"
                 ora-current-foreign-language
                 ".wiktionary.org/wiki/"
                 word))
      (browse-url
       (concat "https://www.dict.com/португальсько-украінськии/"
               word)))))

(defun ora-open-google-translate ()
  (interactive)
  (browse-url
   (format "https://translate.google.com/#%s/en/%s"
           ora-current-foreign-language
           (ivy-thing-at-point))))

(defvar ora-portuguese-accents '((?a ?á ?ã ?â ?à)
                                 (?c ?ç)
                                 (?e ?é ?ê)
                                 (?i ?í)
                                 (?o ?ó ?õ ?ô)
                                 (?u ?ú)))

(defun ora-accentize ()
  (interactive)
  (let* ((cb (char-before))
         (c (downcase cb))
         (accents (mapcar #'string (cdr (assoc c ora-portuguese-accents))))
         (accent
          (if (cdr accents)
              (ivy-read "a: " accents)
            (car accents))))
    (delete-char -1)
    (insert (if (= c cb)
                accent
              (upcase accent)))))

(provide 'ora-hydra-k)
