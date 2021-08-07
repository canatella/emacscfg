(use-package terraform-mode :ensure-system-package terraform :straight t   :mode "\\.tf\\'"
  :after (reformatter)
  :hook (terraform-mode . terraform-format-on-save-mode)
  :config (reformatter-define terraform-format :program "terraform" :args '("fmt" "-")))

(use-package company-terraform :straight t)
