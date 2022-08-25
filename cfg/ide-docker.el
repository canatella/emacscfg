(define-minor-mode dockerfile-format-on-save-mode
  "When enabled, call `eglot-format-buffer' when this buffer is saved."
  :lighter nil
  (if dockerfile-format-on-save-mode
      (add-hook 'before-save-hook #'eglot-format-buffer nil t)
    (remove-hook 'before-save-hook #'eglot-format-buffer t))
  (setq-local indent-line-function #'eglot-format-buffer))

(use-package dockerfile-mode :ensure t :after eglot :hook
             (dockerfile-mode . dockerfile-format-on-save-mode)
             :config (add-to-list 'eglot-server-programs `(dockerfile-mode . ("docker-langserver" "--stdio"))))

(use-package docker :ensure t)
