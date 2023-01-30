;; -*- lexical-binding: t; -*-

(use-package dired
  :custom
  (dired-always-read-filesystem t "Revert buffers before searching them.")
  (dired-auto-revert-buffer t "Reload dired buffer when revisiting.")
  (dired-do-revert-buffer t "Reload dired buffer when explicitly changed.")
  (dired-dwim-target t "do what I mean when copying or moving.")
  (dired-mark-region t "only act on file in region.")
  :init (put 'dired-find-alternate-file 'disabled nil)
  :config
  (defun my-dired-setup ()
    (dired-hide-details-mode t))
  (add-hook 'dired-mode-hook #'my-dired-setup))

(use-package ls-lisp
  :custom
  (ls-lisp-dirs-first t "Directories first")
  (ls-lisp-use-insert-directory-program nil))

(defun xdg-open ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (call-process "xdg-open" nil 0 nil file)))

(use-package fd-dired
  :ensure t
  :custom (fd-dired-program "fd"))

(use-package ls-lisp
  :bind ("C-x d" . #'dired-fd)
  :config ;
  (defun dired-fd ()
    (interactive)
    (let ((ls-lisp-use-insert-directory-program t)
          (insert-directory-program "fdls"))
      (with-current-buffer (call-interactively #'dired)
        (make-local-variable 'ls-lisp-use-insert-directory-program)
        (make-local-variable 'insert-directory-program)))))
