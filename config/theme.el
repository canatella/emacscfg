(use-package solarized-theme
  :disabled
  :ensure t
  :custom
  (solarized-distinct-fring-background '())
  (solarized-use-less-bold t)
  (solarized-use-variable-pitch '())
  :config
  (load-theme 'solarized-dark))

(use-package color-theme-sanityinc-tomorrow
  :disabled
  :ensure t
  :config
  (color-theme-sanityinc-tomorrow-eighties))

(use-package arjen-grey-theme
  :disabled
  :ensure t
  :config
  (load-theme 'arjen-grey))

(use-package sunburn-theme
  :ensure t
  :config
  (load-theme 'sunburn))
