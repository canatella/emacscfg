(use-package projectile-rails
  :ensure t
  :after projectile
  :diminish
  :dash
  (projectile-rails-mode "Ruby_2" "Ruby_on_Rails_4")
  :custom
  (projectile-rails-keymap-prefix (kbd "C-c r")
                                  "Map `projectile-rails' key map to C-c r.")
  :config
  (defun projectile-rails--snippet-for-module (last-part name)
    nil)
  (projectile-rails-global-mode))
