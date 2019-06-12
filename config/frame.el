(use-package frame
  :custom
  (frame-background-mode 'dark "Using a dark theme.")
  (initial-frame-alist '((vertical-scroll-bars) (fullscreen . maximized)))
  (display-buffer-alist
   '((".*" display-buffer-reuse-window (reusable-frames . t)))
   "Do not always create a new window, reuse old ones.")
  :config
  (toggle-frame-fullscreen)
  (set-frame-parameter nil 'fullscreen 'fullboth)
  (set-frame-parameter (selected-frame) 'alpha '(100 100))
  (add-to-list 'default-frame-alist '(alpha 100 100)))
