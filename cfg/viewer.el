;; -*- lexical-binding: t; -*-

(use-package nov :straight t :mode ("\\.epub\\'" . nov-mode))

(use-package markdown-mode
  :straight t
  :custom (markdown-fontify-code-blocks-natively t)
  (markdown-command "multimarkdown"))

(use-package osx-browse :straight t :if (string= system-type "darwin"))

(use-package browse-url
  :bind (("C-h s" . browse-url-dwim-search))
  :custom (browse-url-browser-function #'xwwp-browse-url-other-window)
  (browse-url-dwim-search-url "https://duckduckgo.com/?kp=1&kl=us-en&kz=1&kc=-1&kae=d&kaj=m&q="))

(use-package xwidget
  :config (unless (boundp 'xwidget-webkit-enable-plugins) (defvar xwidget-webkit-enable-plugins '())))

(use-package xwwp :straight
  (xwwp :type git :host github :repo "canatella/xwwp")
  :bind (:map xwidget-webkit-mode-map ("v" . xwwp-follow-link))
  :custom (xwwp-follow-link-completion-system 'consult)
  :config (require 'xwwp-follow-link-consult))

(use-package pdf-tools :straight t :config (pdf-tools-install))

(use-package plantuml-mode
  :straight t
  :custom (plantuml-default-exec-mode 'executable "Use jar for previewing")
  (plantuml-executable-args '("-headless" "-nbthread")))

(use-package yaml-mode :straight t :mode (("\\.yml\\'" . yaml-mode)))
