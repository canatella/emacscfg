(use-package terraform-mode :ensure-system-package terraform    :mode "\\.tf\\'"
  :ensure t
  :after (reformatter)
  :hook ((terraform-mode . terraform-format-on-save-mode)
         (terraform-mode . eglot-ensure))
  :mode "\\.tf\\'"
  :config (reformatter-define terraform-format :program "terraform" :args '("fmt" "-"))
  (add-to-list 'eglot-server-programs '(terraform-mode . ("terraform-ls" "serve"))))
