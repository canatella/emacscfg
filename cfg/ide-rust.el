;; -*- lexical-binding: t; -*-

(use-package
  racer
  :ensure t)

(use-package
  rust-mode
  :ensure t
  :dash (rust-mode "Rust")
  :custom (rust-format-on-save t))

(use-package
  cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))
