;; -*- lexical-binding: t; -*-

(use-package
  java-imports
  :ensure t
  :config (add-hook 'java-mode-hook 'java-imports-scan-file))

(use-package
  scala-mode
  :ensure t)
