;; -*- lexical-binding: t; -*-

(use-package python :dash (python-mode "Python 3") :devdocs (python-mode "python~3.9"))

(with-eval-after-load 'reformatter
  (reformatter-define python-format :stdin t :program "black" :args
    (list "-" "-q" "--stdin-filename" buffer-file-name)))
