;; reindent buffer
(defun my-indent-buffer ()
  "indent the buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max))
  (untabify (point-min) (point-max)))

;;; reopen a file using sudo
(defun my-file-reopen-as-root ()
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
	     buffer-file-name))))

;;; make a file writeable
(defun my-file-make-writeable ()
  (interactive)
  (when buffer-file-name
        (setq buffer-read-only (not buffer-read-only))))

