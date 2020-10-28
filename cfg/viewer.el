;; -*- lexical-binding: t; -*-

(use-package nov :ensure t :mode ("\\.epub\\'" . nov-mode))

(use-package markdown-mode
  :ensure t
  :custom (markdown-fontify-code-blocks-natively t)
  (markdown-command "multimarkdown"))

(use-package osx-browse :ensure t :if (string= system-type "darwin"))

(use-package browse-url
  :bind (("C-h s" . browse-url-dwim-search))
  :custom (browse-url-browser-function #'xwwp-browse-url-other-window)
  (browse-url-dwim-search-url "https://duckduckgo.com/?kp=1&kl=us-en&kz=1&kc=-1&kae=d&kaj=m&q="))

(use-package xwidget
  :config (unless (boundp 'xwidget-webkit-enable-plugins) (defvar xwidget-webkit-enable-plugins '())))

(use-package-local xwwp)

(use-package xwwp-follow-link-ivy
  :after (xwwp)
  :bind (:map xwidget-webkit-mode-map ("v" . xwwp-follow-link))
  :custom (xwwp-follow-link-completion-system 'ivy))

(use-package pdf-tools :ensure t :config (pdf-tools-install))

(use-package plantuml-mode
  :ensure t
  :custom (plantuml-default-exec-mode 'executable "Use jar for previewing")
  (plantuml-executable-args '("-headless" "-nbthread")))

(use-package yaml-mode :ensure t :mode (("\\.yml\\'" . yaml-mode)))
