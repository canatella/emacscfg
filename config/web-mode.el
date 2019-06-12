(use-package web-mode
  :mode "\\.erb\\'"
  :hook (web-mode . my-web-mode-setup)
  :custom
  (web-mode-markup-indent-offset 2)
  :config
  (defun my-web-mode-setup ()
    (smartparens-mode 0)))
