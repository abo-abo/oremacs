;;

;;;### (autoloads nil "auto" "auto.el" (0 0 0 0))
;;; Generated autoloads from auto.el

(autoload 'ora-move-beginning-of-line "auto" nil t nil)

(autoload 'ora-c-forward-sexp-function "auto" "\


\(fn ARG)" nil nil)

(autoload 'ora-project "auto" nil t nil)

(autoload 'ora-query-replace "auto" "\


\(fn FROM)" t nil)

(autoload 'ora-replace-regexp "auto" "\
Works on current line if there's no region.
When ARG is non-nil launch `query-replace-regexp'.

\(fn ARG)" t nil)

(autoload 'ora-unfill-paragraph "auto" "\
Transform a paragraph into a single line." t nil)

(autoload 'ora-ctrltab "auto" "\
List buffers and give it focus." t nil)

(autoload 'ora-goto-hook-file "auto" "\
Opens hooks.el at point specific to current `major-mode'" t nil)

(autoload 'ora-toggle-buffer "auto" nil t nil)

(autoload 'ora-dired-rsync "auto" "\


\(fn DEST)" t nil)

(autoload 'ora-describe-keys "auto" nil t nil)

(autoload 'illiterate "auto" "\
Useful to completely revert an `org-mode' file." t nil)

(autoload 'melpa "auto" nil t nil)

(autoload 'ora-test-emacs "auto" nil t nil)

(autoload 'ora-figlet-region "auto" "\


\(fn &optional B E)" t nil)

(autoload 'ora-ediff-buffers "auto" nil t nil)

(autoload 'ora-eval-other-window "auto" "\
Eval current expression in the context of other window.
Expression has to be of type (setq X BODY)
In case 'setq isn't present, add it.

\(fn ARG123)" t nil)

(autoload 'ora-toggle-window-dedicated "auto" nil t nil)

(autoload 'update-all-autoloads "auto" nil t nil)

(autoload 'ora-dired-org-to-pdf "auto" nil t nil)

(autoload 'wmctrl-720p "auto" nil t nil)

(autoload 'ora-kill-current-buffer "auto" nil t nil)

(autoload 'ora-save-and-switch-buffer "auto" "\


\(fn &optional ARG)" t nil)

(autoload 'youtube-dl "auto" nil t nil)

(autoload 'ora-directory-parent "auto" "\
Return parent of directory DIR.

\(fn DIR)" nil nil)

(autoload 'ora-pretty-things "auto" "\
Compose chars according to `ora-pretty-alist'." nil nil)

(autoload 'ora-fontify-glyph "auto" "\


\(fn ITEM GLYPH)" nil nil)

(autoload 'ora-elisp-follow "auto" "\
Jump to the definition of the function (or variable) at point.

\(fn NAME)" t nil)

(autoload 'capitalize-word-toggle "auto" nil t nil)

(autoload 'upcase-word-toggle "auto" nil t nil)

(autoload 'named-term "auto" "\


\(fn NAME)" t nil)

(autoload 'jekyll-serve "auto" nil t nil)

(autoload 'sudired "auto" nil t nil)

(autoload 'ora-insert-date "auto" "\
Insert DATE using the current locale.

\(fn DATE)" t nil)

(autoload 'ora-insert-date-from "auto" "\
Insert date that is DAYS from current.

\(fn &optional DAYS)" t nil)

(autoload 'ora-set-transparency "auto" "\


\(fn ALPHA-LEVEL)" t nil)

(autoload 'ora-hide-ctrl-M "auto" "\
Hides the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings." t nil)

(autoload 'ora-lookup-key "auto" "\


\(fn KEY)" nil nil)

(autoload 'ora-pretty-quote-glyphs "auto" nil nil nil)

(defadvice kill-compilation (after ora-disable-compiling-message activate) (setq compilation-in-progress nil))

(autoload 'ora-custom-setq "auto" "\
Set a custom variable, with completion." t nil)

(autoload 'ora-quote-github-issues "auto" nil t nil)

(autoload 'ora-rename-pdf-bibtex "auto" nil t nil)

(autoload 'ora-start-process "auto" "\


\(fn CMD)" nil nil)

(autoload 'git-shortlog "auto" nil t nil)

(autoload 'ora-recompile-startup "auto" "\
Fix byte-compilation warnings emitted by lread.c." t nil)

(autoload 'ora-rhythmbox-io-best "auto" nil t nil)

(autoload 'ipinfo "auto" "\
Return ip info from ipinfo.io for IP.

\(fn IP)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "auto" '("char-upcasep" "dbg" "ora-" "show-message")))

;;;***

;;;### (autoloads nil "git/org-fu/org-fu-twitter" "git/org-fu/org-fu-twitter.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from git/org-fu/org-fu-twitter.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "git/org-fu/org-fu-twitter" '("orfu-")))

;;;***

;;;### (autoloads nil "git/org-fu/youtube-dl" "git/org-fu/youtube-dl.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from git/org-fu/youtube-dl.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "git/org-fu/youtube-dl" '("youtube-dl-channel-to-org")))

;;;***

;;;### (autoloads nil "hooks" "hooks.el" (0 0 0 0))
;;; Generated autoloads from hooks.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hooks" '("cal")))

;;;***

;;;### (autoloads nil "init" "init.el" (0 0 0 0))
;;; Generated autoloads from init.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "init" '("csetq" "emacs-d" "ora-advice-add" "yes-or-no-p")))

;;;***

;;;### (autoloads nil "keys" "keys.el" (0 0 0 0))
;;; Generated autoloads from keys.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "keys" '("hydra-" "lispy-insert-prev-outline-body" "ora-open-line")))

;;;***

;;;### (autoloads nil "modes/ora-Buffer-menu" "modes/ora-Buffer-menu.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-Buffer-menu.el

(autoload 'ora-Buffer-menu-hook "modes/ora-Buffer-menu" "\


\(fn)" nil nil)

(autoload 'ora-bmenu-hook "modes/ora-Buffer-menu" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-Buffer-menu" '("list-buffers--format-default" "hydra-buffer-menu")))

;;;***

;;;### (autoloads nil "modes/ora-Info" "modes/ora-Info.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-Info.el

(autoload 'ora-Info-hook "modes/ora-Info" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-Info" '("hydra-info-to" "ora-open-info")))

;;;***

;;;### (autoloads nil "modes/ora-Man" "modes/ora-Man.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-Man.el

(autoload 'ora-Man-hook "modes/ora-Man" "\


\(fn)" nil nil)

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

;;;### (autoloads nil "modes/ora-bookmark" "modes/ora-bookmark.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-bookmark.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-bookmark" '("bmk/" "ora-")))

;;;***

;;;### (autoloads nil "modes/ora-cider" "modes/ora-cider.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-cider.el

(autoload 'ora-cider-hook "modes/ora-cider" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-clojure" "modes/ora-clojure.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-clojure.el

(autoload 'ora-clojure-hook "modes/ora-clojure" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-clojure" '("add-classpath" "clojure-ampersand" "ora-c")))

;;;***

;;;### (autoloads nil "modes/ora-cmake" "modes/ora-cmake.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-cmake.el

(autoload 'ora-cmake-hook "modes/ora-cmake" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-cmake" '("cmake-indent")))

;;;***

;;;### (autoloads nil "modes/ora-comint" "modes/ora-comint.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-comint.el

(autoload 'ora-comint-hook "modes/ora-comint" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-company" "modes/ora-company.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-company.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-company" '("ora-")))

;;;***

;;;### (autoloads nil "modes/ora-compilation" "modes/ora-compilation.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-compilation.el

(autoload 'ora-compilation-hook "modes/ora-compilation" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-compilation" '("ora-compilation-")))

;;;***

;;;### (autoloads nil "modes/ora-cpp" "modes/ora-cpp.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-cpp.el

(autoload 'ora-c-common-hook "modes/ora-cpp" nil nil nil)

(autoload 'ora-c-hook "modes/ora-cpp" nil nil nil)

(autoload 'ora-c++-hook "modes/ora-cpp" nil nil nil)

;;;***

;;;### (autoloads nil "modes/ora-debugger" "modes/ora-debugger.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-debugger.el

(autoload 'ora-debugger-hook "modes/ora-debugger" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-debugger" '("ora-debug-set-frame")))

;;;***

;;;### (autoloads nil "modes/ora-dired" "modes/ora-dired.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-dired.el

(autoload 'ora-dired-hook "modes/ora-dired" nil nil nil)

(autoload 'ora-dired-jump "modes/ora-dired" nil t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-dired" '("hydra-marked-items" "ora-")))

;;;***

;;;### (autoloads nil "modes/ora-doc-view" "modes/ora-doc-view.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-doc-view.el

(autoload 'ora-doc-view-hook "modes/ora-doc-view" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-doc-view" '("doc-view-evince")))

;;;***

;;;### (autoloads nil "modes/ora-dockerfile" "modes/ora-dockerfile.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-dockerfile.el

(autoload 'ora-dockerfile-hook "modes/ora-dockerfile" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-ediff" "modes/ora-ediff.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-ediff.el

(autoload 'ora-ediff-hook "modes/ora-ediff" "\


\(fn)" nil nil)

(autoload 'ora-diff-hook "modes/ora-ediff" "\


\(fn)" nil nil)

(autoload 'ora-ediff-dwim "modes/ora-ediff" "\


\(fn)" t nil)

(autoload 'ora-ediff-in-frame "modes/ora-ediff" "\


\(fn FILE1 FILE2)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-ediff" '("ediff-save-windows" "ora-ediff-" "max-line-width")))

;;;***

;;;### (autoloads nil "modes/ora-elfeed" "modes/ora-elfeed.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-elfeed.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-elfeed" '("ora-elfeed-")))

;;;***

;;;### (autoloads nil "modes/ora-elisp" "modes/ora-elisp.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-elisp.el

(autoload 'ora-emacs-lisp-hook "modes/ora-elisp" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-elisp" '("conditionally-enable-lispy" "eldoc-mode" "lisp--match-hidden-arg" "ora-")))

;;;***

;;;### (autoloads nil "modes/ora-eltex" "modes/ora-eltex.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-eltex.el

(autoload 'ora-eltex-hook "modes/ora-eltex" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-epa" "modes/ora-epa.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-epa.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-epa" '(#("epa-select-keys" 0 15 (face font-lock-function-name-face fontified nil)) #("ora-epa-user-id" 0 15 (face font-lock-function-name-face fontified nil)))))

;;;***

;;;### (autoloads nil "modes/ora-erc" "modes/ora-erc.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-erc.el

(autoload 'ora-erc-hook "modes/ora-erc" nil nil nil)

(autoload 'bitlbee "modes/ora-erc" nil t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-erc" '("ora-")))

;;;***

;;;### (autoloads nil "modes/ora-ert" "modes/ora-ert.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-ert.el

(autoload 'ora-ert-results-hook "modes/ora-ert" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-eshell" "modes/ora-eshell.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-eshell.el

(autoload 'ora-eshell-hook "modes/ora-eshell" "\


\(fn)" nil nil)

(autoload 'eshell-this-dir "modes/ora-eshell" "\
Open or move eshell in `default-directory'.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-eshell" '("eshell-completion-at-point")))

;;;***

;;;### (autoloads nil "modes/ora-eww" "modes/ora-eww.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-eww.el

(autoload 'ora-eww-hook "modes/ora-eww" nil nil nil)

(autoload 'ora-eww-reader "modes/ora-eww" nil t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-eww" '("eww-view-ace" "ora-")))

;;;***

;;;### (autoloads nil "modes/ora-flyspell" "modes/ora-flyspell.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-flyspell.el

(autoload 'ora-flyspell-previous-word "modes/ora-flyspell" "\
Correct the first misspelled word that occurs before point.
But don't look beyond what's visible on the screen." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-flyspell" '("flyspell-ignore-http-and-https" "ora-make-flyspell-overlay-return-mouse-stuff")))

;;;***

;;;### (autoloads nil "modes/ora-fonts" "modes/ora-fonts.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-fonts.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-fonts" '("ora-set-font")))

;;;***

;;;### (autoloads nil "modes/ora-gnus" "modes/ora-gnus.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-gnus.el

(autoload 'ora-gnus-group-hook "modes/ora-gnus" "\


\(fn)" nil nil)

(autoload 'ora-gnus-summary-hook "modes/ora-gnus" "\


\(fn)" nil nil)

(autoload 'ora-message-hook "modes/ora-gnus" "\


\(fn)" nil nil)

(autoload 'ora-gnus-article-hook "modes/ora-gnus" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-gnus" '("counsel-bbdb-" "ivy-set-completion-bounds" "ora-list-subscribed-groups")))

;;;***

;;;### (autoloads nil "modes/ora-groovy" "modes/ora-groovy.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-groovy.el

(autoload 'ora-groovy-hook "modes/ora-groovy" nil nil nil)

;;;***

;;;### (autoloads nil "modes/ora-haskell" "modes/ora-haskell.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-haskell.el

(autoload 'ora-haskell-hook "modes/ora-haskell" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-haskell" '("ora-haskell-co")))

;;;***

;;;### (autoloads nil "modes/ora-helm" "modes/ora-helm.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-helm.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-helm" '("helm-")))

;;;***

;;;### (autoloads nil "modes/ora-help" "modes/ora-help.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-help.el

(autoload 'ora-help-hook "modes/ora-help" nil nil nil)

;;;***

;;;### (autoloads nil "modes/ora-html" "modes/ora-html.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-html.el

(autoload 'ora-html-hook "modes/ora-html" nil nil nil)

;;;***

;;;### (autoloads nil "modes/ora-hy" "modes/ora-hy.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-hy.el

(autoload 'ora-hy-hook "modes/ora-hy" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-hydra-k" "modes/ora-hydra-k.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-hydra-k.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-hydra-k" '("hydra-k" "ora-open-")))

;;;***

;;;### (autoloads nil "modes/ora-ibuffer" "modes/ora-ibuffer.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-ibuffer.el

(autoload 'ora-ibuffer-hook "modes/ora-ibuffer" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-image" "modes/ora-image.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-image.el

(autoload 'ora-image-hook "modes/ora-image" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-image" '("image-view")))

;;;***

;;;### (autoloads nil "modes/ora-insert" "modes/ora-insert.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-insert.el

(autoload 'ora-quotes "modes/ora-insert" "\


\(fn ARG)" t nil)

(autoload 'ora-single-quotes "modes/ora-insert" "\


\(fn ARG)" t nil)

(autoload 'ora-parens "modes/ora-insert" nil t nil)

(autoload 'ora-dollars "modes/ora-insert" nil t nil)

(autoload 'ora-brackets "modes/ora-insert" nil t nil)

(autoload 'ora-braces "modes/ora-insert" nil t nil)

(autoload 'ora-braces-c++ "modes/ora-insert" "\
Insert {}.
Threat is as function body when from endline before )" t nil)

(autoload 'ora-angles-c++ "modes/ora-insert" nil t nil)

(autoload 'ora-angles "modes/ora-insert" nil t nil)

;;;***

;;;### (autoloads nil "modes/ora-ivy" "modes/ora-ivy.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-ivy.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-ivy" '("ivy-" "ora-")))

;;;***

;;;### (autoloads nil "modes/ora-j" "modes/ora-j.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-j.el

(autoload 'j-setup-shortcuts "modes/ora-j" "\
Assign shortcuts for J." t nil)

(autoload 'ora-j-hook "modes/ora-j" "\
Hook for J modes." nil nil)

(autoload 'run-j "modes/ora-j" "\
Call `j-console' and setup shortcuts." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-j" '("j-")))

;;;***

;;;### (autoloads nil "modes/ora-java" "modes/ora-java.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-java.el

(autoload 'ora-java-hook "modes/ora-java" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-java" '("java-" "get-single-argument-name" ">-by-length" "reductions" "upcase-first-letter" "downcase-first-letter" "ant" "ora-java-current-defun-name")))

;;;***

;;;### (autoloads nil "modes/ora-javascript" "modes/ora-javascript.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-javascript.el

(autoload 'ora-javascript-hook "modes/ora-javascript" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-javascript" '("ac-source-javascript" "javascript-candidates" "js-" "keyword-function" "ora-" "refresh-javascript-candidates")))

;;;***

;;;### (autoloads nil "modes/ora-latex" "modes/ora-latex.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-latex.el

(autoload 'ora-latex-hook "modes/ora-latex" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-latex" '("font-lock-simple-face" "ora-")))

;;;***

;;;### (autoloads nil "modes/ora-lisp" "modes/ora-lisp.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-lisp.el

(autoload 'ora-lisp-hook "modes/ora-lisp" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-lisp" '("ora-slime-completion-in-region")))

;;;***

;;;### (autoloads nil "modes/ora-lsp" "modes/ora-lsp.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-lsp.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-lsp" '("lsp-mode-line")))

;;;***

;;;### (autoloads nil "modes/ora-magit" "modes/ora-magit.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-magit.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-magit" '("ora-")))

;;;***

;;;### (autoloads nil "modes/ora-makefile" "modes/ora-makefile.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-makefile.el

(autoload 'ora-makefile-hook "modes/ora-makefile" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-makefile" '("save-and-compile")))

;;;***

;;;### (autoloads nil "modes/ora-markdown" "modes/ora-markdown.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-markdown.el

(autoload 'ora-markdown-hook "modes/ora-markdown" "\


\(fn)" nil nil)

(autoload 'ora-markdown-cleanup "modes/ora-markdown" "\
Transform Elisp-style code references to Markdown-style.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-markdown" '("ora-")))

;;;***

;;;### (autoloads nil "modes/ora-mu4e" "modes/ora-mu4e.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-mu4e.el

(autoload 'ora-mu4e-headers-hook "modes/ora-mu4e" nil nil nil)

(autoload 'ora-mu4e-compose-hook "modes/ora-mu4e" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-mu4e" '("ora-mml-attach-file")))

;;;***

;;;### (autoloads nil "modes/ora-nextmagit" "modes/ora-nextmagit.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-nextmagit.el

(autoload 'ora-nextmagit-status-hook "modes/ora-nextmagit" nil nil nil)

(autoload 'ora-nextmagit-log-hook "modes/ora-nextmagit" nil nil nil)

(autoload 'ora-nextmagit-commit-hook "modes/ora-nextmagit" nil nil nil)

(autoload 'ora-nextmagit-diff-hook "modes/ora-nextmagit" nil nil nil)

(autoload 'ora-nextmagit-branch-manager-hook "modes/ora-nextmagit" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-nextmagit" '("endless/add-PR-fetch" "ora-m")))

;;;***

;;;### (autoloads nil "modes/ora-nxml" "modes/ora-nxml.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-nxml.el

(autoload 'ora-nxml-hook "modes/ora-nxml" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-occur" "modes/ora-occur.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-occur.el

(autoload 'ora-occur-mode-hook "modes/ora-occur" "\


\(fn)" nil nil)

(autoload 'ora-occur-hook "modes/ora-occur" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-octave" "modes/ora-octave.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-octave.el

(autoload 'ora-octave-hook "modes/ora-octave" "\


\(fn)" nil nil)

(autoload 'octave-script "modes/ora-octave" "\


\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-octave" '("octave-")))

;;;***

;;;### (autoloads nil "modes/ora-org" "modes/ora-org.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-org.el

(autoload 'ora-org-hook "modes/ora-org" nil nil nil)

(autoload 'ora-org-agenda-hook "modes/ora-org" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-org" '("hot-expand" "hydra-org-" "ora-" "org-")))

;;;***

;;;### (autoloads nil "modes/ora-org-babel" "modes/ora-org-babel.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-org-babel.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-org-babel" '("ora-org-babel-insert-result" "org-babel-default-header-args:clojure")))

;;;***

;;;### (autoloads nil "modes/ora-org-pomodoro" "modes/ora-org-pomodoro.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-org-pomodoro.el

(autoload 'ora-org-clock-out "modes/ora-org-pomodoro" nil t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-org-pomodoro" '("ora-org-pomodoro")))

;;;***

;;;### (autoloads nil "modes/ora-org-roam" "modes/ora-org-roam.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-org-roam.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-org-roam" '("hydra-org-roam" "ora-" "worf-maybe-rebuild-roam-cache")))

;;;***

;;;### (autoloads nil "modes/ora-package" "modes/ora-package.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-package.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-package" '("emacs-d")))

;;;***

;;;### (autoloads nil "modes/ora-package-menu" "modes/ora-package-menu.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-package-menu.el

(autoload 'ora-package-menu-hook "modes/ora-package-menu" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-pass" "modes/ora-pass.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-pass.el

(autoload 'ora-password "modes/ora-pass" nil t nil)

;;;***

;;;### (autoloads nil "modes/ora-pdf-view" "modes/ora-pdf-view.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-pdf-view.el

(autoload 'ora-pdf-view-hook "modes/ora-pdf-view" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-proced" "modes/ora-proced.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-proced.el

(autoload 'ora-proced-hook "modes/ora-proced" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-projectile" "modes/ora-projectile.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-projectile.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-projectile" '("hydra-projectile")))

;;;***

;;;### (autoloads nil "modes/ora-python" "modes/ora-python.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-python.el

(autoload 'ora-python-hook "modes/ora-python" nil nil nil)

(autoload 'ora-inferior-python-hook "modes/ora-python" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-python" '("ora-" "python-")))

;;;***

;;;### (autoloads nil "modes/ora-ruby" "modes/ora-ruby.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-ruby.el

(autoload 'ora-ruby-hook "modes/ora-ruby" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-ruby" '("ora-ruby-")))

;;;***

;;;### (autoloads nil "modes/ora-rust" "modes/ora-rust.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-rust.el

(autoload 'ora-rust-hook "modes/ora-rust" nil nil nil)

;;;***

;;;### (autoloads nil "modes/ora-scheme" "modes/ora-scheme.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-scheme.el

(autoload 'ora-scheme-hook "modes/ora-scheme" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-scheme" '("ora-scheme-plait-colon" "scheme-completion-at-point")))

;;;***

;;;### (autoloads nil "modes/ora-search" "modes/ora-search.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-search.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-search" '("hydra-search" "ora-search-query")))

;;;***

;;;### (autoloads nil "modes/ora-sh" "modes/ora-sh.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-sh.el

(autoload 'ora-sh-hook "modes/ora-sh" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-shell" "modes/ora-shell.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-shell.el

(autoload 'ora-shell-hook "modes/ora-shell" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-shell" '("ora-")))

;;;***

;;;### (autoloads nil "modes/ora-smime" "modes/ora-smime.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from modes/ora-smime.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-smime" '("ora-")))

;;;***

;;;### (autoloads nil "modes/ora-sml" "modes/ora-sml.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-sml.el

(autoload 'ora-sml-hook "modes/ora-sml" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-straight" "modes/ora-straight.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modes/ora-straight.el

(autoload 'ora-straight-reload-all "modes/ora-straight" nil t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-straight" '("ora-directory-files")))

;;;***

;;;### (autoloads nil "modes/ora-tar" "modes/ora-tar.el" (0 0 0 0))
;;; Generated autoloads from modes/ora-tar.el

(autoload 'ora-tar-hook "modes/ora-tar" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/ora-term" "modes/ora-term.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-term.el

(autoload 'ora-term-exec-hook "modes/ora-term" nil nil nil)

(autoload 'ora-term-hook "modes/ora-term" nil nil nil)

;;;***

;;;### (autoloads nil "modes/ora-text" "modes/ora-text.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from modes/ora-text.el

(autoload 'ora-text-hook "modes/ora-text" nil nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modes/ora-text" '("ora-")))

;;;***

;;;### (autoloads nil "modes/ora-vc-dir" "modes/ora-vc-dir.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from modes/ora-vc-dir.el

(autoload 'ora-vc-dir-hook "modes/ora-vc-dir" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "packages" "packages.el" (0 0 0 0))
;;; Generated autoloads from packages.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "packages" '("emacs-d" "ora-packages" "straight-install-packages")))

;;;***

;;;### (autoloads nil nil ("modes/ora-auto.el" "modes/ora-elisp-style-guide.el"
;;;;;;  "modes/ora-grep.el" "modes/ora-hydra.el" "modes/ora-keepassxc.el"
;;;;;;  "modes/ora-org-babel-inline.el" "modes/ora-visuals.el") (0
;;;;;;  0 0 0))

;;;***

;;;### (autoloads nil "git/org-fu/org-fu" "git/org-fu/org-fu.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from git/org-fu/org-fu.el

(autoload 'orfu-agenda-quick "git/org-fu/org-fu" nil t nil)

(autoload 'orfu-agenda-office "git/org-fu/org-fu" nil t nil)

(autoload 'orfu-agenda-day "git/org-fu/org-fu" nil t nil)

(autoload 'orfu-agenda-articles "git/org-fu/org-fu" nil t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "git/org-fu/org-fu" '("orfu-")))

;;;***
