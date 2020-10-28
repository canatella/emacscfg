;; -*- lexical-binding: t; -*-

(use-package
  ruby-mode
  :dash (ruby-mode "Ruby_2")
  :custom (ruby-indent-level 2 "Use 2 space for indenting ruby code.")
  (ruby-align-chained-calls nil)
  :config (add-to-list 'compilation-error-regexp-alist-alist (cons 'ruby-minitest-failure '("\\[\\([^\\]+\\):\\([0-9]+\\)\\]"
                                                                                            1 2 nil
                                                                                            nil 1)))
  (add-to-list 'compilation-error-regexp-alist-alist (cons 'ruby-minitest-error '("Error:\n[^\n]+\n[^\n]+\n\\([^/]+\n\\)? *\\([^:]+\\):\\([0-9]+\\)"
                                                                                  2 3 nil nil 2)))
  (add-to-list 'compilation-error-regexp-alist-alist (cons 'ruby-minitest-backtrace '("\n *\\([^:]+\\):\\([0-9]+\\):in"
                                                                                      1 2 nil 0 1)))
  (add-to-list 'compilation-error-regexp-alist-alist (cons 'ruby-minitest-warning '("\\(/[^:]+\\):\\([0-9]+\\): warning"
                                                                                    1 2 nil 1 1)))
  (add-to-list 'compilation-error-regexp-alist-alist (cons 'rails-test-line '("\nbin/rails test \\([^:]+\\):\\([0-9]+\\)"
                                                                              1 2 nil 0 1)))
  (add-to-list 'compilation-error-regexp-alist-alist (cons 'rails-brakeman '("File: \\([^\n]+\\)\nLine: \\([0-9]+\\)"
                                                                             1 2 nil nil 1)))
  (defun ruby-close-block ()
    "Close ruby block."
    (interactive)
    (unless (string-match "^[[:blank:]]*$"
                          (buffer-substring
                           (line-beginning-position)
                           (line-end-position)))
      (newline))
    (insert "end")
    (ruby-indent-line))
  (defun my-progmode-equal ()
    "Insert space equal space."
    (interactive)
    (insert " = ")
    (ruby-indent-line))
  (defun my-ruby-mode-hook ()
    (interactive)
    (local-set-key (kbd "C-c C-e") #'ruby-close-block)
    (local-set-key (kbd "«")
                   (lambda ()
                     (interactive)
                     (insert "#{}")
                     (left-char)))
    (setq fill-column 120)
    (turn-on-auto-fill)
    (ruby-block-mode t)
    (subword-mode t))
  (add-hook 'ruby-mode-hook #'my-ruby-mode-hook)
  (defun my-ruby-compilation-hook ()
    (when (and (not (projectile-rails--ignore-buffer-p))
               (projectile-project-p)
               (projectile-rails-root)))
    (setq-local compilation-error-regexp-alist '(ruby-minitest-failure ruby-minitest-error
                                                                       ruby-minitest-backtrace
                                                                       rails-test-line
                                                                       ruby-minitest-warning
                                                                       rails-brakeman)))
  (remove-hook 'compilation-mode-hook #'my-ruby-compilation-hook)
  (defun my-ruby-toggle-string-quotes-advise (orig-fun &rest args)
    (let ((orig-point (point)))
      (backward-char)
      (apply orig-fun args)
      (goto-char orig-point)))
  (add-function :around (symbol-function 'ruby-toggle-string-quotes)
                #'my-ruby-toggle-string-quotes-advise))

(use-package
  rbenv
  :ensure t)

(use-package
  robe
  :ensure t
  :after ruby-mode
  :diminish robe-mode
  :config (defun my-robe-setup ()
            (local-set-key (kbd "H-j") #'robe-jump)
            (robe-mode))
  (add-hook 'ruby-mode-hook #'my-robe-setup))

(use-package
  rubocop
  :ensure t)

(use-package
  eruby-mode
  :diminish eruby-mode
  :disabled
  :custom-face (eruby-standard-face ((t
                                      (:slant italic)))))
