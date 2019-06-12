(use-package spaceline-all-the-icons
  :ensure t
  :after (spaceline all-the-icons)
  :hook (after-init . spaceline-all-the-icons-theme)
  :custom
  (spaceline-all-the-icons-slim-render t "Slimer modeline.")
  (spaceline-all-the-icons-separator-type 'cup "Slimer modeline."))
