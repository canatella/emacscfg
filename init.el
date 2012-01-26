;;; configure load path
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/site-lisp")

(load-library "appearance")
(load-library "behaviour")
(load-library "editing")
(load-library "bindings")
(if (equal 0 (call-process-shell-command "/sbin/ip route list 192.168.18.0/24 | grep 192.168.18.0"))
    (load-library "softathome"))

(defun byte-recompile-world ()
  "recompile emacs.d"
  (interactive)
  (byte-recompile-directory "~/.emacs.d/site-lisp" 0))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu nil)
 '(ac-use-fuzzy nil)
 '(c-basic-offset 4)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(espresso-enabled-frameworks (quote (javascript prototype)))
 '(espresso-indent-level 2)
 '(flymake-compilation-prevents-syntax-check nil)
 '(flymake-gui-warnings-enabled nil)
 '(flymake-no-changes-timeout 0.3)
 '(indent-tabs-mode nil)
 '(js-enabled-frameworks (quote (javascript prototype)))
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(js2-cleanup-whitespace t)
 '(js2-enter-indents-newline t)
 '(js2-indent-on-enter-key nil)
 '(js2-mirror-mode nil)
 '(js2-mode-indent-ignore-first-tab t)
 '(mutt-alias-file-list (quote ("~/.mutt_aliases")))
 '(semanticdb-ebrowse-file-match "\\.\\(hh?\\|HH?\\|hpp\\|cc?\\)")
 '(tail-hide-delay 2)
 '(tail-max-size 10)
 '(tail-volatile nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color) (background dark)) (:underline "red"))))
 '(flymake-warnline ((((class color) (background dark)) (:underline "orange")))))
