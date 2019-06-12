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
(customize-set-variable 'custom-file "/dev/null")

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


;;(org-babel-load-file (concat user-emacs-directory "config.org"))
(use-package load-dir
  :ensure t
  :custom
  (load-dir-debug '()))
(load-dir-one "~/.emacs.d/config")

(gc-cons-threshold-normal)
(message "dvone")
;;(put 'dired-find-alternate-file 'disabled nil)
;;; init.el ends here
