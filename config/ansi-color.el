(defun my-colorize-compilation-buffer ()
    "Use ascii color to colorize the compilation buffer"
    (toggle-read-only)
    (ansi-color-apply-on-region compilation-filter-start (point))
    (toggle-read-only))

(use-package ansi-color
  :after comint
  :hook (compilation-filter . my-colorize-compilation-buffer))
