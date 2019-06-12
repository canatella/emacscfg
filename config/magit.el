(use-package magit
  :ensure t
  :bind (([f8] . magit-status))
  :custom
  (magit-save-repository-buffers 'dontask "Do not ask to save buffer when refreshing.")
  (magit-wip-after-apply-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-save-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-save-local-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-apply-mode t "Track work in progress in a git branch.")
  (magit-wip-after-save-mode t "Track work in progress in a git branch."))
