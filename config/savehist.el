(use-package savehist
  :custom
  (savehist-file "~/.emacs.d/var/history"
                 "Do not clutter file system with history save files.")
  (savehist-mode t "Save minibuffer history."))
