(use-package spaceline
  :ensure t
  :after sunburn-theme
  :config
  (setq spaceline-minor-modes-separator "")
  (require 'spaceline-config)
  (sunburn-with-color-variables
    (custom-set-faces `(spaceline-highlight-face
                        ((t (:foreground ,sunburn-bg
                             :background ,sunburn-magenta
                             :weight bold)))))))
