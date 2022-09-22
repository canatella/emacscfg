;; -*- lexical-binding: t; -*-

(use-package
  dired
  :custom (dired-always-read-filesystem t "Revert buffers before searching them.")
  (dired-auto-revert-buffer t "Reload dired buffer when revisiting.")
  (dired-do-revert-buffer t "Reload dired buffer when explicitly changed.")
  (dired-dwim-target t "do what I mean when copying or moving.")
  (dired-mark-region t "only act on file in region.")
  :init (put 'dired-find-alternate-file 'disabled nil)
  :config (defun my-dired-setup () (dired-hide-details-mode t))
  (add-hook 'dired-mode-hook #'my-dired-setup))

(use-package dired-aux)

(use-package dired-filter     :ensure t :after dired)

(use-package
  dired-subtree
  :ensure t
  :after dired

  :bind (:map dired-mode-map ("i" . dired-subtree-insert) (";" . dired-subtree-remove)))

(use-package dired-narrow :ensure t :after dired)

(use-package dired-rainbow :ensure t :after dired)

(use-package
  dired-collapse
  :ensure t
  :after dired
  :config (add-hook 'dired-after-readin-hook 'dired-collapse 'append 'local))

(use-package
  ls-lisp
  :custom (ls-lisp-dirs-first t "Directories first")
  (ls-lisp-use-insert-directory-program nil))

(defun xdg-open ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (call-process "xdg-open" nil 0 nil file)))

(let ((system-package
       (if (eq system-type 'darwin)
           '(fd . "brew install fd")
         '(fd . "sudo apt-get install fd-find")))
      (exec (if (eq system-type 'darwin) "fd" "fdfind")))
  (eval
   `(use-package fd-dired :ensure t :ensure-system-package ,system-package
      :custom (fd-dired-program ,exec))))
