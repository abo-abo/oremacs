(require 'cc-mode)
(require 'cc-chainsaw)
(setq compilation-read-command nil)

(defun ora-java-current-defun-name ()
  (save-excursion
    (beginning-of-defun)
    (re-search-forward "(")
    (backward-char 2)
    (thing-at-point 'symbol t)))

(define-key java-mode-map [C-f5] 'ccc-run)
(define-key java-mode-map (kbd "C-c C-l") 'java-eval-buffer)
(define-key java-mode-map (kbd "C-c C-z") 'java-switch-to-repl)
(define-key java-mode-map [f5] 'helm-make-projectile)
(define-key java-mode-map (kbd "<f2> h") 'hs-toggle-hiding)
(define-key java-mode-map (kbd "M-<f5>") (lambda ()(interactive)(antify)(ant-compile)))
(define-key java-mode-map (kbd "χ") 'java-attr)
(define-key java-mode-map (kbd "C-/") 'java-toggle-map)
(require 'soap)
(require 'abbrev)
(read-abbrev-file nil t)
(dolist (k '("+" "-" "*" "/" "%" "&" "|" "<" "=" ">" ","))
  (define-key java-mode-map (kbd k) 'soap-command))

;;;###autoload
(defun ora-java-hook ()
  (hs-minor-mode)
  (setq c-basic-offset 2)
  (setq add-log-current-defun-function 'ora-java-current-defun-name)
  (abbrev-mode 1))

(defun java-compile ()
  (interactive)
  (let* ((source (file-name-nondirectory buffer-file-name))
         (out (file-name-sans-extension source))
         (class (concat out ".class")))
    (save-buffer)
    (shell-command (format "rm -f %s && javac %s" class source))
    (unless (file-exists-p class)
      (set (make-local-variable 'compile-command)
           (format "javac %s" source))
      (command-execute 'compile))))

(defun antify ()
  (interactive)
  ;; (if (file-exists-p "build.xml")
  ;;     (message "build.xml already exists")
  (let ((class (java-public-class-name))
        (fname (buffer-file-name)))
    (with-temp-buffer
      (insert-file-contents "~/Dropbox/source/java/tbuild.xml")
      (search-forward "classname=" nil t)
      (replace-match (concat "classname=\"" class) nil t)
      ;; (replace-string "classname=" (concat "classname=\"" class))
      (message (concat (java-file-classpath fname) "build.xml"))
      (write-region (point-min) (point-max)
                    ;; "../build.xml"
                    (concat (java-file-classpath fname) "build.xml")))))

(defun ant-compile ()
  "Traveling up the path, find build.xml file and run compile"
  (interactive)
  (save-buffer)
  (with-temp-buffer
    (while (and (not (file-exists-p "build.xml"))
                (not (equal "/" default-directory)))
      (cd ".."))
    (set (make-local-variable 'compile-command)
         "ant -emacs")
    (call-interactively 'compile)))

(defun java-public-class-name ()
  (interactive)
  (let* ((s (buffer-substring-no-properties (point-min) (point-max)))
         (class-name (progn
                       (string-match "public\s+\\(abstract\\|final\\)?\s*\\(class\\|enum\\)\s+\\([^\s{\n<]+\\)" s)
                       (match-string 3 s)))
         (package-name (progn
                         (string-match "^\s*package\s+\\([^;]+\\)" s)
                         (match-string 1 s))))
    (if package-name
        (concat package-name "." class-name)
      class-name)))

(defun java-prev-class ()
  "Searches backward for a class definition.
   Returns the class name."
  (backward-up-list)
  (let* ((tail (point))
         (head (search-backward-regexp "\\(class\\|enum\\)\s+\\([^\s{\n<]+\\)"))
         (s (buffer-substring-no-properties head tail))
         (class-name (progn
                       (string-match "\\(class\\|enum\\)\s+\\([^\s{\n<]+\\)" s)
                       (match-string 2 s))))
    class-name))

;; TODO: maybe move abbrev part here too
(defvar java-variable-names-alist nil
  "default names for java classes. used by `java-default-variable-name'")

(setq java-variable-names-alist
      '(("Random" "rand")
        ("BufferedInputStream" "in")
        ("ObjectInputStream" "in")
        ("PrintStream" "out")))

(defun java-default-variable-name (class-name)
  "Generates e.g. ArrayList -> al"
  (let ((pre (assoc class-name java-variable-names-alist)))
    (cond ;; ((string= class-name "Random") "rand")
      (pre (cadr pre))
      (t (let ((case-fold-search nil))
           (downcase (replace-regexp-in-string "[a-z<,>]+" "" class-name)))))))

(defun downcase-first-letter (word)
  (concat (downcase (substring word 0 1))
          (substring word 1)))

(defun upcase-first-letter (word)
  (concat (upcase (substring word 0 1))
          (substring word 1)))

;; accoriding to the Java specification, the order of modifiers is:
;; 1 public, protected, private
;; 2 abstract
;; 3 static
;; 4 final
;; 5 transient
;; 6 volatile
;; 7 synchronized
;; 8 native
;; 9 strictfp
(defun java-toggle-private ()
  (interactive)
  (save-excursion
    (end-of-line)
    (or (and (re-search-backward "\\(public\\|protected\\|private\\)" (line-beginning-position) t)
             (or (and (looking-at "private")
                      (progn (delete-char 7)
                             (insert "public")
                             t))
                 (and (looking-at "public")
                      (progn (delete-char 6)
                             (insert "private")
                             t))))
        (progn (back-to-indentation)
               (insert "private "))))
  (if (string-match "^\s*\\w+\s*$"
                    (buffer-substring-no-properties
                     (line-beginning-position)
                     (line-end-position)))
      (end-of-line)))

(defmacro java-toggle-modifier (m regex)
  (let ((name (make-symbol (concat "java-toggle-" m)))
        (ins (concat m " "))
        (len (+ (length m) 1)))
    `(defun ,name ()
       (interactive)
       (let ((line-empty (looking-back "^\\s-*")))
         (save-excursion
           (back-to-indentation)
           (cond ((re-search-forward ,m (line-end-position) t)
                  (backward-delete-char ,len))
                 ((re-search-forward ,regex (line-end-position) t)
                  (insert ,ins))))
         (if line-empty (end-of-line))))))

(defun reductions (f init cl-seq)
  "Returns a seq of the intermediate values of the reduction of `cl-seq' by `f'"
  (let ((cl-accum (list init)))
    (while cl-seq
      (push (funcall f (car cl-accum) (pop cl-seq))
            cl-accum))
    (nreverse cl-accum)))

;; (mapcar*
;;  (lambda (x y)
;;    `(java-toggle-modifier ,x ,y))
;;  '("abstract" "static" "final" "transient" "volatile" "synchronized" "native")
;;  (reductions (lambda (x y) (concat x "\\(" y "\\)?\\s-*"))
;;              "\\(public\\|private\\|protected\\|\\)\\s-*"
;;              '("abstract" "static" "final" "transient" "volatile" "synchronized" "native")))
(java-toggle-modifier "abstract"     "\\(public\\|private\\|protected\\|\\)\\s-*")
(java-toggle-modifier "static"       "\\(public\\|private\\|protected\\|\\)\\s-*\\(abstract\\)?\\s-*")
(java-toggle-modifier "final"        "\\(public\\|private\\|protected\\|\\)\\s-*\\(abstract\\)?\\s-*\\(static\\)?\\s-*")
(java-toggle-modifier "transient"    "\\(public\\|private\\|protected\\|\\)\\s-*\\(abstract\\)?\\s-*\\(static\\)?\\s-*\\(final\\)?\\s-*")
(java-toggle-modifier "volatile"     "\\(public\\|private\\|protected\\|\\)\\s-*\\(abstract\\)?\\s-*\\(static\\)?\\s-*\\(final\\)?\\s-*\\(transient\\)?\\s-*")
(java-toggle-modifier "synchronized" "\\(public\\|private\\|protected\\|\\)\\s-*\\(abstract\\)?\\s-*\\(static\\)?\\s-*\\(final\\)?\\s-*\\(transient\\)?\\s-*\\(volatile\\)?\\s-*")
(java-toggle-modifier "native"       "\\(public\\|private\\|protected\\|\\)\\s-*\\(abstract\\)?\\s-*\\(static\\)?\\s-*\\(final\\)?\\s-*\\(transient\\)?\\s-*\\(volatile\\)?\\s-*\\(synchronized\\)?\\s-*")

(defvar java-toggle-map)
(define-prefix-command 'java-toggle-map)
(define-key java-toggle-map "\C-p" 'java-toggle-private)
(define-key java-toggle-map "\C-a" 'java-toggle-abstract)
(define-key java-toggle-map "\C-s" 'java-toggle-static)
(define-key java-toggle-map "\C-f" 'java-toggle-final)
(define-key java-toggle-map "\C-t" 'java-toggle-transient)
(define-key java-toggle-map "\C-v" 'java-toggle-volatile)
(define-key java-toggle-map "\C-y" 'java-toggle-synchronized)
(define-key java-toggle-map "\C-n" 'java-toggle-native)

(defun java-inside-catch? ()
  "captures name of exception caught.
   nil if not inside catch block."
  (if (looking-back "catch(\\w*Exception\s+\\(\\w+\\)) {[^}]*")
      (buffer-substring-no-properties
       (match-beginning 1)
       (match-end 1))))

(defun >-by-length (a b)
  (> (length a) (length b)))

(defun java-file-classpath (file)
  "gives most specific CLASSPATH for file."
  (let* ((f (file-name-directory
             file))
         (paths (cl-remove-if-not
                 (lambda (p) (string-match p f))
                 (sort (split-string (replace-regexp-in-string "\\\\" "/" (getenv "CLASSPATH")) path-separator) '>-by-length))))
    (if (null paths)
        (message "File not on CLASSPATH.")
      (car paths))))

(defun java-package-name (file)
  "Generates package name for FILE, based on path."
  (let* ((f (file-name-directory file))
         (rem
          (car
           (sort
            (delq nil
                  (mapcar
                   (lambda (x)
                     (and (string-match (expand-file-name x) f)
                          (substring f (match-end 0))))
                   (parse-colon-path (getenv "CLASSPATH"))))
            (lambda (a b) (< (length a) (length b)))))))
    (cond
      ((null rem)
       "Not on CLASSPATH.")
      ((= 0 (length rem))
       "At root of CLASSPATH")
      (t
       (mapconcat
        #'downcase
        (delete "" (split-string rem "[\\\\/]"))
        ".")))))

(defun java-type-on-this-line ()
  "e.g for X x = ... the result is X"
  (interactive)
  (let ((s (buffer-substring-no-properties
            (line-beginning-position)
            (line-end-position))))
    (progn
      (string-match "^\s+\\(private\\|public\\|protected\\|static\\)?\s*\\([^\s]+\\)\s+" s)
      (match-string 2 s))))

(defun java-attr ()
  (interactive)
  (let ((s (split-string (read-string "attributes: ") "" t))
        (r ""))
    (if (member "i" s)
        (setf r (concat r "private ")))
    (if (member "u" s)
        (setf r (concat r "public ")))
    (if (member "o" s)
        (setf r (concat r "protected ")))
    (if (member "a" s)
        (setf r (concat r "abstract ")))
    (if (member "s" s)
        (setf r (concat r "static ")))
    (if (member "f" s)
        (setf r (concat r "final ")))
    (if (member "v" s)
        (setf r (concat r "volatile ")))
    (if (member "y" s)
        (setf r (concat r "synchronized ")))
    (insert r)))

(defun get-single-argument-name ()
  (interactive)
  (re-search-backward "\\(\\w+\\)\\s-*)\\s-*{")
  (match-string 1))

(defun java-eval-process ()
  (let ((name "*java-repl*")
        buf process)
    (if (and (setq buf (get-buffer name))
             (setq process (get-buffer-process buf))
             (process-live-p process))
        process
      (save-window-excursion
        (comint-run "java-repl")
        (get-buffer-process (current-buffer))))))

(defun java-eval-buffer ()
  (interactive)
  (process-send-string (java-eval-process)
                       (concat (if (region-active-p)
                                   (buffer-substring-no-properties
                                    (region-beginning)
                                    (region-end))
                                 (buffer-string))
                               "\n")))

(defun java-switch-to-repl ()
  (interactive)
  (pop-to-buffer
   (process-buffer (java-eval-process))))
