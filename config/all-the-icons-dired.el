(use-package all-the-icons-dired
  :ensure t
  :after (dired all-the-icons)
  :hook (dired-mode . all-the-icons-dired-mode))
