;; -*- lexical-binding: t; -*-

(use-package
  dired
  :init (put 'dired-find-alternate-file 'disabled nil))

(use-package
  dired
  :custom (dired-always-read-filesystem t "Revert buffers before searching them.")
  (dired-auto-revert-buffer-t "Reload dired buffer when revisiting.")
  (dired-dwim-target t "do what I mean when copying or moving.")
  :config (defun my-dired-setup ()
            (dired-hide-details-mode t))
  (add-hook 'dired-mode-hook #'my-dired-setup))

(use-package
  dired-aux)

(use-package
  dired-filter
  :after dired
  :ensure t)

(use-package
  dired-subtree
  :after dired
  :ensure t
  :bind (:map dired-mode-map
              ("i" . dired-subtree-insert)
              (";" . dired-subtree-remove)))

(use-package
  dired-ranger
  :after dired
  :ensure t
  :bind (:map dired-mode-map
              ("C-w" . dired-ranger-mark-for-move)
              ("M-w" . dired-ranger-mark-for-copy)
              ("C-y" . dired-ranger-paste-or-move))
  :config (defvar dired-ranger-next-op nil
            "If 'move, calling dired-ranger-dwim will call dired-ranger-move, otherwise, call dired-ranger-paste.")
  (defun dired-ranger-mark-for-copy (arg)
    "Mark a file for copy."
    (interactive "P")
    (setq dired-ranger-next-op 'copy)
    (dired-ranger-copy arg))
  (defun dired-ranger-mark-for-move (arg)
    "Mark a file for move."
    (interactive "P")
    (setq dired-ranger-next-op 'move)
    (dired-ranger-copy arg))
  (defun dired-ranger-paste-or-move (arg)
    "Copy or move dired-ranger ring given `dired-ranger-next-op'"
    (interactive "P")
    (if (eql dired-ranger-next-op 'move)
        (dired-ranger-move arg)
      (dired-ranger-paste arg))
    (setq dired-ranger-next-op nil)))

(use-package
  dired-narrow
  :after dired
  :ensure t)

(use-package
  dired-rainbow
  :after dired
  :ensure t)

(use-package
  dired-collapse
  :after dired
  :ensure t
  :config (add-hook 'dired-after-readin-hook 'dired-collapse 'append 'local))

(use-package
  ls-lisp
  :custom (ls-lisp-dirs-first t "Directories first")
  (ls-lisp-use-insert-directory-program nil))

(use-package
  ag
  :ensure t
  :ensure-system-package ag)
