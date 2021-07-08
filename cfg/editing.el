;; -*- lexical-binding: t; -*-

(use-package autorevert :custom (auto-revert-mode-text '() "No lighter for autorevert"))

(use-package
  simple
  :diminish auto-fill-function
  "↵"
  :hook (before-save . delete-trailing-whitespace))

(use-package iedit :ensure t)

(use-package mmm-mode :ensure t)

(use-package
  paren
  :custom (show-paren-style 'expression)
  (show-paren-when-point-in-periphery 't)
  (show-paren-when-point-inside-paren 't)
  :config (show-paren-mode 't))

(use-package cc-mode)

(use-package
  smartparens
  :ensure t
  :diminish :config
  (smartparens-global-mode t)
  (defvar sp-custom-bindings
    '(("C-c p <right>" . sp-forward-sexp)
      ("C-c p <left>" . sp-backward-sexp)
      ("C-c p <down>" . sp-down-sexp)
      ("C-c p C-<down>" . sp-backward-down-sexp)
      ("C-c p C-a" . sp-beginning-of-sexp)
      ("C-c p C-e" . sp-end-of-sexp)
      ("C-c p <up>" . sp-up-sexp)
      ("C-c p C-<up>" . sp-backward-up-sexp)
      ("C-c p C-<right>" . sp-next-sexp)
      ("C-c p C-<left>" . sp-previous-sexp)
      ("C-c p C-w" . sp-kill-sexp)
      ("C-c p M-w" . sp-copy-sexp)
      ("C-c p u" . sp-unwrap-sexp)
      ("C-c p C-u" . sp-backward-unwrap-sexp)
      ("C-c p s" . sp-forward-slurp-sexp)
      ("C-c p b" . sp-forward-barf-sexp)
      ("C-c p C-s" . sp-backward-slurp-sexp)
      ("C-c p C-b" . sp-backward-barf-sexp)
      ("C-c p /" . sp-splice-sexp)
      ("C-c p C-d" . sp-splice-sexp-killing-forward)
      ("C-c p <backspace>" . sp-splice-sexp-killing-backward)
      ("C-c p u" . sp-splice-sexp-killing-around)
      ("C-c p @" . sp-select-next-thing-exchange)
      ("C-c p h" . sp-select-next-thing)
      ("C-c p m" . sp-mark-sexp)
      ("C-c p M-<right>" . sp-forward-symbol)
      ("C-c p M-<left>" . sp-backward-symbol)))
  (sp--populate-keymap sp-custom-bindings)
  (require 'smartparens-ruby)
  (require 'smartparens-config)
  ;; Add new line after {}
  (sp-with-modes
      '(c++-mode objc-mode c-mode java-mode js-mode rust-mode)
    (sp-local-pair "{" nil :post-handlers '(:add ("||\n[i]" "RET"))))
  (sp-with-modes '(c++-mode djinni-mode) (sp-local-pair "<" ">")))

(use-package string-inflection :ensure t)

(use-package subword :diminish subword-mode)

(use-package
  wgrep
  :ensure t
  :custom (wgrep-auto-save-buffer t "Automatically save buffer when commiting wgrep changes")
  (wgrep-enable-key "C-c C-q"))

(use-package
  yasnippet
  :ensure t
  :diminish yas-minor-mode
  "ⓨ"
  :bind (("C-c <tab>" . yas-expand))
  :init (yas-global-mode t))
