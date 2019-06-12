(use-package flycheck
  :ensure t
  :custom
  (flycheck-mode-line-prefix "ⓕ"
                             "Change lighter.")
  (flycheck-mode-line '(:eval (my-flycheck-mode-line-status-text)))
  :config
  (defun my-flycheck-mode-line-status-text (&optional status)
    (let ((text (pcase (or status flycheck-last-status-change)
                  (`not-checked "")
                  (`no-checker "")
                  (`running (propertize "ⓕ" 'font-lock-face
                                        '(:foreground "#aaaaaa")))
                  (`errored (propertize "ⓕ" 'font-lock-face
                                        '(:strike-through t)))
                  (`finished
                   (let-alist (flycheck-count-errors flycheck-current-errors)
                     (if (or .error .warning)
                         (propertize "ⓕ" 'font-lock-face
                                     '(:foreground "red"))
                       "ⓕ")))
                  (`interrupted ".")
                  (`suspicious "?"))))
      text))
  (global-flycheck-mode))
