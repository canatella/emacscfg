(add-hook 'nxml-mode-hook
	  (lambda () (local-set-key (kbd "\C-c \C-e") 'nxml-finish-element)))

(provide 'init-nxml)
