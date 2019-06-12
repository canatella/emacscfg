;; Make sure our bash configured environment variables are correctly setup in
;; Emacs.
(use-package exec-path-from-shell
  :ensure t
  :custom
  (exec-path-from-shell-variables
   '("PATH" "MANPATH" "ANDROID_HOME" "ANDROID_NDK_HOME"))
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))
