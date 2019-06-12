(use-package clang-format
  :ensure t
  :config
  (defun my-clang-format-setup ()
    "Reindent buffer or region with clang."
    (local-set-key [C-M-tab] #'clang-format-region)
    (local-set-key [f2] #'clang-format-buffer))
  (add-hook 'c-mode-common-hook #'my-clang-format-setup))
