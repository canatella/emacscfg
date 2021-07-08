;; -*- lexical-binding: t; -*-

(use-package prescient
  :ensure t
  :custom (prescient-filter-method '(prefix))
  (prescient-sort-length-enable nil)
  :config (prescient-persist-mode 1))

(use-package selectrum :ensure t :config (selectrum-mode))

(use-package selectrum-prescient
  :ensure t
  :after (prescient selectrum)
  :config (selectrum-prescient-mode 1)
  (global-set-key [remap execute-extended-command] 'execute-extended-command))

(use-package embark :ensure t
  :after (selectrum)
  :bind (:map selectrum-minibuffer-map ("C-c C-o" . embark-export) ("C-c C-c" . embark-act-noexit)))

(use-package consult :ensure t
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

(use-package embark-consult :ensure t
  :after (embark consult)
  :hook ((embark-collect-mode . embark-consult-preview-minor-mode)))

(use-package marginalia :ensure t
  :custom (marginalia-annotators '(marginalia-annotators-heavy))
  :config (marginalia-mode))
