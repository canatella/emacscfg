;;; perforce
(setenv "P4CLIENT" "sah5029_workspace_h1")
(setq sah-p4-wijgmaal-workspace (getenv "P4CLIENT"))
(setq sah-p4-nanterre-workspace (getenv "P4CLIENT"))
(load-library "p4")

;;; softathome stuff
(require 'sah)
(sah-mode t)
(setq save-hist-additional-variable sah-histories)

;;; odl mode
(load-library "odl-mode.el")
(require 'odl-mode)
(setq auto-mode-alist (cons '("\\.odl.m4$" . odl-mode) auto-mode-alist))

;;; change p4 client if needed when switching buffer
(defun my-switch-and-configure-p4 ()
  (interactive)
  (ido-switch-buffer)
  (sah-configure-p4))

;;; semantic
(require 'semantic/analyze/refs)
(defun my-sah-setup-semantic ()
  (interactive)
  (if sah-project
      (let ((sysinc (format "%sinclude" (or (sah-project-component-directory "sah_toolchain") "/usr/")))
            (staginginc (format "%sinclude" (sah-staging-directory))))
        ;;; semantic
        (message "setting up semantic")
        (message "system includes in %s" sysinc)
        (message "project includes in %s" staginginc)
        (semantic-mode 't)
        (semantic-idle-summary-mode 't)
        (semantic-stickyfunc-mode 't)
        (semantic-reset-system-include 'c-mode)
        (semantic-add-system-include sysinc 'c-mode)
        (semantic-add-system-include staginginc 'c-mode)
        ;;; autocomplete
        ;;(add-to-list 'ac-sources 'ac-source-semantic-raw)
        ;;; flymake
        (message "setting up flymake")
        (setenv "INCLUDE" sysinc)
        (flymake-mode 't)
        (setq flymake-get-project-include-dirs-function (lambda () staginginc))
        (define-key c-mode-map "\C-c\C-v" 'flymake-display-err-menu-for-current-line)
        (define-key c-mode-map (kbd "A-j") 'semantic-ia-fast-jump)
        (subword-mode 't))))

(defadvice flymake-start-syntax-check-process (after
                                               cheeso-advice-flymake-start-syntax-check-1
                                               (cmd args dir)
                                               activate compile)
  ;; set flag to allow exit without query on any
  ;;active flymake processes
  (set-process-query-on-exit-flag ad-return-value nil))

(defun my-configure-workspace (ws)
  (let ((workspace (format "sah5029_workspace_%s" ws)))
    (setenv "P4CLIENT" workspace)
    (setq sah-p4-wijgmaal-workspace workspace)
    (setq sah-p4-nanterre-workspace workspace)
    (setq server-name workspace)
    (setq savehist-file (format "~/.emacs.d/histories/%s" workspace))
    (setq sah-p4-workspace-filter workspace)
    (set-frame-name (format "emacs - %s" workspace))
    (server-start)))

(if (string= system-name "desktop")
    (progn
      (defun ws1 () (interactive) (my-configure-workspace "h1"))
      (defun ws2 () (interactive) (my-configure-workspace "h2")))
  (progn
    (defun ws1 () (interactive) (my-configure-workspace "1"))
    (defun ws2 () (interactive) (my-configure-workspace "2"))
    (defun ws3 () (interactive) (my-configure-workspace "3"))
    (defun ws4 () (interactive) (my-configure-workspace "4"))))

;;; keys
(global-set-key (kbd "C-x b") 'my-switch-and-configure-p4)
(global-set-key (kbd "C-c o") 'sah-open-project)
(global-set-key (kbd "C-c C-M-o") 'sah-open-any-project)

;;; hooks
(add-hook 'c-mode-common-hook 'my-sah-setup-semantic)

