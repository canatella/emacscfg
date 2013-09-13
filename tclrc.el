(defun my/tcl-test-p ()
  (string= (file-name-extension (buffer-file-name)) "test"))

(defun my/tcl-namespace () 
  (save-excursion
    (if (re-search-backward "namespace +eval +\\(::[^ ]+\\)" nil t)
        (match-string 1) nil)))

(defun my/tcl-proc-namespace ()
  (let ((ns (my/tcl-namespace)))
    (if ns (concat ns "::") "")))

(defun my/tcl-compile-command (&optional test)
  (if (my/tcl-test-p)
      (format "cd %s && tclsh %sall.tcl -file %s %s"
              (file-name-directory (buffer-file-name))
              (file-name-directory (buffer-file-name))
              (file-name-nondirectory (buffer-file-name))
              (if test (format "-match '%s'" test) ""))))

(defun my/tcl-find-error (&optional buffer msg)
  (message "looking for errors")
  (when buffer
    (let ((tagline (save-excursion
                     (set-buffer buffer)
                     (goto-char (point-min))
                     (when (re-search-forward "(procedure \"\\([^\"]+\\)\" line \\([0-9]+\\))" nil t)
                       (let ((proc (match-string 1))
                             (line (string-to-number (match-string 2))))
                         (set-buffer my/tcl-test-buffer)
                         (cons (semantic-find-first-tag-by-name proc (semanticdb-brute-deep-find-tags-by-name proc)) line))))))
      (let ((tag (car tagline))
            (line (cdr tagline)))
        (when (semantic-tag-p tag)
          (find-file (semantic-tag-file-name tag))
          (set-buffer  my/tcl-test-buffer)
          (semantic-go-to-tag tag)
          (forward-line (- line 1)))))))

(defun my/tcl-compile-test (&optional all)
  (interactive "P")
  (save-excursion
    (let ((command (if (and (not all) (re-search-backward "^[ \t]*test[ \t]*\{\\([^\}]+\\)}" nil t))
                       (my/tcl-compile-command (replace-regexp-in-string " " "\\\\ " (match-string 1)))
                     (my/tcl-compile-command)))
          (old-compilation-error-regexp-alist compilation-error-regexp-alist)
          (old-compilation-auto-jump-to-first-error compilation-auto-jump-to-first-error))
      (setq my/tcl-test-buffer (current-buffer))
      (custom-set-variables '(compilation-auto-jump-to-first-error nil)
                            '(compilation-error-regexp-alist nil))
      (compile command)
      (make-local-variable 'compilation-error-regexp-alist)
      (make-local-variable 'compilation-auto-jump-to-first-error)
      (custom-set-variables '(compilation-error-regexp-alist old-compilation-error-regexp-alist)
                            '(compilation-auto-jump-to-first-error old-compilation-auto-jump-to-first-error))
      (my/tcl-find-error))))

(require 'tcl)

;(setq compilation-error-regexp-alist (cdr compilation-error-regexp-alist))
(setq compilation-error-regexp-alist-alist (cdr compilation-error-regexp-alist-alist))


(defun my/tcl-mode-setup ()
  (add-hook 'compilation-finish-functions 'my/tcl-find-error)
  (when (my/tcl-test-p)
    (local-set-key [f10] 'my/tcl-compile-test)))

(add-hook 'tcl-mode-hook 'my/tcl-mode-setup)

(setq auto-mode-alist (cons '("\\.test" . tcl-mode) auto-mode-alist))
(push "test" tcl-proc-list)
(tcl-set-proc-regexp)
(tcl-set-font-lock-keywords)



