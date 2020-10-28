;; -*- lexical-binding: t; -*-

(use-package-local cerbere ;;
  :diminish "ⓒ" ;;
  :config ;;
  (cerbere-global-mode 't))

(use-package reformatter :ensure t)

(use-package company :ensure t :diminish :hook (after-init . global-company-mode))

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

(use-package diff :custom (diff-switches "-u" "Use universal diff format."))

(use-package ediff
  :hook (ediff-mode . my-ediff-setup)
  :custom ;;
  (ediff-split-window-function #'split-window-horizontally "Split window horizontaly in Ediff.")
  (ediff-merge-split-window-function #'my-ediff-split-window
                                     "Split window A/B horizontally and C/ancestor vertically.")
  (ediff-window-setup-function #'ediff-setup-windows-plain
                               "Put all Ediff buffers in the same frame.")
  :config ;;
  (defun config-ediff-split-window ()
    "Split window horizontally for A and B, and vertically for merged and ancertor."
    ;; if current window is window C, split vertically
    (if (equal "*ediff-merge*" (buffer-name))
        (split-window-vertically)
      (split-window-horizontally)))
  (defun config-ediff-setup () (setq ediff-merge-window-share 0.65)))

(use-package dtrt-indent
  :ensure t
  :diminish ;;
  :custom; ;
  (dtrt-indent-active-mode-line-info "" "Remove mode line info.")
  :config (dtrt-indent-global-mode t))

(use-package-local eglot
  :hook ((c-mode c++-mode objc-mode)
         . eglot-ensure)
  :custom ;;
  (eglot-auto-reconnect t))

(use-package
  eldoc
  :diminish ;;
  :custom ;;
  (global-eldoc-mode -1 "disable eldoc in every buffer")
  (eldoc-echo-area-use-multiline-p t))

(use-package flymake :hook ((emacs-lisp-mode) . flymake-mode) :diminish "ⓕ")

(use-package-local flymake-cursor
  :custom ;;
  (flymake-cursor-auto-enable t "Always enable flymake cursor"))

(use-package git-timemachine :ensure t)

(use-package
  magit
  :ensure t
  :bind (([f8] . magit-status))
  :custom ;;
  (magit-save-repository-buffers 'dontask "Do not ask to save buffer when refreshing.")
  (magit-wip-after-apply-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-save-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-save-local-mode-lighter '() "No indicator for work in progress in modline.")
  (magit-wip-after-apply-mode t "Track work in progress in a git branch.")
  :init ;;
  (require 'subr-x))

(use-package gud)
