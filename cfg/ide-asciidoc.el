(use-package trivial-adoc-mode :quelpa
  (trivial-adoc-mode :fetcher github :repo "canatella/emacs-trivial-adoc-mode")
  :bind (:map trivial-adoc-mode-map ("<f8>"  . #'trivial-adoc-compile-file))
  :custom (trivial-adoc-mode-one-sentence-per-line t))

(defvar trivial-adoc-compilation-finish-functions '(trivial-adoc-compilation-finished))

(defvar-local trivial-adoc-compilation-file nil "The file being compiled in a asciidoc compilation buffer.")
(put 'trivial-adoc-compilation-file 'safe-local-variable #'file-exists-p)

(defvar-local trivial-adoc-compilation-file-buffer nil "The buffer of the file being compiled in a asciidoc compilation buffer.")

(define-compilation-mode trivial-adoc-compilation-mode "asciidoc" "Compilation mode for asciidoc")

(defun trivial-adoc-pdf-file (adoc-file)
  "Return the matching ADOC-FILE matching PDF file."
  (concat (file-name-sans-extension adoc-file) ".pdf"))
(defun trivial-adoc-compile-file ()
  "Compile file"
  (interactive)
  (let* ((adoc-file (or trivial-adoc-compilation-file buffer-file-name))
         (adoc-buffer (current-buffer))
         (compile-command (format "make -j %s" (trivial-adoc-pdf-file adoc-file))))
    (with-current-buffer (compile compile-command 'trivial-adoc-compilation-mode)
      (setq-local trivial-adoc-compilation-file adoc-file)
      (setq-local trivial-adoc-compilation-file-buffer adoc-buffer))))

(defun trivial-adoc-compilation-finished (buffer status)
  "Hook when compilation is done in BUFFER with STATUS."
  (when (string= status "finished\n")
    (save-excursion
      (select-window (get-buffer-window buffer))
      (let ((revert-without-query '(".*")))
        (find-file (trivial-adoc-pdf-file trivial-adoc-compilation-file))))
    (pop-to-buffer trivial-adoc-compilation-file-buffer)))


(use-package structurizr-mode
  :mode "\\.c4\\'"
  :quelpa (structurizr-mode :fetcher github :repo "canatella/structurizr-mode" :branch "fix-package-header"))

(use-package plantuml-mode
  :ensure t
  :mode (("\\.puml\\'" . plantuml-node)
         ("\\.iuml\\'" . plantuml-mode))
  :custom (plantuml-default-exec-mode 'executable "Use jar for previewing")
  (plantuml-executable-args '("-headless" "-nbthread")))
