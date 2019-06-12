(use-package projectile
  :ensure t
  :bind (("H-f" . maybe-projectile-find-file))
  :diminish "ⓟ"
  :custom
  (projectile-switch-project-action 'projetile-vc
                                    "Open `magit' when switching to a project.")
  (projectile-mode-line-fn #'my-projectile-mode-line-fn
                           "Use a smaller unicode modeline indicator.")
  (projectile-completion-system 'ivy)
  :config
  (projectile-mode t)
  (defun my-projectile-mode-line-fn ()
    (if (projectile-project-p) "ⓟ" ""))
  (defun maybe-projectile-find-file ()
    "Call projectile grep when in a managed project, rgrep otherwise."
    (interactive)
    (call-interactively
     (if (projectile-project-p)
         #'projectile-find-file #'find-file)))
  (defun maybe-projectile-ag ()
    "Call projectile ag when in a managed project, rgrep otherwise."
    (interactive)
    (call-interactively
     (if (projectile-project-p)
         #'helm-do-ag-project-root #'helm-do-ag)))
  (projectile-mode t))
