;; -*- lexical-binding: t; -*-

(use-package cask-mode :ensure t)

(use-package-local elfmt)

(use-package  elisp-mode :dash (emacs-lisp-mode "Emacs_Lisp"))

(eval-after-load 'elisp-format
  (progn
    (define-minor-mode elisp-format-on-save-mode
      "When enabled, call `elisp-format-buffer' when this buffer is saved."
      nil
      :global nil
      (if elisp-format-on-save-mode
          (add-hook 'before-save-hook #'elfmt nil t)
        (remove-hook 'before-save-hook #'elfmt t)))))

(use-package form-feed :ensure t :diminish :hook (emacs-lisp-mode . form-feed-mode))
