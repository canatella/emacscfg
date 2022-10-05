
(use-package kotlin-mode :ensure t :hook
  ((kotlin-mode . eglot-ensure)
   (kotlin-mode . test-runner-mode)
   (kotlin-mode . kotlin-format-on-save-mode))
  :after (reformatter)
  :devdocs (kotlin-mode "kotlin~1.7")
  :config (reformatter-define kotlin-format :program "ktlint" :args '("-F" "--stdin")))

(use-package flymake-ktlint :ensure t)

(defconst test-runner-kotest-test-regex "@Test[[:blank:]\n]+\\s *fun\\s +`\\([^`]+\\)`")

(defconst test-runner-kotest-package-regex "^package\\s +\\([[:word:].]+\\)")

(defconst test-runner-kotest-class-regex "^class\\s +\\(\\(\\s_\\|\\sw\\)+\\)")

(defun test-runner-kotest-project (&optional current)
  "Locate last build.gradle.kts file in CURRENT hierarchy."
  (if (not current)
      (test-runner-kotest-project (or (buffer-file-name) default-directory))
    (let ((gradle (locate-dominating-file (concat current "..") "build.gradle.kts")))
      (if (not gradle)
          (file-name-as-directory current)
        (test-runner-kotest-project (expand-file-name (concat gradle "..")))))))

(defun test-runner-kotest-subproject-dir ()
  "Return directory for the current subproject."
  (locate-dominating-file (or (buffer-file-name) default-directory) "build.gradle.kts"))

(defun test-runner-kotest-subproject ()
  "Return the subproject for the current buffer"
  (file-name-nondirectory (directory-file-name (test-runner-kotest-subproject-dir))))

(defun test-runner-kotest-test-name-at-point ()
  "Return test name at point."
  (save-excursion
    (if (or
         (looking-at test-runner-kotest-test-regex)
         (re-search-backward test-runner-kotest-test-regex nil t))
        (match-string 1))))

(defun test-runner-kotest-test-class-at-point ()
  "Return test name at point."
  (save-excursion
    (goto-char (point-min))
    (let ((package (when (looking-at test-runner-kotest-package-regex) (match-string 1)))
          (class (when (re-search-forward test-runner-kotest-class-regex nil t) (match-string 1))))
      (format "%s.%s" package class))))

(defun test-runner-kotest-enable-p ()
  (let* ((base-name (or (buffer-file-name) default-directory))
         (file-name (expand-file-name base-name))
         (base-dir (test-runner-kotest-subproject-dir))
         (subproject-dir (when base-dir (expand-file-name base-dir))))
    (and
     subproject-dir
     (string-match "\\.kt$" file-name)
     (string-match (concat "^" subproject-dir) file-name))))

(defclass test-runner-backend-kotest (test-runner-backend-exec)
  ((enable :initform #'test-runner-kotest-enable-p)))

(cl-defmethod test-runner-backend-exec-binary ((_backend test-runner-backend-kotest))
  "Return the gradle binary to use for running tests."
  (let ((project (test-runner-kotest-project)))
    (expand-file-name (concat project "gradlew"))))


(cl-defmethod test-runner-backend-exec-arguments-test-at-point ((_backend test-runner-backend-kotest))
  "Return the arguments to pass to binary to run test at point."
  (let ((test-project (test-runner-kotest-project))
        (test-subproject (test-runner-kotest-subproject))
        a
        (test-class (test-runner-kotest-test-class-at-point))
        (test-name (test-runner-kotest-test-name-at-point)))
    (list "--daemon" "--parallel" "-p" test-project
          (concat test-subproject ":test")
          "--tests"
          (concat test-class "." test-name))))

(cl-defmethod test-runner-backend-exec-arguments-test-file ((_backend test-runner-backend-kotest))
  "Return the arguments to pass to binary to run test at point."
  (let ((test-project (test-runner-kotest-project))
        (test-subproject (test-runner-kotest-subproject))
        (test-class (test-runner-kotest-test-class-at-point)))
    (list "--daemon" "--parallel" "-p" test-project
          (concat test-subproject ":test")
          "--tests" test-class)))

(cl-defmethod test-runner-backend-exec-arguments-test-project ((_backend test-runner-backend-kotest))
  "Return the arguments to pass to binary to run test at point."
  (let ((test-project (test-runner-kotest-project))
        (test-subproject (test-runner-kotest-subproject)))
    (list "--daemon" "--parallel" "-p" test-project (concat test-subproject ":test"))))

(defun test-runner-kotest-next-error (filename)
  "Return real path for FILENAME"
  (seq-find
   (lambda (f) (string= (file-name-nondirectory f) filename))
   (project-files (project-current t))))

(test-runner-define-compilation-mode kotest
  (setq-local compilation-parse-errors-filename-function #'test-runner-kotest-next-error))

(add-to-list 'test-runner-backends 'kotest)
