(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode "ⓨ"
  :bind (("C-c <tab>" . yas-expand))
  :init
  (yas-global-mode t))
