;; -*- lexical-binding: t; -*-
(use-package use-package-ensure-system-package :straight t)

(use-package no-littering :straight t
  :config (setq auto-save-file-name-transforms
                `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package async :straight t)

(use-package dash-docs :straight
  (dash-docs :repo "canatella/dash-docs" :branch "add-use-package-keyword")
  :after (async)
  :demand t :config
  (mkdir "~/.docsets" t))

(use-package diminish :straight t)

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
  (safe-local-variable-values '((flycheck-disabled-checkers emacs-lisp-checkdoc)))
  :config (open-dribble-file "~/.emacs.d/var/dribble"))

(use-package exec-path-from-shell
  :straight t
  :custom (exec-path-from-shell-variables
           '("PATH" "MANPATH" "ANDROID_HOME" "ANDROID_NDK_HOME" "ARTIFACTORY_USER" "ARTIFACTORY_PASSWORD" "BITBUCKET_USER" "BITBUCKET_PASSWORD" "FIRESTORE_EMULATOR_HOME" "JLINK_SERIAL_NRF52" "JLINK_SERIAL_SAM4S"))
  :config (exec-path-from-shell-initialize))

(use-package helpful
  :straight t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h F" . helpful-function)
         ("C-h C" . helpful-command)))

(use-package info+
  :straight t
  :disabled t
  :config (setq face-remapping-alist
                (append face-remapping-alist
                        '((info-quoted-name . font-lock-constant-face)
                          (info-double-quoted-name . font-lock-string-face)))))

(use-package recentf
  :config (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(use-package savehist :custom (savehist-mode t "Save minibuffer history."))

(use-package time :custom (display-time-24hr-format t))

(use-package which-key
  :straight t
  :diminish which-key-mode
  :config (setq inhibit-changing-match-data nil)
  (which-key-mode))

(require 'bepo)
(bepo-global-mode)

(use-package eshell :custom (pcomplet-cycle-completions '() "complete like bash"))

(use-package envrc :straight t :config (envrc-global-mode))

(use-package tramp :custom
  (tramp-default-method "ssh")
  (tramp-connection-timeout 5)
  (tramp-shell-prompt-pattern "\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>].* *\\(^[\\[[0-9;]*[a-zA-Z] *\\)*" "Fix remote shell detection with vterm"))

(defun config-delete-process-at-point ()
  "Kill process at point in process list buffers."
  (interactive)
  (let ((process (get-text-property (point) 'tabulated-list-id)))
    (cond
     ((and process (processp process))
      (delete-process process)
      (revert-buffer))
     (t (error "No process at point!")))))

(define-key process-menu-mode-map (kbd "k") #'config-delete-process-at-point)
