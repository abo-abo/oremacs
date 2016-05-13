;;

;;;### (autoloads nil "auto" "auto.el" (22323 16071 484876 153000))
;;; Generated autoloads from auto.el

(autoload 'ora-para-down "auto" "\


\(fn ARG)" t nil)

(autoload 'ora-para-up "auto" "\


\(fn ARG)" t nil)

(autoload 'ora-move-beginning-of-line "auto" "\


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

(autoload 'ora-rename-pdf "auto" "\


\(fn)" t nil)

(autoload 'ora-start-process "auto" "\


\(fn CMD)" nil nil)

;;;***

;;;### (autoloads nil "ins" "ins.el" (22242 50602 852531 947000))
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

;;;### (autoloads nil "modes/ora-Buffer-menu" "modes/ora-Buffer-menu.el"
;;;;;;  (22079 42971 993460 914000))
;;; Generated autoloads from modes/ora-Buffer-menu.el

(autoload 'ora-Buffer-menu-hook "modes/ora-Buffer-menu" "\


\(fn)" nil nil)

(autoload 'ora-bmenu-hook "modes/ora-Buffer-menu" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-Info" "modes/ora-Info.el" (22323
;;;;;;  14431 500933 263000))
;;; Generated autoloads from modes/ora-Info.el

(autoload 'ora-Info-hook "modes/ora-Info" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-c++" "modes/ora-c++.el" (22323 14431
;;;;;;  496933 263000))
;;; Generated autoloads from modes/ora-c++.el

(autoload 'ora-c-common-hook "modes/ora-c++" "\


\(fn)" nil nil)

(autoload 'ora-c-hook "modes/ora-c++" "\


\(fn)" nil nil)

(autoload 'ora-c++-hook "modes/ora-c++" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-cider" "modes/ora-cider.el" (22079
;;;;;;  42971 977460 915000))
;;; Generated autoloads from modes/ora-cider.el

(autoload 'ora-cider-hook "modes/ora-cider" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-clojure" "modes/ora-clojure.el"
;;;;;;  (22246 41631 0 0))
;;; Generated autoloads from modes/ora-clojure.el

(autoload 'ora-clojure-hook "modes/ora-clojure" "\


\(fn)" nil nil)

(autoload '4clojure-login "modes/ora-clojure" "\
Log in to http://www.4clojure.com.

\(fn USER PWD)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-dired" "modes/ora-dired.el" (22323
;;;;;;  14431 496933 263000))
;;; Generated autoloads from modes/ora-dired.el

(autoload 'ora-dired-hook "modes/ora-dired" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-doc-view" "modes/ora-doc-view.el"
;;;;;;  (22079 42971 949460 916000))
;;; Generated autoloads from modes/ora-doc-view.el

(autoload 'ora-doc-view-hook "modes/ora-doc-view" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ediff" "modes/ora-ediff.el" (22323
;;;;;;  8489 465140 186000))
;;; Generated autoloads from modes/ora-ediff.el

(autoload 'ora-ediff-hook "modes/ora-ediff" "\


\(fn)" nil nil)

(autoload 'ora-diff-hook "modes/ora-ediff" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-elfeed" "modes/ora-elfeed.el" (22079
;;;;;;  42971 937460 916000))
;;; Generated autoloads from modes/ora-elfeed.el

(autoload 'ora-elfeed-search-hook "modes/ora-elfeed" "\


\(fn)" nil nil)

(autoload 'ora-elfeed-show-hook "modes/ora-elfeed" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-eltex" "modes/ora-eltex.el" (22079
;;;;;;  42971 961460 915000))
;;; Generated autoloads from modes/ora-eltex.el

(autoload 'ora-eltex-hook "modes/ora-eltex" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ert" "modes/ora-ert.el" (22079 42971
;;;;;;  965460 915000))
;;; Generated autoloads from modes/ora-ert.el

(autoload 'ora-ert-results-hook "modes/ora-ert" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-eshell" "modes/ora-eshell.el" (22079
;;;;;;  42972 33460 912000))
;;; Generated autoloads from modes/ora-eshell.el

(autoload 'eshell-this-dir "modes/ora-eshell" "\
Open or move eshell in `default-directory'.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-eww" "modes/ora-eww.el" (22323 8489
;;;;;;  465140 186000))
;;; Generated autoloads from modes/ora-eww.el

(autoload 'ora-eww-hook "modes/ora-eww" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-gnus" "modes/ora-gnus.el" (22079
;;;;;;  42972 21460 912000))
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

;;;### (autoloads nil "modes/ora-help" "modes/ora-help.el" (22292
;;;;;;  65364 741907 822000))
;;; Generated autoloads from modes/ora-help.el

(autoload 'ora-help-hook "modes/ora-help" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-hy" "modes/ora-hy.el" (22323 10039
;;;;;;  153086 221000))
;;; Generated autoloads from modes/ora-hy.el

(autoload 'ora-hy-hook "modes/ora-hy" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ido" "modes/ora-ido.el" (22238 57974
;;;;;;  281404 52000))
;;; Generated autoloads from modes/ora-ido.el

(autoload 'ora-ido-hook "modes/ora-ido" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-j" "modes/ora-j.el" (22242 50602
;;;;;;  852531 947000))
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

;;;### (autoloads nil "modes/ora-java" "modes/ora-java.el" (22079
;;;;;;  42971 953460 916000))
;;; Generated autoloads from modes/ora-java.el

(autoload 'ora-java-hook "modes/ora-java" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-javascript" "modes/ora-javascript.el"
;;;;;;  (22141 6958 965688 365000))
;;; Generated autoloads from modes/ora-javascript.el

(autoload 'ora-javascript-hook "modes/ora-javascript" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-latex" "modes/ora-latex.el" (22079
;;;;;;  42971 933460 917000))
;;; Generated autoloads from modes/ora-latex.el

(autoload 'ora-latex-hook "modes/ora-latex" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-lisp" "modes/ora-lisp.el" (22323
;;;;;;  14431 496933 263000))
;;; Generated autoloads from modes/ora-lisp.el

(autoload 'ora-lisp-hook "modes/ora-lisp" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-magit" "modes/ora-magit.el" (22323
;;;;;;  12016 341017 368000))
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

;;;***

;;;### (autoloads nil "modes/ora-makefile" "modes/ora-makefile.el"
;;;;;;  (22079 42971 997460 914000))
;;; Generated autoloads from modes/ora-makefile.el

(autoload 'ora-makefile-hook "modes/ora-makefile" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-markdown" "modes/ora-markdown.el"
;;;;;;  (22242 50603 28531 941000))
;;; Generated autoloads from modes/ora-markdown.el

(autoload 'ora-markdown-hook "modes/ora-markdown" "\


\(fn)" nil nil)

(autoload 'ora-markdown-cleanup "modes/ora-markdown" "\
Transform Elisp-style code references to Markdown-style.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-matlab" "modes/ora-matlab.el" (22323
;;;;;;  14431 496933 263000))
;;; Generated autoloads from modes/ora-matlab.el

(autoload 'ora-matlab-shell-hook "modes/ora-matlab" "\


\(fn)" nil nil)

(autoload 'counsel-matlab "modes/ora-matlab" "\
MATLAB completion at point.

\(fn)" t nil)

(autoload 'ora-matlab-hook "modes/ora-matlab" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-mu4e" "modes/ora-mu4e.el" (22079
;;;;;;  42971 949460 916000))
;;; Generated autoloads from modes/ora-mu4e.el

(autoload 'ora-mu4e-headers-hook "modes/ora-mu4e" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-nextmagit" "modes/ora-nextmagit.el"
;;;;;;  (22242 50603 136531 937000))
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

;;;### (autoloads nil "modes/ora-nxml" "modes/ora-nxml.el" (22242
;;;;;;  50603 136531 937000))
;;; Generated autoloads from modes/ora-nxml.el

(autoload 'ora-nxml-hook "modes/ora-nxml" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-occur" "modes/ora-occur.el" (22079
;;;;;;  42972 45460 911000))
;;; Generated autoloads from modes/ora-occur.el

(autoload 'ora-occur-mode-hook "modes/ora-occur" "\


\(fn)" nil nil)

(autoload 'ora-occur-hook "modes/ora-occur" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-octave" "modes/ora-octave.el" (22079
;;;;;;  42972 41460 912000))
;;; Generated autoloads from modes/ora-octave.el

(autoload 'ora-octave-hook "modes/ora-octave" "\


\(fn)" nil nil)

(autoload 'octave-script "modes/ora-octave" "\


\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-org" "modes/ora-org.el" (22323 14431
;;;;;;  496933 263000))
;;; Generated autoloads from modes/ora-org.el

(autoload 'ora-org-hook "modes/ora-org" "\


\(fn)" nil nil)

(autoload 'ora-org-agenda-hook "modes/ora-org" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-package-menu" "modes/ora-package-menu.el"
;;;;;;  (22079 42971 997460 914000))
;;; Generated autoloads from modes/ora-package-menu.el

(autoload 'ora-package-menu-hook "modes/ora-package-menu" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-pdf-view" "modes/ora-pdf-view.el"
;;;;;;  (22245 36322 0 0))
;;; Generated autoloads from modes/ora-pdf-view.el

(autoload 'ora-pdf-view-hook "modes/ora-pdf-view" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-proced" "modes/ora-proced.el" (22121
;;;;;;  24201 0 0))
;;; Generated autoloads from modes/ora-proced.el

(autoload 'ora-proced-hook "modes/ora-proced" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-python" "modes/ora-python.el" (22323
;;;;;;  14431 496933 263000))
;;; Generated autoloads from modes/ora-python.el

(autoload 'hp-beginning-of-line "modes/ora-python" "\


\(fn)" t nil)

(autoload 'ora-python-hook "modes/ora-python" "\


\(fn)" nil nil)

(autoload 'ora-python-eval-nofocus "modes/ora-python" "\
run current script(that requires no input)

\(fn)" t nil)

(autoload 'ora-python-eval "modes/ora-python" "\
run current script

\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/ora-ruby" "modes/ora-ruby.el" (22225
;;;;;;  38769 0 0))
;;; Generated autoloads from modes/ora-ruby.el

(autoload 'ora-ruby-hook "modes/ora-ruby" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-scheme" "modes/ora-scheme.el" (22079
;;;;;;  42971 985460 914000))
;;; Generated autoloads from modes/ora-scheme.el

(autoload 'ora-scheme-hook "modes/ora-scheme" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-sh" "modes/ora-sh.el" (22079 42972
;;;;;;  21460 912000))
;;; Generated autoloads from modes/ora-sh.el

(autoload 'ora-sh-hook "modes/ora-sh" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-tar" "modes/ora-tar.el" (22079 42971
;;;;;;  989460 914000))
;;; Generated autoloads from modes/ora-tar.el

(autoload 'ora-tar-hook "modes/ora-tar" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-term" "modes/ora-term.el" (22323
;;;;;;  9346 393110 345000))
;;; Generated autoloads from modes/ora-term.el

(autoload 'ora-term-exec-hook "modes/ora-term" "\


\(fn)" nil nil)

(autoload 'ora-term-hook "modes/ora-term" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-text" "modes/ora-text.el" (22244
;;;;;;  27761 0 0))
;;; Generated autoloads from modes/ora-text.el

(autoload 'ora-text-hook "modes/ora-text" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil nil ("hooks.el" "init.el" "keys.el" "modes/ora-avy.el"
;;;;;;  "modes/ora-company.el" "modes/ora-elisp-style-guide.el" "modes/ora-helm.el"
;;;;;;  "modes/ora-image.el" "modes/ora-ivy.el" "packages.el") (22323
;;;;;;  15071 80910 991000))

;;;***

;;;### (autoloads nil "git/org-fu/org-fu" "git/org-fu/org-fu.el"
;;;;;;  (22323 7793 285164 430000))
;;; Generated autoloads from git/org-fu/org-fu.el

(autoload 'orfu-agenda-quick "git/org-fu/org-fu" "\


\(fn)" t nil)

(autoload 'orfu-agenda-office "git/org-fu/org-fu" "\


\(fn)" t nil)

(autoload 'orfu-agenda-day "git/org-fu/org-fu" "\


\(fn)" t nil)

(autoload 'orfu-agenda-articles "git/org-fu/org-fu" "\


\(fn)" t nil)

;;;***
