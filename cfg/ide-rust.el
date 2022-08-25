;; -*- lexical-binding: t; -*-

(use-package racer :ensure t)

(use-package rust-mode
  :ensure t
  :devdocs (rust-mode "rust")
  :after (eglot)
  :custom (rust-format-on-save t)
  :config (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer"))))

(use-package cargo :ensure t :hook (rust-mode . cargo-minor-mode))
