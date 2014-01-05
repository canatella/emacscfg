(add-hook 'sgml-mode-hook
	  (lambda () (local-set-key (kbd "\C-c \C-e") 'sgml-close-tag)))

(provide 'init-html)
