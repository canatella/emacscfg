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


(defun xdg-open ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (call-process "xdg-open" nil 0 nil file)))
