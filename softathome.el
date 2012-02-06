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

;;; c-mode-hook
(require 'semantic/analyze/refs)
(defun my-sah-c-mode-hook ()
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
        ;;; completion
        (local-set-key (kbd "M-TAB") 'my-semantic-complete)
        ;;; swith to header
        (local-set-key (kbd "A-o") 'ff-find-other-file)
        ;;; flymake
        (message "setting up flymake")
        (setenv "INCLUDE" sysinc)
        (flymake-mode 't)
        (setq flymake-get-project-include-dirs-function '(basedir staginginc))
        (define-key c-mode-map "\C-c\C-v" 'flymake-display-err-menu-for-current-line)
        (define-key c-mode-map (kbd "A-j") 'semantic-ia-fast-jump)
        (subword-mode 't))))

(defun my-semantic-format-complete (tag)
  (semantic-format-tag-abbreviate tag nil t))

(defun my-semantic-completions () 
  (let* ((start (car (nth 2 (semantic-ctxt-current-symbol-and-bounds (point)))))
         (pattern (regexp-quote (buffer-substring start (point))))
         (syms (semantic-analyze-possible-completions (semantic-analyze-current-context (point))))
         collection)
         (if (null syms)
             (if (and semantic--completion-cache
                      (eq (nth 0 semantic--completion-cache) (current-buffer))
                      (=  (nth 1 semantic--completion-cache) start)
                      (save-excursion
                        (goto-char start)
                        (looking-at (nth 3 semantic--completion-cache))))
                 ;; Use cached value.
                 (setq collection (nthcdr 4 semantic--completion-cache))
               ;; Perform new query.
               (setq collection (semantic-find-tag-for-completion pattern))
               (setq semantic--completion-cache
                     (append (list (current-buffer) start 0 pattern)
                             collection)))
           syms)))

(setq my-semantic-completion-tag-format 'my-semantic-format-complete)

(defun my-semantic-complete ()
  (interactive)
  (let* ((start (car (nth 2 (semantic-ctxt-current-symbol-and-bounds (point)))))
         (syms (my-semantic-completions))
         (sym (if (eql 1 (length syms)) (car syms)
                (let ((completion (ido-completing-read "Complete" 
                                                       (mapcar my-semantic-completion-tag-format syms))))
                  (car (remove* completion syms :test-not 'string= :key my-semantic-completion-tag-format))))))
    (delete-region start (point))
    (insert (semantic-format-tag-name sym))))
         

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
(add-hook 'c-mode-common-hook 'my-sah-c-mode-hook)

