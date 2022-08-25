;; -*- lexical-binding: t; -*-

(use-package cask-mode :ensure t)

(use-package elfmt :quelpa (elfmt :fetcher github :repo "riscy/elfmt"))

(use-package test-runner-ert ;;
  :requires (test-runner)
  :config (add-to-list 'safe-local-variable-values '(test-runner-ert-load-path . ("." "../test-runner"))))

(use-package  elisp-mode)

(use-package elisp-format
  :ensure t
  :config (define-minor-mode elisp-format-on-save-mode
            "When enabled, call `elisp-format-buffer' when this buffer is saved."
            :lighter nil
            (if elisp-format-on-save-mode
                (add-hook 'before-save-hook #'elfmt nil t)
              (remove-hook 'before-save-hook #'elfmt t))))

(use-package form-feed :ensure t :diminish :hook (emacs-lisp-mode . form-feed-mode))

(use-package nameless
  :ensure t
  :hook (emacs-lisp-mode . nameless-mode)
  :bind (("C-c n" . nameless-insert-name))
  :custom (nameless-prefix "…-")
  (nameless-abbrev-prefix "ns")
  :custom-face (nameless-face ((t ()))))
