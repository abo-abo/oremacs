;;

;;;### (autoloads nil "auto" "auto.el" (0 0 0 0))
;;; Generated autoloads from auto.el

(autoload 'ora-para-down "auto" "\


\(fn ARG)" t nil)

(autoload 'ora-para-up "auto" "\


\(fn ARG)" t nil)

(autoload 'ora-move-beginning-of-line "auto" "\


\(fn)" t nil)

(autoload 'ora-open-file-at-point "auto" "\


\(fn EVENT)" t nil)

(autoload 'ora-open-wikipedia "auto" "\


\(fn)" t nil)

(autoload 'ora-c-forward-sexp-function "auto" "\


\(fn ARG)" nil nil)

(autoload 'ora-project "auto" "\


\(fn)" t nil)

(autoload 'ora-occur "auto" "\
Call `occur' with a sane default.

\(fn)" t nil)

(autoload 'ora-query-replace-regex "auto" "\


\(fn FROM)" t nil)

(autoload 'ora-query-replace "auto" "\


\(fn FROM)" t nil)

(autoload 'ora-replace-regexp "auto" "\
Works on current line if there's no region.
When ARG is non-nil launch `query-replace-regexp'.

\(fn ARG)" t nil)

(autoload 'og "auto" "\
Search using ag in a given DIRECTORY for a given search STRING,
with STRING defaulting to the symbol under point.

If called with a prefix, prompts for flags to pass to ag.

\(fn STRING DIRECTORY)" t nil)

(autoload 'ora-unfill-paragraph "auto" "\
Transform a paragraph into a single line.

\(fn)" t nil)

(autoload 'ora-ctrltab "auto" "\
List buffers and give it focus.

\(fn)" t nil)

(autoload 'ora-terminal "auto" "\
Switch to terminal. Launch if nonexistent.

\(fn)" t nil)

(autoload 'ora-goto-hook-file "auto" "\
Opens hooks.el at point specific to current `major-mode'

\(fn)" t nil)

(autoload 'ora-dired-rsync "auto" "\


\(fn DEST)" t nil)

(autoload 'ora-describe-keys "auto" "\


\(fn)" t nil)

(autoload 'illiterate "auto" "\
Useful to completely revert an `org-mode' file.

\(fn)" t nil)

(autoload 'melpa "auto" "\


\(fn)" t nil)

(autoload 'ora-test-emacs "auto" "\


\(fn)" t nil)

(autoload 'ora-figlet-region "auto" "\


\(fn &optional B E)" t nil)

(autoload 'ora-reinit-semantic "auto" "\


\(fn)" t nil)

(autoload 'ora-nw-yank "auto" "\


\(fn)" t nil)

(autoload 'ora-install-gcl "auto" "\


\(fn)" t nil)

(autoload 'bmk/magit-status "auto" "\
Bookmark for `magit-status'.

\(fn)" t nil)

(autoload 'bmk/scratch "auto" "\
Bookmark for *scratch*.

\(fn)" t nil)

(autoload 'bmk/function "auto" "\
Handle a function bookmark BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'ora-flyspell-previous-word "auto" "\
Correct the first misspelled word that occurs before point.
But don't look beyond what's visible on the screen.

\(fn)" t nil)

(autoload 'ora-ediff-buffers "auto" "\


\(fn)" t nil)

(autoload 'ora-org-to-html-to-clipboard "auto" "\
Export region to HTML, and copy it to the clipboard.

\(fn)" t nil)

(autoload 'ora-eval-other-window "auto" "\
Eval current expression in the context of other window.
Expression has to be of type (setq X BODY)
In case 'setq isn't present, add it.

\(fn ARG123)" t nil)

(autoload 'ora-describe-hash "auto" "\
Display the full documentation of VARIABLE (a symbol).
Returns the documentation as a string, also.
If VARIABLE has a buffer-local value in BUFFER (default to the current buffer),
it is displayed along with the global value.

\(fn VARIABLE &optional BUFFER)" t nil)

(autoload 'ora-toggle-window-dedicated "auto" "\


\(fn)" t nil)

(autoload 'update-all-autoloads "auto" "\


\(fn)" t nil)

(autoload 'align-cols "auto" "\
Align text between point and mark as columns.
Columns are separated by whitespace characters.
Prefix arg means align that many columns. (default is all)

\(fn START END MAX-COLS)" t nil)

(autoload 'ora-comment-and-insert "auto" "\


\(fn)" t nil)

(autoload 'ora-dired-org-to-pdf "auto" "\


\(fn)" t nil)

(autoload 'ora-org-clock-out "auto" "\


\(fn)" t nil)

(autoload 'wmctrl-720p "auto" "\


\(fn)" t nil)

(autoload 'ora-kill-current-buffer "auto" "\


\(fn)" t nil)

(autoload 'ora-save-and-switch-buffer "auto" "\


\(fn &optional ARG)" t nil)

(autoload 'youtube-dl "auto" "\


\(fn)" t nil)

(autoload 'ora-directory-parent "auto" "\
Return parent of directory DIR.

\(fn DIR)" nil nil)

(autoload 'ora-pretty-things "auto" "\
Compose chars according to `ora-pretty-alist'.

\(fn)" nil nil)

(autoload 'ora-fontify-glyph "auto" "\


\(fn ITEM GLYPH)" nil nil)

(autoload 'ora-elisp-follow "auto" "\
Jump to the definition of the function (or variable) at point.

\(fn NAME)" t nil)

(autoload 'capitalize-word-toggle "auto" "\


\(fn)" t nil)

(autoload 'upcase-word-toggle "auto" "\


\(fn)" t nil)

(autoload 'named-term "auto" "\


\(fn NAME)" t nil)

(autoload 'jekyll-serve "auto" "\


\(fn)" t nil)

(autoload 'sudired "auto" "\


\(fn)" t nil)

(autoload 'ora-insert-date "auto" "\
Insert DATE using the current locale.

\(fn DATE)" t nil)

(autoload 'ora-insert-date-from "auto" "\
Insert date that is DAYS from current.

\(fn &optional DAYS)" t nil)

(autoload 'ora-set-transparency "auto" "\


\(fn ALPHA-LEVEL)" t nil)

(autoload 'ora-hide-ctrl-M "auto" "\
Hides the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings.

\(fn)" t nil)

(autoload 'ora-lookup-key "auto" "\


\(fn KEY)" nil nil)

(autoload 'ora-pretty-quote-glyphs "auto" "\


\(fn)" nil nil)

(defadvice kill-compilation (after ora-disable-compiling-message activate) (setq compilation-in-progress nil))

(autoload 'ora-custom-setq "auto" "\
Set a custom variable, with completion.

\(fn)" t nil)

(autoload 'ora-quote-github-issues "auto" "\


\(fn)" t nil)

(autoload 'ora-rename-pdf-bibtex "auto" "\


\(fn)" t nil)

(autoload 'ora-start-process "auto" "\


\(fn CMD)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "auto" '("ora-" "char-upcasep" "re-seq")))

;;;***

;;;### (autoloads nil "hooks" "hooks.el" (0 0 0 0))
;;; Generated autoloads from hooks.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hooks" '("conditionally-enable-lispy" "cal" "ora-" "lisp--match-hidden-arg")))

;;;***

;;;### (autoloads nil "init" "init.el" (0 0 0 0))
;;; Generated autoloads from init.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "init" '(#("emacs-d" 0 1 (fontified nil) 1 7 (fontified nil face font-lock-variable-name-face)) #("eldoc-mode" 0 1 (fontified nil) 1 10 (fontified nil)) #("yes-or-no-p" 0 11 (face font-lock-function-name-face fontified nil)) #("csetq" 0 4 (face font-lock-function-name-face fontified nil) 4 5 (face font-lock-function-name-face fontified nil)))))

;;;***

;;;### (autoloads nil "ins" "ins.el" (22966 43645 358429 797000))
;;; Generated autoloads from ins.el

(autoload 'ora-quotes "ins" "\


\(fn ARG)" t nil)

(autoload 'ora-single-quotes "ins" "\


\(fn ARG)" t nil)

(autoload 'ora-parens "ins" "\


\(fn)" t nil)

(autoload 'ora-dollars "ins" "\


\(fn)" t nil)

(autoload 'ora-brackets "ins" "\


\(fn)" t nil)

(autoload 'ora-braces "ins" "\


\(fn)" t nil)

(autoload 'ora-braces-c++ "ins" "\
Insert {}.
Threat is as function body when from endline before )

\(fn)" t nil)

(autoload 'ora-angles-c++ "ins" "\


\(fn)" t nil)

(autoload 'ora-angles "ins" "\


\(fn)" t nil)

;;;***

;;;### (autoloads nil "keys" "keys.el" (0 0 0 0))
;;; Generated autoloads from keys.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "keys" '("hydra-")))

;;;***

;;;### (autoloads nil "modes/ora-Buffer-menu" "modes/ora-Buffer-menu.el"
;;;;;;  (22951 58495 391626 76000))
;;; Generated autoloads from modes/ora-Buffer-menu.el

(autoload 'ora-Buffer-menu-hook "modes/ora-Buffer-menu" "\


\(fn)" nil nil)

(autoload 'ora-bmenu-hook "modes/ora-Buffer-menu" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-Info" "modes/ora-Info.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-Info.el

(autoload 'ora-Info-hook "modes/ora-Info" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-Info" '("hydra-info-to" "ora-open-info")))

;;;***

;;;### (autoloads nil "modes/ora-archive" "modes/ora-archive.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-archive.el

(autoload 'ora-archive-hook "modes/ora-archive" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-avy" "modes/ora-avy.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-avy.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-avy" '("hydra-avy")))

;;;***

;;;### (autoloads nil "modes/ora-c++" "modes/ora-c++.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-c++.el

(autoload 'ora-cc-magic-tab "modes/ora-c++" "\


\(fn)" t nil)

(autoload 'ora-c-common-hook "modes/ora-c++" "\


\(fn)" nil nil)

(autoload 'ora-c-hook "modes/ora-c++" "\


\(fn)" nil nil)

(autoload 'ora-c++-hook "modes/ora-c++" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-c++" '("boost-test-name" "hydra-gud" "ora-c++-to-gud" "semantic-mode" "tomtom-set-c-style" "emacs-src-dir")))

;;;***

;;;### (autoloads nil "modes/ora-cider" "modes/ora-cider.el" (22079
;;;;;;  50170 0 0))
;;; Generated autoloads from modes/ora-cider.el

(autoload 'ora-cider-hook "modes/ora-cider" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-clojure" "modes/ora-clojure.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-clojure.el

(autoload 'ora-clojure-hook "modes/ora-clojure" "\


\(fn)" nil nil)

(autoload '4clojure-login "modes/ora-clojure" "\
Log in to http://www.4clojure.com.

\(fn USER PWD)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-clojure" '("clojure-ampersand")))

;;;***

;;;### (autoloads nil "modes/ora-compilation" "modes/ora-compilation.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-compilation.el

(autoload 'ora-compilation-hook "modes/ora-compilation" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-compilation" '("ora-compilation-")))

;;;***

;;;### (autoloads nil "modes/ora-dired" "modes/ora-dired.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-dired.el

(autoload 'ora-dired-hook "modes/ora-dired" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-dired" '("oda-dired-terminal" "ora-" "hydra-marked-items")))

;;;***

;;;### (autoloads nil "modes/ora-doc-view" "modes/ora-doc-view.el"
;;;;;;  (22781 51118 0 0))
;;; Generated autoloads from modes/ora-doc-view.el

(autoload 'ora-doc-view-hook "modes/ora-doc-view" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ediff" "modes/ora-ediff.el" (22801
;;;;;;  64348 0 0))
;;; Generated autoloads from modes/ora-ediff.el

(autoload 'ora-ediff-hook "modes/ora-ediff" "\


\(fn)" nil nil)

(autoload 'ora-diff-hook "modes/ora-ediff" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-eltex" "modes/ora-eltex.el" (22079
;;;;;;  50170 0 0))
;;; Generated autoloads from modes/ora-eltex.el

(autoload 'ora-eltex-hook "modes/ora-eltex" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ert" "modes/ora-ert.el" (22079 50170
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-ert.el

(autoload 'ora-ert-results-hook "modes/ora-ert" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-eshell" "modes/ora-eshell.el" (22928
;;;;;;  41656 348654 97000))
;;; Generated autoloads from modes/ora-eshell.el

(autoload 'ora-eshell-hook "modes/ora-eshell" "\


\(fn)" nil nil)

(autoload 'eshell-this-dir "modes/ora-eshell" "\
Open or move eshell in `default-directory'.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-eww" "modes/ora-eww.el" (22323 15688
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-eww.el

(autoload 'ora-eww-hook "modes/ora-eww" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-gnus" "modes/ora-gnus.el" (22781
;;;;;;  51118 0 0))
;;; Generated autoloads from modes/ora-gnus.el

(autoload 'ora-gnus-group-hook "modes/ora-gnus" "\


\(fn)" nil nil)

(autoload 'ora-gnus-summary-hook "modes/ora-gnus" "\


\(fn)" nil nil)

(autoload 'ora-message-hook "modes/ora-gnus" "\


\(fn)" nil nil)

(autoload 'ora-gnus-article-hook "modes/ora-gnus" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-groovy" "modes/ora-groovy.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-groovy.el

(autoload 'ora-groovy-hook "modes/ora-groovy" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-help" "modes/ora-help.el" (22293
;;;;;;  7028 0 0))
;;; Generated autoloads from modes/ora-help.el

(autoload 'ora-help-hook "modes/ora-help" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-hy" "modes/ora-hy.el" (22323 17238
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-hy.el

(autoload 'ora-hy-hook "modes/ora-hy" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ibuffer" "modes/ora-ibuffer.el"
;;;;;;  (22540 26546 0 0))
;;; Generated autoloads from modes/ora-ibuffer.el

(autoload 'ora-ibuffer-hook "modes/ora-ibuffer" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-image" "modes/ora-image.el" (22781
;;;;;;  51118 0 0))
;;; Generated autoloads from modes/ora-image.el

(autoload 'ora-image-hook "modes/ora-image" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ivy" "modes/ora-ivy.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-ivy.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-ivy" '("ivy-")))

;;;***

;;;### (autoloads nil "modes/ora-j" "modes/ora-j.el" (22242 57802
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-j.el

(autoload 'j-setup-shortcuts "modes/ora-j" "\
Assign shortcuts for J.

\(fn)" t nil)

(autoload 'ora-j-hook "modes/ora-j" "\
Hook for J modes.

\(fn)" nil nil)

(autoload 'run-j "modes/ora-j" "\
Call `j-console' and setup shortcuts.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-java" "modes/ora-java.el" (22767
;;;;;;  28800 0 0))
;;; Generated autoloads from modes/ora-java.el

(autoload 'ora-java-hook "modes/ora-java" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-javascript" "modes/ora-javascript.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-javascript.el

(autoload 'ora-javascript-hook "modes/ora-javascript" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-javascript" '("javascript-candidates" "js-" "refresh-javascript-candidates" "ac-source-javascript" "keyword-function")))

;;;***

;;;### (autoloads nil "modes/ora-latex" "modes/ora-latex.el" (22781
;;;;;;  51118 0 0))
;;; Generated autoloads from modes/ora-latex.el

(autoload 'ora-latex-hook "modes/ora-latex" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-lisp" "modes/ora-lisp.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-lisp.el

(autoload 'ora-lisp-hook "modes/ora-lisp" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-magit" "modes/ora-magit.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-magit.el

(autoload 'ora-magit-status-hook "modes/ora-magit" "\


\(fn)" nil nil)

(autoload 'ora-magit-log-hook "modes/ora-magit" "\


\(fn)" nil nil)

(autoload 'ora-magit-commit-hook "modes/ora-magit" "\


\(fn)" nil nil)

(autoload 'ora-magit-diff-hook "modes/ora-magit" "\


\(fn)" nil nil)

(autoload 'ora-magit-branch-manager-hook "modes/ora-magit" "\


\(fn)" nil nil)

(autoload 'ora-git-commit-hook "modes/ora-magit" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-magit" '("ora-" "endless/add-PR-fetch")))

;;;***

;;;### (autoloads nil "modes/ora-makefile" "modes/ora-makefile.el"
;;;;;;  (22904 26664 297746 883000))
;;; Generated autoloads from modes/ora-makefile.el

(autoload 'ora-makefile-hook "modes/ora-makefile" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-markdown" "modes/ora-markdown.el"
;;;;;;  (22242 57802 0 0))
;;; Generated autoloads from modes/ora-markdown.el

(autoload 'ora-markdown-hook "modes/ora-markdown" "\


\(fn)" nil nil)

(autoload 'ora-markdown-cleanup "modes/ora-markdown" "\
Transform Elisp-style code references to Markdown-style.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-matlab" "modes/ora-matlab.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-matlab.el

(autoload 'ora-matlab-shell-hook "modes/ora-matlab" "\


\(fn)" nil nil)

(autoload 'counsel-matlab "modes/ora-matlab" "\
MATLAB completion at point.

\(fn)" t nil)

(autoload 'ora-matlab-hook "modes/ora-matlab" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-matlab" '("matlab-" "org-babel-execute:matlab" "ora-matlab-")))

;;;***

;;;### (autoloads nil "modes/ora-mu4e" "modes/ora-mu4e.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-mu4e.el

(autoload 'ora-toggle-email-from "modes/ora-mu4e" "\


\(fn)" t nil)

(autoload 'ora-mu4e-headers-hook "modes/ora-mu4e" "\


\(fn)" nil nil)

(autoload 'ora-mu4e-compose-hook "modes/ora-mu4e" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-nextmagit" "modes/ora-nextmagit.el"
;;;;;;  (22242 57802 0 0))
;;; Generated autoloads from modes/ora-nextmagit.el

(autoload 'ora-nextmagit-status-hook "modes/ora-nextmagit" "\


\(fn)" nil nil)

(autoload 'ora-nextmagit-log-hook "modes/ora-nextmagit" "\


\(fn)" nil nil)

(autoload 'ora-nextmagit-commit-hook "modes/ora-nextmagit" "\


\(fn)" nil nil)

(autoload 'ora-nextmagit-diff-hook "modes/ora-nextmagit" "\


\(fn)" nil nil)

(autoload 'ora-nextmagit-branch-manager-hook "modes/ora-nextmagit" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-nxml" "modes/ora-nxml.el" (22344
;;;;;;  9168 0 0))
;;; Generated autoloads from modes/ora-nxml.el

(autoload 'ora-nxml-hook "modes/ora-nxml" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-occur" "modes/ora-occur.el" (22079
;;;;;;  50172 0 0))
;;; Generated autoloads from modes/ora-occur.el

(autoload 'ora-occur-mode-hook "modes/ora-occur" "\


\(fn)" nil nil)

(autoload 'ora-occur-hook "modes/ora-occur" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-octave" "modes/ora-octave.el" (22378
;;;;;;  40663 342591 422000))
;;; Generated autoloads from modes/ora-octave.el

(autoload 'ora-octave-hook "modes/ora-octave" "\


\(fn)" nil nil)

(autoload 'octave-script "modes/ora-octave" "\


\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-org" "modes/ora-org.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-org.el

(autoload 'ora-org-hook "modes/ora-org" "\


\(fn)" nil nil)

(autoload 'ora-org-agenda-hook "modes/ora-org" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-org" '("org-" "ora-" "hot-expand" "hydra-org-")))

;;;***

;;;### (autoloads nil "modes/ora-package-menu" "modes/ora-package-menu.el"
;;;;;;  (22079 50170 0 0))
;;; Generated autoloads from modes/ora-package-menu.el

(autoload 'ora-package-menu-hook "modes/ora-package-menu" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-pdf-view" "modes/ora-pdf-view.el"
;;;;;;  (22245 43522 0 0))
;;; Generated autoloads from modes/ora-pdf-view.el

(autoload 'ora-pdf-view-hook "modes/ora-pdf-view" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-proced" "modes/ora-proced.el" (22121
;;;;;;  31400 0 0))
;;; Generated autoloads from modes/ora-proced.el

(autoload 'ora-proced-hook "modes/ora-proced" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-python" "modes/ora-python.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-python.el

(autoload 'ora-python-hook "modes/ora-python" "\


\(fn)" nil nil)

(autoload 'ora-inferior-python-hook "modes/ora-python" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-python" '("ora-" "python-newline-dedent")))

;;;***

;;;### (autoloads nil "modes/ora-ruby" "modes/ora-ruby.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-ruby.el

(autoload 'ora-ruby-hook "modes/ora-ruby" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-ruby" '("ora-ruby-")))

;;;***

;;;### (autoloads nil "modes/ora-scheme" "modes/ora-scheme.el" (22753
;;;;;;  1116 0 0))
;;; Generated autoloads from modes/ora-scheme.el

(autoload 'ora-scheme-hook "modes/ora-scheme" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-sh" "modes/ora-sh.el" (22893 47882
;;;;;;  634573 926000))
;;; Generated autoloads from modes/ora-sh.el

(autoload 'ora-sh-hook "modes/ora-sh" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-shell" "modes/ora-shell.el" (23005
;;;;;;  52835 905978 515000))
;;; Generated autoloads from modes/ora-shell.el

(autoload 'ora-shell-hook "modes/ora-shell" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-sml" "modes/ora-sml.el" (22781 51118
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-sml.el

(autoload 'ora-sml-hook "modes/ora-sml" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-tar" "modes/ora-tar.el" (22079 50170
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-tar.el

(autoload 'ora-tar-hook "modes/ora-tar" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-term" "modes/ora-term.el" (22427
;;;;;;  30434 0 0))
;;; Generated autoloads from modes/ora-term.el

(autoload 'ora-term-exec-hook "modes/ora-term" "\


\(fn)" nil nil)

(autoload 'ora-term-hook "modes/ora-term" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-text" "modes/ora-text.el" (22395
;;;;;;  32024 0 0))
;;; Generated autoloads from modes/ora-text.el

(autoload 'ora-text-hook "modes/ora-text" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-vc-dir" "modes/ora-vc-dir.el" (22348
;;;;;;  29176 0 0))
;;; Generated autoloads from modes/ora-vc-dir.el

(autoload 'ora-vc-dir-hook "modes/ora-vc-dir" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "packages" "packages.el" (0 0 0 0))
;;; Generated autoloads from packages.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "packages" '("ora-packages" "emacs-d")))

;;;***

;;;### (autoloads nil nil ("modes/ora-company.el" "modes/ora-elisp-style-guide.el"
;;;;;;  "modes/ora-helm.el" "modes/ora-projectile.el") (0 0 0 0))

;;;***

;;;### (autoloads nil "git/org-fu/org-fu" "git/org-fu/org-fu.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from git/org-fu/org-fu.el

(autoload 'orfu-agenda-quick "git/org-fu/org-fu" "\


\(fn)" t nil)

(autoload 'orfu-agenda-office "git/org-fu/org-fu" "\


\(fn)" t nil)

(autoload 'orfu-agenda-day "git/org-fu/org-fu" "\


\(fn)" t nil)

(autoload 'orfu-agenda-articles "git/org-fu/org-fu" "\


\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "git/org-fu/org-fu" '("orfu-")))

;;;***
