(defun ruby-close-block ()
  (interactive)
  (unless (string-match "^[[:blank:]]*$" (buffer-substring (line-beginning-position) (line-end-position)))
    (newline))
  (insert "end")
  (ruby-indent-line))

(defun ruby-string-interp ()
  (interactive)
  (insert "#{}")
  (backward-char))

(add-hook 'ruby-mode-hook
          (lambda ()
            (local-set-key (kbd "\C-c \C-e") 'ruby-close-block)
            (local-set-key (kbd "H-,") 'ruby-string-interp)
            (subword-mode 't)))

(provide 'init-ruby)

