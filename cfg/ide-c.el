;; -*- lexical-binding: t; -*-

(use-package cmake-mode :ensure t :dash "CMake" :custom (cmake-tab-width 4 "configure indent"))

(use-package
  cmake-font-lock
  :ensure t
  :hook (cmake-mode-hook . cmake-font-lock-activate)
  :config (autoload 'cmake-font-lock-activate "cmake-font-lock" nil t))

(use-package eldoc-cmake :ensure t)

(use-package-local
    eglot-clangd
  :after (cc-mode eglot)
  :bind (:map c-mode-base-map ("C-c o" . eglot-clangd-switch-source-header)))

(use-package-local test-runner-catch2 :after (test-runner))

(use-package-local cmake-api)

(use-package
  cc-mode
  :custom (c-basic-offset 4 "Use 4 spaces for indentation.")
  (c-doc-comment-style
   '((c-mode . doxygen)
     (c++-mode . doxygen)
     (objc-mode . doxygen)
     (java-mode . javadoc)
     (pike-mode . autodoc)))
  :dash (c++-mode "C++" "Firebase")
  (java-mode "Android")
  (objc-mode "Foundation")
  :diminish ((c++-mode . "🅲++")
             (c++//lw-mode . "🅲++"))
  :mode ("\\.impl\\'" . c++-mode)
  :config (defun config-c-mode-common-setup
              ()
            "Use auto fill and subword mode."
            (turn-on-auto-fill)
            (subword-mode t))
  (add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
  (add-hook 'c-mode-common-hook #'config-c-mode-common-setup))

(use-package gud-lldb)

(defun c++-declare-at-point ()
  "Convert virtual definition to an override definition."
  (interactive)
  (save-excursion
    (end-of-line)
    (when (search-backward-regexp "virtual\s+\\(\n\s*\\)?\\([^=]+\\) = 0;" nil t)
      (let ((decl (match-string 2)))
        (replace-match (format "%s override;" decl))))))

(use-package
  cov
  :ensure t
  :after sunburn-theme
  :custom (cov-coverage-mode nil)
  :config (sunburn-with-color-variables
            (custom-set-faces
             `(cov-coverage-run-face ((t :foreground ,sunburn-green+1)))
             `(cov-coverage-not-run-face ((t :foreground ,sunburn-red+1)))
             `(cov-none-face ((t :foreground ,sunburn-red+1)))
             `(cov-heavy-face ((t :foreground ,sunburn-green+3)))
             `(cov-med-face ((t :foreground ,sunburn-green+3)))
             `(cov-light-face ((t :foreground ,sunburn-green+4))))))

(use-package-local djinni-mode)
