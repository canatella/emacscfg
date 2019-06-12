(use-package cc-mode
  :custom
  (c-basic-offset 2 "Use 2 spaces for indentation.")
  :dash
  (c++-mode "C++")
  (java-mode "Android")
  :config
  (defun my-c-mode-common-setup ()
    "Use auto fill and subword mode."
    (turn-on-auto-fill)
    (subword-mode t))
  (defun my-c++-mode-setup ())
  (add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
  (add-hook 'c-mode-common-hook #'my-c-mode-common-setup)
  (add-hook 'c++-mode-hook #'my-c++-mode-setup))
