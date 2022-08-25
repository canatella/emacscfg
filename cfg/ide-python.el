;; -*- lexical-binding: t; -*-

(use-package python
  :ensure t
  :devdocs (python-mode "python~3.9")
  :bind (("C-c i" . pyimport-insert-missing))
  :config (add-to-list 'eglot-server-programs '(python-mode . ("pylsp"))))

(use-package pyimport :ensure t)

(with-eval-after-load 'reformatter
  (reformatter-define python-format :stdin t :program "black" :args
    (list "-" "-q" "--stdin-filename" buffer-file-name)))
