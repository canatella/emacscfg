;; -*- lexical-binding: t; -*-
(use-package use-package-ensure-system-package :ensure t)

(use-package no-littering :ensure t)

(use-package async :ensure t)

(use-package-local dash-docs :after (async) :config (mkdir "~/.docsets" t))

(use-package diminish :ensure t)

(use-package emacs
  :hook ((minibuffer-setup . gc-cons-threshold-max)
         (minibuffer-exit . gc-cons-threshold-normal))
  :custom ;;
  (inhibit-startup-screen t "No startup screen.")
  (ctl-arrow '() "Display octal value for control chars.")
  (display-raw-bytes-as-hex t "Use hexadecimal for non printable bytes.")
  (fill-column 100 "Auto fill at 100 chars.")
  (split-height-threshold '() "do not split window verticaly unless I ask for it.")
  (indent-tabs-mode '() "Use spaces for indentation.")
  (bidi-paragraph-direction 'left-to-right "No need to spend cpu time on guessing text direction")
  (bidi-inhibit-bpa t "No need to spend cpu time on guessing text direction")
  (global-so-long-mode t)
  :config (open-dribble-file "~/.emacs.d/var/dribble"))

(use-package files
  :custom (safe-local-variable-values '((flycheck-disabled-checkers emacs-lisp-checkdoc))))

(use-package exec-path-from-shell
  :ensure t
  :custom (exec-path-from-shell-variables
           '("PATH" "MANPATH" "ANDROID_HOME" "ANDROID_NDK_HOME" "ARTIFACTORY_USER" "ARTIFACTORY_PASSWORD" "BITBUCKET_USER" "BITBUCKET_PASSWORD" "FIRESTORE_EMULATOR_HOME" "JLINK_SERIAL_NRF52" "JLINK_SERIAL_SAM4S"))
  :config (when (memq window-system '(mac ns)) (exec-path-from-shell-initialize)))

(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h F" . helpful-function)
         ("C-h C" . helpful-command)))

(use-package info+
  :config (setq face-remapping-alist
                (append face-remapping-alist
                        '((info-quoted-name . font-lock-constant-face)
                          (info-double-quoted-name . font-lock-string-face)))))

(use-package recentf
  :config (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(use-package savehist :custom (savehist-mode t "Save minibuffer history."))

(use-package server :config (server-start))

(use-package time :custom (display-time-24hr-format t))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config (setq inhibit-changing-match-data nil)
  (which-key-mode))

(use-package bepo :config (bepo-global-mode))

(use-package eshell :custom (pcomplet-cycle-completions '() "complete like bash"))
