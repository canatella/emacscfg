(use-package org
  :custom
  (org-src-fontify-natively t "Fontify code blocks.")
  (org-src-tab-acts-natively t "Ident using language behaviour in code blocks.")
  (org-return-follows-link t "Return key follows link")
  :config
  (add-hook 'org-mode 'turn-on-auto-fill))

(use-package org-bullets
    :ensure t
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("■" "□" "◾" "◻")))

(use-package orgit :ensure t)
