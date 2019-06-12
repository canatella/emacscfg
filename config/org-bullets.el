(use-package org-bullets
    :ensure t
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("■" "□" "◾" "◻")))
