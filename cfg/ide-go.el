(use-package go-mode :ensure t :hook ((go-mode . gofmt-before-save) (go-mode . eglot-ensure)))
