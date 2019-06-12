(use-package flycheck-cask
  :ensure t
  :after flycheck
  :after cask-mode
  :hook (flycheck-mode . flycheck-cask-setup))
