;; -*- lexical-binding: t; -*-

(use-package
  java-imports
  :straight t
  :config (add-hook 'java-mode-hook 'java-imports-scan-file))

(use-package
  scala-mode
  :straight t)
