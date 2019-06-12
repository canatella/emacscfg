(use-package vip-build
  :after android
  :load-path "~/.emacs.d/packages/vip-build"
  :disabled
  :config
  (vip-build-global-mode t)
  (defun veygo-todo ()
    "Open Veygo todo file"
    (interactive)
    (find-file "~/Dropbox (Personal)/Org/veygo.org")))
