(use-package protobuf-mode :ensure t :ensure-system-package prototool)

(use-package-local flymake-prototool :after  protobuf-mode :hook
                   (protobuf-mode . flymake-prototool-load))
