(use-package org
  :ensure t
  :custom (org-src-fontify-natively t "Fontify code blocks.")
  (org-src-tab-acts-natively t "Ident using language behaviour in code blocks.")
  (org-return-follows-link t "Return key follows link")
  :config (add-hook 'org-mode 'turn-on-auto-fill))

(use-package orgit :ensure t)
