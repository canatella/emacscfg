;; -*- lexical-binding: t; -*-
(use-package use-package-ensure-system-package :ensure t
  :config (add-to-list 'display-buffer-alist '("*system-packages*" . (display-buffer-no-window . nil))))

(use-package no-littering  :ensure t
  :custom (auto-save-file-name-transforms `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package devdocs :quelpa
  (devdocs :fetcher github :repo "canatella/devdocs.el" :branch "use-package")
  :bind (("C-h ." . devdocs-lookup)))

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
  (window-min-width 110)
  (safe-local-variable-values '((flycheck-disabled-checkers emacs-lisp-checkdoc)))
  :config (open-dribble-file "~/.emacs.d/var/dribble")
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons
     (format "[CRM%s] %s"
             (replace-regexp-in-string "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" "" crm-separator)
             (car args))
     (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)
  (setq minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

(use-package exec-path-from-shell
  :ensure t
  :custom (exec-path-from-shell-variables
           '("PATH" "MANPATH" "ANDROID_HOME" "ANDROID_NDK_HOME" "ARTIFACTORY_USER" "ARTIFACTORY_PASSWORD" "BITBUCKET_USER" "BITBUCKET_PASSWORD" "FIRESTORE_EMULATOR_HOME" "JLINK_SERIAL_NRF52" "JLINK_SERIAL_SAM4S"))
  :config (exec-path-from-shell-initialize))

(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h F" . helpful-function)
         ("C-h C" . helpful-command))
  :config ;; REVIEW See Wilfred/elisp-refs#35. Remove once fixed upstream.
  (defvar read-symbol-positions-list nil))

(use-package info+
  :ensure t
  :disabled t
  :config (setq face-remapping-alist
                (append face-remapping-alist
                        '((info-quoted-name . font-lock-constant-face)
                          (info-double-quoted-name . font-lock-string-face)))))

(use-package recentf
  :ensure t
  :config (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(use-package savehist :custom (savehist-mode t "Save minibuffer history."))

(use-package time :custom (display-time-24hr-format t))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config (setq inhibit-changing-match-data nil)
  (which-key-mode))

(require 'bepo)
(bepo-global-mode)

(use-package eshell :custom (pcomplet-cycle-completions '() "complete like bash"))

(use-package envrc :ensure t :custom (envrc-lighter nil) :config (envrc-global-mode))

(use-package tramp :custom
  (tramp-default-method "ssh")
  (tramp-connection-timeout 5)
  (tramp-ssh-controlmaster-options
   (concat "-o ControlPath=/tmp/ssh-%%r@%%h:%%p " "-o ControlMaster=auto -o ControlPersist=10m"))
  (tramp-shell-prompt-pattern
   "\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>].* *\\(^[\\[[0-9;]*[a-zA-Z] *\\)*" "Fix remote shell detection with vterm"))

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

(use-package daemons :ensure t)

(use-package unicode-fonts :ensure t :pin melpa :config (unicode-fonts-setup))

(use-package auth-source :custom
  (auth-source-gpg-encrypt-to '("dam@cosinux.org"))
  :config (auth-source-pass-enable))

(use-package with-editor :ensure t)
(use-package auth-source-pass :ensure t)
(use-package password-store
  :after (with-editor auth-source-pass)
  :quelpa (password-store :fetcher github :repo "canatella/password-store" :branch "add-password-store-edit-command" :files
                          ("contrib/emacs/*.el"))
  :hook (password-store-mode . hl-line-mode)
  :custom (password-store-password-length 16))

(use-package explain-pause-mode
  :quelpa (explain-pause-mode :fetcher github :repo "lastquestion/explain-pause-mode")
  :diminish :config
  (explain-pause-mode))

(use-package lpr :custom (lpr-command "gtklp") (lpr-switches '("-X")))

(use-package rg :ensure t)
