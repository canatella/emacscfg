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
    (if buffer-read-only
        (progn (message "enable write")
         (set-file-modes buffer-file-name (logior (file-modes buffer-file-name) ?\600))
         (setq buffer-read-only nil))
      (progn (message "disabling write")
       (set-file-modes buffer-file-name (logand (file-modes buffer-file-name) ?\444))
       (setq buffer-read-only t)))))