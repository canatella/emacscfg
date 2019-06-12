(defun bloomlife-visit-dashboard ()
  (interactive)
  (message "bloomlife visit dashboard")
  (let ((left (selected-window))
        (right (split-window-right)))
    (with-selected-window left
      (find-file "~/Desktop/Bloomlife/org/dashboard.org"))))

(use-package bloomlife
  :load-path "~/.emacs.d/packages/bloomlife"
  :after (projectile flycheck-clang-tidy ccls lsp-ui)
  :config (bloomlife-visit-dashboard))
