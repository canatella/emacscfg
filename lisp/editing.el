;; reindent buffer
(defun my/indent-buffer ()
  "indent the buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max))
  (untabify (point-min) (point-max)))

;;; reopen a file using sudo
(defun my/file-reopen-as-root ()
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
	     buffer-file-name))))

;;; make a file writeable
(defun my/file-make-writeable ()
  (interactive)
  (when buffer-file-name
        (setq buffer-read-only (not buffer-read-only))))

;;; save a copy of the file
(setq-default my/copy-path '())
(make-variable-buffer-local 'my/copy-path)


(defun my/file-save-copy-gen ()
  (if (buffer-modified-p)
      (progn
        (save-buffer)
        (dolist (path my/copy-path)
          (message "saving copy into %s" path)
          (write-region nil nil path))
        (cd (file-name-directory (buffer-file-name))))))

(defun my/file-save-copy (path)
  (interactive "FCopy path:")
  (setq my/copy-path (cons path my/copy-path))
  (message "will save copy into %s" my/copy-path)
  (local-set-key (kbd "H-s")  (lambda () (interactive) (my/file-save-copy-gen))))

(defun my/file-cancel-save-copy ()
  (interactive)
  (setq my/copy-path nil))

;; comment a paragraph
(fset 'comment-or-uncomment-paragraph
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217832 67109033 134217853] 0 "%d")) arg)))

;; comment a tag
(defun comment-or-uncomment-tag ()
  "comment or uncomment the current tag"
  (interactive)
  (semantic-error-if-unparsed)
  (let ((current (semantic-current-tag)))
    (if current
        (save-excursion
          (senator-previous-tag)
          (let ((start (point)))
            (senator-next-tag)
            (beginning-of-line)
            (while (not (eql (semantic-current-tag) current))
              (previous-line))
            (comment-or-uncomment-region start (point)))))))

(defun senator-previous-function-tag ()
  "go to previous function tag"
  (interactive)
  (if (not (eql (cadr (senator-previous-tag)) 'function))
      (senator-previous-function-tag)))

(defun senator-next-function-tag ()
  "go to next function tag"
  (interactive)
  (if (not (eql (cadr (senator-next-tag)) 'function))
      (senator-next-function-tag)))

(defun my/switch-buffer-other-window ()
  (interactive)
  (save-selected-window
    (ido-switch-buffer-other-window)))

(defun my/make-run-current-target ()
  (interactive)
  (if (re-search-backward "^\\([^:=\t\n]+\\):" nil t)
      (compile (format "make %s" (match-string 1)))
    (compile "make")))

(add-hook 'makefile-mode-hook 
          (lambda ()
            (local-set-key [f10] 'my/make-run-current-target)))

(defun my/buffer-file-name-copy ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(provide 'editing)
