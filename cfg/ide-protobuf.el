(use-package protobuf-mode :straight t :ensure-system-package prototool)

(use-package flymake-prototool :straight
  (flymake-prototool :type git :host github :repo "canatella/flymake-prototool")
  :after  protobuf-mode :hook
  (protobuf-mode . flymake-prototool-load))
