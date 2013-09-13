(defun my/eshell-prompt ()
  (let ((user-name (getenv "USER"))
        (host-name (getenv "HOSTNAME"))
        (current-directory (abbreviate-file-name (eshell/pwd)))
        (prompt-char (if (zerop (user-uid)) "#" "$")))
    (format "\n%s@%s:%s\n\n%s " user-name host-name current-directory prompt-char)))
         
(setq eshell-prompt-function 'my/eshell-prompt)
