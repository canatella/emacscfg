(use-package protobuf-mode :ensure t :ensure-system-package prototool)

(use-package flymake-easy :ensure t)
(use-package flymake-prototool :quelpa
  (flymake-prototool :fetcher github :repo "canatella/flymake-prototool")
  :after  (protobuf-mode flymake-easy) :hook
  (protobuf-mode . flymake-prototool-load))
