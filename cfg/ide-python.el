;; -*- lexical-binding: t; -*-

(use-package python :dash (python-mode "Python 3"))
(with-eval-after-load 'reformatter
  (reformatter-define python-format :program "yapf")
  (add-hook 'python-mode-hook #'python-format-on-save-mode))
