(global-set-key [f2]                    'indent-buffer)
 (global-set-key [f3]                    'my-file-make-writeable)
 (global-set-key [f4]                    'goto-line)
 (global-set-key [f5]                    'quick-calc)
 (global-set-key [f6]                    'revert-buffer)
 (global-set-key [f7]                    'make-directory)
 (global-set-key [f8]                    'magit-status)
 (global-set-key [H-f8]                  (lambda () (interactive) (find-file "~/Mind")))
 (global-set-key [f9]                    'rgrep)
 (global-set-key [f10]                   'recompile)
 (global-set-key [H-f10]                 'compile)
 (global-set-key [s-f10]                 'kill-compilation)
 (global-set-key [f11]                   'woman)

 ;; window management
 (global-set-key (kbd "H-\"")            'delete-other-windows)
 (global-set-key (kbd "H-<")             'split-window-below)
 (global-set-key (kbd "H->")             'split-window-right)
 (global-set-key (kbd "H-*")             'delete-window)
 (global-set-key (kbd "s-<left>")        'windmove-left)
 (global-set-key (kbd "s-<right>")       'windmove-right)
 (global-set-key (kbd "s-<up>")          'windmove-up)
 (global-set-key (kbd "s-<down>")        'windmove-down)

 ;; buffer management
 (global-set-key (kbd "H-f")             'find-file-in-repository)
 (global-set-key (kbd "s-f")             'my-file-reopen-as-root)
 (global-set-key (kbd "H-s")             'save-buffer)
 (global-set-key (kbd "H-k")             'ido-kill-buffer)
 (global-set-key (kbd "H-b")             'ido-switch-buffer)
 (global-set-key (kbd "H-B")             'my/switch-buffer-other-window)
 (global-set-key (kbd "H-o")             'other-window)

 ;; editing
 (global-set-key (kbd "C-©")             'comment-or-uncomment-region)
 (global-set-key (kbd "©")               'comment-or-uncomment-paragraph)
 (global-set-key (kbd "H-/")             'er/expand-region)


 (defun my/cedet-hook ()
   (interactive)
   (local-set-key (kbd "H-j")            'semantic-ia-fast-jump)
   (local-set-key (kbd "s-j")            'semantic-analyze-proto-impl-toggle)
   (local-set-key (kbd "s-q")            'semantic-symref)
   (local-set-key (kbd "H-h")            'semantic-complete-analyze-inline)
   (local-set-key (kbd "s-B")            'semantic-mrub-switch-tags)
   (local-set-key (kbd "©")              'comment-or-uncomment-tag)
   (local-set-key (kbd "s--")            'pop-global-mark)
   (local-set-key (kbd "C-<up>")         'senator-previous-function-tag)
   (local-set-key (kbd "C-<down>")       'senator-next-function-tag))

(add-hook 'c-mode-common-hook 'my/cedet-hook)
(add-hook 'lisp-mode-hook 'my/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'my/cedet-hook)
(add-hook 'tcl-mode-hook 'my/cedet-hook)

(defun my/flycheck-hook ()
  (local-set-key (kbd "H-e")            'next-error)
  (local-set-key (kbd "H-p")            'previous-error))
(add-hook 'flycheck-mode-hook 'my/flycheck-hook)


(defun my/nxml-mode-hook ()
  (interactive)
  (local-set-key (kbd "H-h")             'nxml-complete))
(add-hook 'nxml-mode-hook 'my/nxml-mode-hook)

(provide 'bindings)
