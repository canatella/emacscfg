(use-package vterm :ensure t :custom
  (vterm-kill-buffer-on-exit t)
  (vterm-eval-cmds
   '(("find-file" find-file)
     ("message" message)
     ("vterm-clear-scrollback" vterm-clear-scrollback)
     ("woman" woman)))
  :bind (("C-c e" . vterm-end-of-line)))
