(use-package smartparens
  :ensure t
  :diminish
  :bind (("H-<right>" . #'sp-forward-sexp)
         ("H-M-<right>" . #'sp-next-sexp)
         ("H-<left>" . #'sp-backward-sexp)
         ("H-M-<left>" . #'sp-previous-sexp)
         ("H-<down>" . #'sp-down-sexp)
         ("H-<up>" . #'sp-up-sexp)
         ("H-a" . #'sp-beginning-of-sexp)
         ("H-e" . #'sp-end-of-sexp)
         ("H-d" . #'sp-kill-sexp)
         ("H-<backspace>" . #'sp-backward-kill-sexp)
         ("H-M-d" . #'sp-copy-sexp)
         ("H-M-<backspace>" . #'sp-backward-copy-sexp)
         ("H-M-t" . #'sp-transpose-sexp)
         ("H-C-<right>" . #'sp-forward-slurp-sexp)
         ("H-C-<left>" . #'sp-forward-barf-sexp)
         ("H-'" . #'sp-change-inner)
         ("H-@" . #'sp-mark-sexp)
         :map c-mode-map
         ("H-C-<right>" . #'sp-slurp-hybrid-sexp))
  :config
  (smartparens-global-mode t)
  (require 'smartparens-ruby)
  (require 'smartparens-config)
  ;; Add new line after {}
  (sp-with-modes
      '(c++-mode objc-mode c-mode java-mode js-mode rust-mode)
    (sp-local-pair "{" nil :post-handlers '(:add ("||\n[i]" "RET")))))
