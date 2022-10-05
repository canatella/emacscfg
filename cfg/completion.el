;; -*- lexical-binding: t; -*-

(use-package corfu
  :ensure t
  :custom (tab-always-indent 'complete)
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous))
  :init (global-corfu-mode))

(use-package orderless :ensure t :custom (completion-styles '(orderless)))

(use-package vertico :ensure t :config (vertico-mode))

(use-package embark
  :ensure t
  :after (vertico)
  :bind (("C-{" . embark-act)
         ("C-(" . embark-dwim)
         (:map vertico-map ("C-c C-o" . embark-export) ("C-c C-c" . embark-act-noexit))))

(use-package consult
  :ensure t
  :after (project)
  :custom (consult-project-root-function #'project-current-root)
  :bind (([f9] . consult-ripgrep)
         ([remap switch-to-buffer] . consult-buffer)
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
         ([remap switch-to-buffer-other-frame] . consult-buffer-other-frame))
  :config (defun project-current-root
              ()
            "Return current project root."
            (when-let ((project (project-current)))
              (project-root (project-current)))))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t
  :hook ((embark-collect-mode . embark-consult-preview-minor-mode)))

(use-package marginalia
  :ensure t
  :custom (marginalia-annotators '(marginalia-annotators-heavy))
  :config (marginalia-mode))

(use-package abbrev :custom (save-abbrevs nil) :diminish)
