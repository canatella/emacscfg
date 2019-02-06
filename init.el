;;; init.el --- Canatella's Emacs configuration

;;; Commentary:

;; This is my personal Emacs configuration.

;;; Code:


;; collect garbage after loading the config file.
(defvar gc-cons-threshold-default gc-cons-threshold
  "Default value fo `gc-cons-threshold'.")

(defun gc-cons-threshold-max ()
  "Disable gc."
  (setq gc-cons-threshold-default gc-cons-threshold)
  (setq gc-cons-threshold most-positive-fixnum))

(defun gc-cons-threshold-normal ()
  "Enable gc."
  (setq gc-cons-threshold gc-cons-threshold-default))

(gc-cons-threshold-max)

;; Custom variables are setup using use-package.
(customize-set-variable 'custom-file nil)

;; This is for my custom packages
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

;; Packages
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(setq use-package-verbose t)

(eval-when-compile
  (add-to-list 'load-path (concat user-emacs-directory "packages/use-package/"))
  (require 'use-package)

  (use-package helm-dash
    :load-path "~/.emacs.d/packages/helm-dash"
    :config
    (mkdir "~/.docsets" t)
    (setq helm-dash-docsets '()))


  (use-package diminish
    :ensure t))

(require 'my-secrets)
(setq custom-safe-themes t)

(org-babel-load-file (concat user-emacs-directory "config.org"))

(gc-cons-threshold-normal)

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-file nil)
 '(display-buffer-alist '((".*" display-buffer-reuse-window (reusable-frames . t))))
 '(exec-path-from-shell-variables '("PATH" "MANPATH" "ANDROID_HOME" "ANDROID_NDK_HOME"))
 '(frame-background-mode 'dark)
 '(initial-frame-alist '((vertical-scroll-bars) (fullscreen . maximized)))
 '(mac-command-modifier 'hyper)
 '(mac-option-modifier 'meta)
 '(mac-right-command-modifier 'hyper)
 '(mac-right-option-modifier nil)
 '(ns-alternate-modifier 'meta)
 '(ns-command-modifier 'hyper)
 '(ns-right-alternate-modifier nil)
 '(ns-right-command-modifier 'hyper)
 '(package-selected-packages
   '(rb-env rbenv ivy ivy-dired-history ivy-explorer ivy-prescient 0xc dts-mode electric-spacing password-store yasnippet yari yaml-mode which-key wgrep-ag sx sunburn-theme string-inflection spaceline-all-the-icons sos smex smartparens slack scala-mode ruby-block ruby-additional rubocop robe rhtml-mode repo racer quelpa-use-package projectile-rails php-mode pdf-tools osx-browse orgit org-sync org-redmine ns-auto-titlebar nov nodejs-repl multi-line language-detection java-imports itail htmlize helpful helm-fuzzier helm-flx helm-ag grayscale-theme google-this god-mode git-timemachine gist flycheck-rust flycheck-clang-tidy exec-path-from-shell elmine dtrt-indent dired-subtree dired-ranger dired-rainbow dired-narrow dired-filter dired-collapse diminish creamsody-theme counsel-projectile counsel-osx-app counsel-dash color-theme-sanityinc-tomorrow cmake-mode clang-format cargo bitbake atomic-chrome atom-one-dark-theme arjen-grey-theme all-the-icons-dired ag ac-rtags ac-helm))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eruby-standard-face ((t (:slant italic))))
 '(spaceline-highlight-face ((t (:foreground "#484349" :background "#b48ead" :weight bold)))))
