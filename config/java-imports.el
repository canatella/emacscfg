(use-package java-imports
  :ensure t
  :config
  (add-hook 'java-mode-hook 'java-imports-scan-file))
