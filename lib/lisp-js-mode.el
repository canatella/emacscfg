(require 'mmm-mode)

(mmm-add-classes
 '((elisp-js
    :submode js-mode
    :face mmm-code-submode-face
    :delimiter-mode nil
    :front "--js \"\n"
    :back "\" js--")))

(add-to-list 'mmm-mode-ext-classes-alist '(emacs-lisp-mode nil elisp-js))
(setq mmm-classes-alist '())
