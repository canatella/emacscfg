(use-package ediff
  :ensure t
  :hook (ediff-mode . my-ediff-setup)
  :custom
  (ediff-split-window-function #'split-window-horizontally "Split window horizontaly in Ediff.")
  (ediff-merge-split-window-function #'my-ediff-split-window "Split window A/B horizontally and C/ancestor vertically.")
  (ediff-window-setup-function #'ediff-setup-windows-plain "Put all Ediff buffers in the same frame.")
  :config
  (defun my-ediff-split-window ()
    "Split window horizontally for A and B, and vertically for merged and ancertor."
    ;; if current window is window C, split vertically
    (if (equal "*ediff-merge*" (buffer-name))
        (split-window-vertically)
      (split-window-horizontally)))
  (defun my-ediff-setup ()
    (setq ediff-merge-window-share 0.65)))
