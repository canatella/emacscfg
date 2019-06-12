(use-package lsp-mode
  :commands lsp
  :ensure t
  :custom
  (lsp-prefer-flymake '()))

(use-package lsp-ui
  :ensure t
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))

(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config (push 'company-lsp company-backends))

(use-package ccls
  :ensure t
  :custom
  (ccls-executable  "ccls")
  (ccls-initialization-options '(:compilationDatabaseDirectory "cmake-build-debug"))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))
