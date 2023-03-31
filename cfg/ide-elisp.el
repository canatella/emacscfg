;; -*- lexical-binding: t; -*-

(use-package cask-mode
  :ensure t)

(use-package
  test-runner-ert ;;
  :requires (test-runner)
  :config (add-to-list 'safe-local-variable-values '(test-runner-ert-load-path . ("." "../test-runner"))))

(use-package elisp-mode)

(use-package elisp-autofmt
  :ensure t
  :hook (emacs-lisp-mode . elisp-autofmt-mode))

(use-package form-feed
  :ensure t
  :diminish
  :hook (emacs-lisp-mode . form-feed-mode))

(use-package nameless
  :ensure t
  :hook (emacs-lisp-mode . nameless-mode)
  :bind (("C-c n" . nameless-insert-name))
  :custom
  (nameless-prefix "…-")
  (nameless-abbrev-prefix "ns")
  :custom-face (nameless-face ((t ()))))

(use-package package-lint
  :ensure t)

(use-package package-lint-flymake
  :ensure t)
