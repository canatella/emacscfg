;; -*- lexical-binding: t; -*-

(use-package cmake-mode :ensure t :custom (cmake-tab-width 4 "configure indent"))

(use-package
  cmake-font-lock
  :ensure t
  :hook (cmake-mode-hook . cmake-font-lock-activate)
  :config (autoload 'cmake-font-lock-activate "cmake-font-lock" nil t))

(use-package eldoc-cmake  :ensure t)

(use-package eglot-clangd :quelpa
  (eglot-clangd :fetcher github :repo "canatella/eglot-clangd")
  :after (cc-mode eglot)
  :bind (:map c-mode-base-map ("C-c o" . eglot-clangd-switch-source-header)))

(use-package test-runner-catch2 :quelpa
  (test-runner-catch2 :fetcher github :repo "canatella/test-runner-catch2-el")
  :after (test-runner))

(use-package cmake-api :quelpa (cmake-api :fetcher github :repo "canatella/cmake-api-el"))

(use-package
  cc-mode
  :custom (c-basic-offset 4 "Use 4 spaces for indentation.")
  (c-doc-comment-style
   '((c-mode . doxygen)
     (c++-mode . doxygen)
     (objc-mode . doxygen)
     (java-mode . javadoc)
     (pike-mode . autodoc)))
  :devdocs (c++-mode "cpp")
  :diminish ((c++-mode . "🅲++")
             (c++//lw-mode . "🅲++"))
  :mode (("\\.impl\\'" . c++-mode)
         ("\\.ino\\'" . c++-mode))
  :config (defun config-c-mode-flyspell-check-word-predicate
              ()
            "Used for `flyspell-generic-check-word-predicate' in c modes."
            (and
             (flyspell-generic-progmode-verify)
             (save-excursion (beginning-of-line) (not (looking-at "^// NOLINT")))))
  (defun config-c-mode-common-setup ()
    "Use auto fill and subword mode."
    (turn-on-auto-fill)
    (subword-mode t)
    (setq flyspell-generic-check-word-predicate #'config-c-mode-flyspell-check-word-predicate)
    (define-key c-mode-base-map [remap c-indent-line-or-region] #'completion-at-point))
  (add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
  (add-hook 'c-mode-common-hook #'config-c-mode-common-setup))

(use-package gud-lldb :disabled)

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

(with-eval-after-load 'reformatter
  (reformatter-define cmake-format :program "cmake-format" :args
    (let ((args
           `("-c"
             ,@(let* ((main
                       (expand-file-name
                        (locate-dominating-file default-directory ".cmake-format.yaml")))
                      (global (concat main ".cmake-format.yaml"))
                      (project (concat main "cmake-format.yaml")))
                 (seq-filter #'identity (list global (when (file-exists-p project) project))))
             "-o" "-" "-")))
      (message "cmake-format %s" args)
      args)))

(use-package djinni-mode :quelpa (djinni-mode :fetcher github :repo "canatella/djinni-mode"))
