(add-hook 'latex-mode-hook
	  (lambda () (local-set-key (kbd "\C-c \C-e") 'tex-close-latex-block)))

(provide 'init-latex)
