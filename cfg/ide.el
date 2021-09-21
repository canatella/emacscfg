;; -*- lexical-binding: t; -*-

(use-package test-runner :straight
  (test-runner :type git :host github :repo "canatella/test-runner-el")
  :custom (test-runner-key-prefix (kbd "C-c t")))

(use-package reformatter :straight t)

(use-package
  comint
  :custom (comint-buffer-maximum-size 10000 "Increase make comint buffer size.")
  (comint-prompt-read-only t "The prompt is read only.")
  (comint-scroll-to-bottom-on-input t "Scroll all buffer window.")
  (comint-scroll-show-maximum-output t "Point to end after insertion.")
  (comint-move-point-for-output t "Move point after output."))

(use-package
  ansi-color
  :custom ;;
  (ansi-color-for-comint-mode t "Colorize comint buffers")
  :after (comint)
  :config ;;
  (defun ansi-color-process-compilation-output ()
    (let ((comint-last-output-start compilation-filter-start)) (ansi-color-process-output "")))
  (add-hook 'compilation-filter-hook #'ansi-color-process-compilation-output))

(use-package
  compile
  :bind (([f10] . recompile)
         ([H-f10] . compile)
         ([s-f10] . kill-compilation))
  :diminish '(compilation-in-progress . "⚙")
  :custom ;;
  (compilation-ask-about-save '() "Do not ask for save when compiling.")
  (compilation-scroll-output 'first-error "Scroll down with output, but stop at first error."))

(use-package ispell :config
  (add-to-list 'ispell-skip-region-alist '("^// NOLINTNEXTLINE.*" . "\n")))

(use-package flyspell :hook ((prog-mode . flyspell-prog-mode) (text-mode . flyspell-mode)))

(use-package diff :custom (diff-switches "-u" "Use universal diff format."))

(use-package ediff
  :hook (ediff-mode . cfg-ediff-setup)
  :custom ;;
  (ediff-split-window-function #'split-window-horizontally "Split window horizontaly in Ediff.")
  (ediff-merge-split-window-function #'cfg-ediff-split-window
                                     "Split window A/B horizontally and C/ancestor vertically.")
  (ediff-window-setup-function #'ediff-setup-windows-plain
                               "Put all Ediff buffers in the same frame.")
  :config ;;
  (defun cfg-ediff-split-window ()
    "Split window horizontally for A and B, and vertically for merged and ancertor."
    ;; if current window is window C, split vertically
    (if (equal "*ediff-merge*" (buffer-name))
        (split-window-vertically)
      (split-window-horizontally)))
  (defun cfg-ediff-setup () (setq ediff-merge-window-share 0.65)))

(use-package dtrt-indent
  :straight t
  :diminish ;;
  :custom; ;
  (dtrt-indent-active-mode-line-info "" "Remove mode line info.")
  :config (dtrt-indent-global-mode t))

(use-package eglot
  :hook (((c-mode c++-mode objc-mode python-mode)
          . eglot-ensure)
         (python-mode . eglot-format-on-save-mode))
  :straight t
  :custom ;;
  (eglot-auto-reconnect t)
  (eglot-stay-out-of '(eldoc-documentation-strategy))
  :config ;;
  (define-minor-mode eglot-format-on-save-mode
    "When enabled, call `eglot-format-buffer' when this buffer is saved."
    nil
    :global nil
    (if eglot-format-on-save-mode
        (add-hook 'before-save-hook #'eglot-format-buffer nil t)
      (remove-hook 'before-save-hook #'eglot-format-buffer t))))

(use-package
  eldoc
  :diminish ;;
  :custom ;;
  (global-eldoc-mode -1 "disable eldoc in every buffer")
  (eldoc-echo-area-use-multiline-p t)
  (eldoc-documentation-strategy #'eldoc-documentation-compose))

(use-package flymake :hook ((emacs-lisp-mode) . flymake-mode) :diminish "ⓕ")

(use-package
  magit
  :straight t
  :demand t
  :bind (("C-c m s" . magit-status)
         ("C-c m d" . magit-dispatch)
         ("C-c m f" . magit-file-dispatch))
  :custom ;;
  (magit-define-global-key-bindings '() "Do not define global key bindings")
  (magit-save-repository-buffers 'dontask "Do not ask to save buffer when refreshing.")
  (magit-wip-after-apply-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-save-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-save-local-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-apply-mode t "Track work in progress in a git branch.")
  (magit-repository-directories '(("~/.emacs.d/pkg/" . 1) ("~/bl/repos/" . 1)))
  :init ;;
  (require 'subr-x)
  (require 'magit-extras))

(use-package ghub :straight t)
(use-package closql :straight t)
(use-package forge :straight t)

(use-package xref
  :custom (xref-show-xrefs-function #'xref-show-definitions-completing-read)
  (xref-show-definitions-function #'xref-show-definitions-completing-read))

(use-package gud)

(use-package project
  :custom (project-switch-commands
           '((project-find-file "Find file")
             (project-dired "Dired")
             (project-vterm "Term")
             (magit-project-status "Magit"))))
