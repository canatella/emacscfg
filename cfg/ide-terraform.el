(use-package terraform-mode :ensure-system-package terraform    :mode "\\.tf\\'"
  :ensure t
  :after (reformatter)
  :hook (terraform-mode . terraform-format-on-save-mode)
  :config (reformatter-define terraform-format :program "terraform" :args '("fmt" "-")))
