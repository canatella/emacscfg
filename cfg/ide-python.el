;; -*- lexical-binding: t; -*-

(use-package
  python
  :dash (python-mode "Python 3"))

(use-package
  py-autopep8
  :ensure t
  :hook (python-mode . py-autopep8-enable-on-save))
