;;; use default locale
(setq system-time-locale "C")

;;; backups
(setq backup-directory-alist
      '(("." . "~/.emacs.d/var/backup-files")))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; autofill mode
(dolist (hook (list
               'org-mode-hook
               'text-mode-hook
               'message-mode-hook
               'magit-log-mode
               'LaTeX-mode-hook
               'c-mode-common-hook
               'erc-mode-hook))
  (add-hook hook 'turn-on-auto-fill))

;;; delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'init-tramp)
(require 'init-html)
(require 'init-nxml)
(require 'init-latex)
(require 'init-ruby)
(require 'init-c)
(require 'init-compile)
(require 'init-dired)


(provide 'behaviour)

