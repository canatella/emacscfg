;; -*- lexical-binding: t; -*-

(use-package
  racer
  :straight t)

(use-package
  rust-mode
  :straight t
  :dash (rust-mode "Rust")
  :custom (rust-format-on-save t))

(use-package
  cargo
  :straight t
  :hook (rust-mode . cargo-minor-mode))
