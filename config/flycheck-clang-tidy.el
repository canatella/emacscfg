(use-package flycheck-clang-tidy
  :after flycheck
  :load-path "~/.emacs.d/packages/flycheck-clang-tidy"
  :hook (flycheck-mode . flycheck-clang-tidy-setup))
