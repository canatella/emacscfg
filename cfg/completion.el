;; -*- lexical-binding: t; -*-

(use-package corfu
  :straight t
  ;; Optional customizations
  :custom (tab-always-indent 'complete)
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-commit-predicate nil)   ;; Do not commit selected candidates on next input
  ;; (corfu-quit-at-boundary t)     ;; Automatically quit at word boundary
  ;; (corfu-quit-no-match t)        ;; Automatically quit if there is no match
  ;; (corfu-echo-documentation nil) ;; Do not show documentation in the echo area

  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous))

  ;; You may want to enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since dabbrev can be used globally (M-/).
  :init (corfu-global-mode))

(use-package orderless :straight t :custom (completion-styles '(orderless)))

(use-package selectrum :straight t :config (selectrum-mode))

(use-package embark :straight t
             :after (selectrum)
             :bind (("C-{" . embark-act)
                    ("C-(" . embark-dwim)
                    (:map selectrum-minibuffer-map
                          ("C-c C-o" . embark-export)
                          ("C-c C-c" . embark-act-noexit))))

(use-package consult :straight t
             :after (project)
             :custom (consult-project-root-function #'project-current-root)
             :bind (([f9] . consult-ripgrep)
                    ([remap switch-to-buffer] . consult-buffer)
                    ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
                    ([remap switch-to-buffer-other-frame] . consult-buffer-other-frame))
             :config (defun project-current-root
                         ()
                       "Return current project root."
                       (when-let ((project (project-current)))
                         (project-root (project-current)))))

(use-package consult-dash :straight
             (consult-dash :repo "https://github.com/canatella/consult-dash.git" :branch main)
             :after (dash-docs))


(use-package embark-consult :straight t
             :after (embark consult)
             :hook ((embark-collect-mode . embark-consult-preview-minor-mode)))

(use-package marginalia :straight t
             :custom (marginalia-annotators '(marginalia-annotators-heavy))
             :config (marginalia-mode))

(use-package abbrev :custom (save-abbrevs nil) :diminish)
