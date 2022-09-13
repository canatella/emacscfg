(use-package trivial-adoc-mode :quelpa
  (trivial-adoc-mode :fetcher github :repo "canatella/emacs-trivial-adoc-mode"))

(use-package structurizr-mode :quelpa
  (structurizr-mode :fetcher github :repo "canatella/structurizr-mode" :branch "fix-package-header"))

(use-package plantuml-mode
  :ensure t
  :mode (("\\.puml\\'" . plantuml-node)
         ("\\.iuml\\'" . plantuml-mode))
  :custom (plantuml-default-exec-mode 'executable "Use jar for previewing")
  (plantuml-executable-args '("-headless" "-nbthread")))
