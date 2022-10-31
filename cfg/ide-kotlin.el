(use-package flymake-ktlint :quelpa
  (flymake-ktlint :fetcher github :repo "canatella/flymake-ktlint")
  :custom (flymake-ktlint-executable "java")
  (flymake-ktlint-args
   '("-Xshare:on" "-XX:SharedArchiveFile=/home/dam/.cache/java-cds/_nix_store_c6p2xj22qnrvglqhd0sbddvgwhrz7x0z-ktlint-0.45.2_bin_.ktlint-wrapped.jsa" "-jar" "/nix/store/c6p2xj22qnrvglqhd0sbddvgwhrz7x0z-ktlint-0.45.2/bin/.ktlint-wrapped")))

(use-package kotlin-mode :ensure t
  :hook ((kotlin-mode . kotlin-format-on-save-mode)
         (kotlin-mode . test-runner-mode)
         (kotlin-mode . eglot-ensure)
         (kotlin-mode . auto-revert-mode)
         (eglot-managed-mode . kotlin-eglot-setup)
         (java-mode-hook . java-imports-scan-file))
  :bind (:map kotlin-mode-map ("C-x x j" . #'kotlin-open-in-intellij))
  :after (reformatter)
  :devdocs (kotlin-mode "kotlin~1.7")
  :config (add-to-list 'eglot-server-programs
                       '(kotlin-mode "~/.local/Cellar/kotlin-language-server/server/build/install/server/bin/kotlin-language-server"))
  (defun kotlin-eglot-setup () (when (eq major-mode #'kotlin-mode) (flymake-ktlint-add-hook)))
  (defun kotlin-open-in-intellij ()
    "Open current file in intellij"
    (interactive)
    (save-buffer)
    (start-process "intellij-launch" nil "intellij-idea-community" "--line"
                   (format "%s" (+ 1 (line-number-at-pos)))
                   "--column"
                   (format "%s" (current-column))
                   (buffer-file-name)))
  (reformatter-define kotlin-format :program "java" :args
    '("-Xshare:on" "-XX:SharedArchiveFile=/home/dam/.cache/java-cds/_nix_store_c6p2xj22qnrvglqhd0sbddvgwhrz7x0z-ktlint-0.45.2_bin_.ktlint-wrapped.jsa" "-jar" "/nix/store/c6p2xj22qnrvglqhd0sbddvgwhrz7x0z-ktlint-0.45.2/bin/.ktlint-wrapped" "-F" "--stdin")))



(defconst test-runner-kotest-annotation-spec-test-regex "@Test[[:blank:]\n]+\\s *fun\\s +`\\([^`]+\\)`")

(defconst test-runner-kotest-string-spec-test-regex
  "\"\"\"\\([^z-a]+?[^[:blank:]]\\)\"\"\"[[:blank:]\n]+{")

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
    (replace-regexp-in-string
     ","
     "."
     (replace-regexp-in-string
      "[[:blank:][:cntrl:]]+"
      " "
      (if (or
           (looking-at test-runner-kotest-string-spec-test-regex)
           (re-search-backward test-runner-kotest-string-spec-test-regex nil t))
          (match-string 1))))))

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
        (test-subproject (test-runner-kotest-subproject)))
    (list "-p" test-project (concat test-subproject ":test"))))

(cl-defmethod test-runner-backend-exec-environment-test-at-point ((_backend test-runner-backend-kotest))
  "Return the arguments to pass to binary to run test at point."
  (let ((test-class (test-runner-kotest-test-class-at-point))
        (test-name (test-runner-kotest-test-name-at-point)))
    (list (format "kotest_filter_specs=%s" test-class) (format "kotest_filter_tests=%s" test-name))))

(cl-defmethod test-runner-backend-exec-arguments-test-file ((_backend test-runner-backend-kotest))
  "Return the arguments to pass to binary to run test at point."
  (let ((test-project (test-runner-kotest-project))
        (test-subproject (test-runner-kotest-subproject)))
    (list "-p" test-project (concat test-subproject ":test"))))


(cl-defmethod test-runner-backend-exec-environment-test-file ((_backend test-runner-backend-kotest))
  "Return the arguments to pass to binary to run test at point."
  (let ((test-class (test-runner-kotest-test-class-at-point)))
    (list (format "kotest_filter_specs=%s" test-class))))

(cl-defmethod test-runner-backend-exec-arguments-test-project ((_backend test-runner-backend-kotest))
  "Return the arguments to pass to binary to run test at point."
  (let ((test-project (test-runner-kotest-project))
        (test-subproject (test-runner-kotest-subproject)))
    (list "-p" test-project (concat test-subproject ":check"))))

(defun test-runner-kotest-next-error (filename)
  "Return real path for FILENAME"
  (if (file-name-absolute-p filename)
      filename
    (seq-find
     (lambda (f) (string= (file-name-nondirectory f) filename))
     (project-files (project-current t)))))

(test-runner-define-compilation-mode kotest
  (setq-local compilation-parse-errors-filename-function #'test-runner-kotest-next-error))

(add-to-list 'test-runner-backends 'kotest)
