(use-package org
  :custom
  (org-src-fontify-natively t "Fontify code blocks.")
  (org-src-tab-acts-natively t "Ident using language behaviour in code blocks.")
  (org-return-follows-link t "Return key follows link")
  :config
  (add-hook 'org-mode 'turn-on-auto-fill)
  (add-hook 'org-shiftup-final-hook 'windmove-up)
  (add-hook 'org-shiftleft-final-hook 'windmove-left)
  (add-hook 'org-shiftdown-final-hook 'windmove-down)
  (add-hook 'org-shiftright-final-hook 'windmove-right))

(use-package orgit
  :ensure t)
