;; -*- lexical-binding: t; -*-

(use-package
  autorevert
  :custom (auto-revert-mode-text '() "No lighter for autorevert"))

(use-package
  simple
  :diminish auto-fill-function
  "↵"
  :hook (before-save . delete-trailing-whitespace))

(use-package
  iedit
  :ensure t)

(use-package
  mmm-mode
  :ensure t
  :custom-face (mmm-default-submode-face ((t
                                           (:background "#433844")))))

(use-package
  paren
  :custom (show-paren-style 'expression)
  (show-paren-when-point-in-periphery 't)
  (show-paren-when-point-inside-paren 't)
  :custom-face (show-paren-match-expression ((t
                                              (:background "#686369"))))
  :config (show-paren-mode 't))

(use-package cc-mode)
(use-package
  smartparens
  :ensure t
  :diminish
  :bind (("s-<right>" . #'sp-forward-sexp)
         ("s-M-<right>" . #'sp-next-sexp)
         ("s-<left>" . #'sp-backward-sexp)
         ("s-M-<left>" . #'sp-previous-sexp)
         ("s-<down>" . #'sp-down-sexp)
         ("s-<up>" . #'sp-up-sexp)
         ("s-a" . #'sp-beginning-of-sexp)
         ("s-e" . #'sp-end-of-sexp)
         ("s-d" . #'sp-kill-sexp)
         ("s-<backspace>" . #'sp-backward-kill-sexp)
         ("s-M-d" . #'sp-copy-sexp)
         ("s-M-<backspace>" . #'sp-backward-copy-sexp)
         ("s-M-t" . #'sp-transpose-sexp)
         ("s-C-<right>" . #'sp-forward-slurp-sexp)
         ("s-C-<left>" . #'sp-forward-barf-sexp)
         ("s-'" . #'sp-change-inner)
         ("s-@" . #'sp-mark-sexp)
         :map c-mode-map ("s-C-<right>" . #'sp-slurp-hybrid-sexp))
  :config (smartparens-global-mode t)
  (require 'smartparens-ruby)
  (require 'smartparens-config)
  ;; Add new line after {}
  (sp-with-modes '(c++-mode objc-mode c-mode java-mode js-mode rust-mode)
    (sp-local-pair "{" nil
                   :post-handlers '(:add ("||\n[i]" "RET"))))
  (sp-with-modes '(c++-mode djinni-mode)
    (sp-local-pair "<" ">")))

(use-package
  string-inflection
  :ensure t)

(use-package
  subword
  :diminish subword-mode)

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
