;; -*- lexical-binding: t; -*-

(use-package ruby-mode
  :ensure t
  :devdocs (ruby-mode "ruby~3")
  :custom
  (ruby-indent-level 2 "Use 2 space for indenting ruby code.")
  (ruby-align-chained-calls nil)
  :config
  (add-to-list
   'compilation-error-regexp-alist-alist
   (cons 'ruby-minitest-failure '("\\[\\([^\\]+\\):\\([0-9]+\\)\\]" 1 2 nil nil 1)))
  (add-to-list
   'compilation-error-regexp-alist-alist
   (cons
    'ruby-minitest-error
    '("Error:\n[^\n]+\n[^\n]+\n\\([^/]+\n\\)? *\\([^:]+\\):\\([0-9]+\\)" 2 3 nil nil 2)))
  (add-to-list
   'compilation-error-regexp-alist-alist
   (cons 'ruby-minitest-backtrace '("\n *\\([^:]+\\):\\([0-9]+\\):in" 1 2 nil 0 1)))
  (add-to-list
   'compilation-error-regexp-alist-alist
   (cons 'ruby-minitest-warning '("\\(/[^:]+\\):\\([0-9]+\\): warning" 1 2 nil 1 1)))
  (add-to-list
   'compilation-error-regexp-alist-alist
   (cons 'rails-test-line '("\nbin/rails test \\([^:]+\\):\\([0-9]+\\)" 1 2 nil 0 1)))
  (add-to-list
   'compilation-error-regexp-alist-alist
   (cons 'rails-brakeman '("File: \\([^\n]+\\)\nLine: \\([0-9]+\\)" 1 2 nil nil 1)))
  (defun ruby-close-block ()
    "Close ruby block."
    (interactive)
    (unless (string-match
             "^[[:blank:]]*$" (buffer-substring (line-beginning-position) (line-end-position)))
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
    (local-set-key
     (kbd "«")
     (lambda ()
       (interactive)
       (insert "#{}")
       (left-char)))
    (setq fill-column 120)
    (turn-on-auto-fill)
    (ruby-block-mode t)
    (subword-mode t))
  (defun my-ruby-toggle-string-quotes-advise (orig-fun &rest args)
    (let ((orig-point (point)))
      (backward-char)
      (apply orig-fun args)
      (goto-char orig-point)))
  (add-function
   :around (symbol-function 'ruby-toggle-string-quotes) #'my-ruby-toggle-string-quotes-advise))

(use-package rbenv
  :ensure t)
(use-package rubocop
  :ensure t)

(use-package eruby-mode
  :ensure t
  :diminish eruby-mode
  :disabled
  :custom-face (eruby-standard-face ((t (:slant italic)))))
