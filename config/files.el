(use-package files
  :bind (([f6] . revert-buffer)
         ([f7] . make-directory))
  :custom
  (backup-directory-alist
   '(("." . "~/.emacs.d/backup-filesd"))
   "Do no clutter file system with emacs backup files."))
