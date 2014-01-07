(defun duma/buffer-module ()
  (file-name-nondirectory (directory-file-name (file-name-directory (buffer-file-name)))))

(defun duma/trace-group ()
  (concat "TR_" (upcase (duma/buffer-module))))

(defun duma/project-root ()
  "~/Projects/FCS/03-Duma-code/fcsctrl/")

(defun duma/compile ()
  (interactive)
  (compile (format "make -j 3 -C%s " (duma/project-root))))

(defun duma/check (&optional verbose)
  (interactive "P")
  (compile (format "%s %s.git/hooks/pre-commit"
                   (if verbose "TESTSUITEFLAGS=-v" "") (duma/project-root))))

(defun duma/at-current-test ()
   (save-excursion
     (if (re-search-backward "AT_SETUP(\\[\\([^\]]+\\)\\])" nil t)
         (match-string 1)
       nil)))

(defun duma/at-test-number (test)
  (with-temp-buffer
    (call-process (format "%stests/testsuite" (duma/project-root))
                  nil (current-buffer) nil "-l")
    (goto-char 0)
    (if (re-search-forward (format "^\\s-+\\([0-9]+\\):\\s-+\\S-+\\s-+%s$" test) nil t)
        (string-to-number (match-string 1)))))

(defun duma/at-current-test-number ()
  (let ((test (duma/at-current-test)))
    (when test (duma/at-test-number test))))


(add-to-list 'compilation-error-regexp-alist-alist
             '(testsuite "FAILED (\\(\\([^:]+\\):\\([0-9]+\\)\\))" 2 3 2 1))
(add-to-list 'compilation-error-regexp-alist 'testsuite)

(defun duma/test (&optional valgrind)
  (interactive "P")
  (when (duma/at-current-test)
    (compile (format "cd %stests && make testsuite && ./testsuite AUTOTEST_PATH=src:tests:tests/units %s %d"
                     (duma/project-root) "-v"
                     (duma/at-current-test-number))))
  (unless (duma/at-current-test)
    (let ((executable (file-name-base (buffer-file-name))))
      (compile (format "make -C%s/tests/units %s && %s %s/tests/units/%s"
                       (duma/project-root) executable
                       (if valgrind "valgrind --leak-check=full" "")
                       (duma/project-root) executable)))))

(defun duma/testsuite-log ()
  (interactive)
  (when (duma/at-current-test)
    (let ((log (format "%stests/testsuite.dir/%d/testsuite.log"
                       (duma/project-root) (duma/at-current-test-number))))
      (find-file log))))

(defun duma/configure (&optional reconf)
  (interactive "P")
  (compile (format "cd %s && %s && CONFIG_SITE=config.site ./configure"
                   (duma/project-root)
                   (if reconf "autoreconf" "true"))))

(global-set-key [f10]                   'duma/compile)
(global-set-key [H-f10]                 'duma/check)
(global-set-key (kbd "H-t")             'duma/test)
(global-set-key (kbd "s-t")             'duma/testsuite-log)
(global-set-key (kbd "H-e")            'next-error)


;; display chars as hex
(setq standard-display-table (make-display-table))
(message "%s" standard-display-table)
(let ((i ?\x00) hex hi low)
  (while (<= i ?\xff)
    (when (or (> i ?\x80) (string-match "[^[:print:][:space:]\r\n\t]" (string i)))
      (setq hex (format "%02x" i))
      (setq hi (elt hex 0))
      (setq low (elt hex 1))
      (aset standard-display-table (unibyte-char-to-multibyte i)
            (vector (make-glyph-code ?\\ 'escape-glyph)
                    (make-glyph-code ?x 'escape-glyph)
                    (make-glyph-code hi 'escape-glyph)
                    (make-glyph-code low 'escape-glyph))))
      (setq i (+ i 1))))

(provide 'duma)
