(use-package typescript-mode
  :ensure t
  :after (reformatter)
  :custom (typescript-indent-level 2)
  :hook (typescript-mode . typescript-format-on-save-mode)
  :config
  (reformatter-define
   typescript-format
   :program "npx"
   :args '("prettier" "--stdin-filepath" "--parser=typescript")))
