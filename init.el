;;; configure load path
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/site-lisp")

(load-library "appearance")
(load-library "behaviour")
(load-library "editing")
(load-library "bindings")
(load-library "cedetrc")
(if (equal 0 (call-process-shell-command "/sbin/ip route list 10.0.2.0/24 | grep 10.0.2.0"))
    (load-library "dsa"))

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
 '(browse-url-browser-function (quote browse-url-chromium))
 '(c-basic-offset 4)
 '(custom-safe-themes (quote ("9bbcab6ecf2622cf7bd613cf1ce5478f6c3ab135f933d3b48d2594edbafb9503" default)))
 '(diff-switches "-u")
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(espresso-enabled-frameworks (quote (javascript prototype)))
 '(espresso-indent-level 2)
 '(flymake-compilation-prevents-syntax-check nil)
 '(flymake-gui-warnings-enabled nil)
 '(flymake-no-changes-timeout 0.3)
 '(global-semantic-idle-completions-mode nil nil (semantic/idle))
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
 '(makefile-cleanup-continuations t)
 '(midnight-mode t nil (midnight))
 '(mutt-alias-file-list (quote ("~/.mutt_aliases")))
 '(semantic-complete-inline-analyzer-displayor-class (quote semantic-displayor-ghost))
 '(semantic-complete-inline-analyzer-idle-displayor-class (quote semantic-displayor-ghost))
 '(semantic-displayor-tooltip-mode (quote standard))
 '(semantic-mode t)
 '(sr-speedbar-width-x 48)
 '(tail-hide-delay 2)
 '(tail-max-size 10)
 '(tail-volatile nil)
 '(vc-cvs-diff-switches "-u")
 '(woman-cache-level 3)
 '(woman-imenu t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:background "goldenrod4"))) t)
 '(diff-changed ((t (:background "dark magenta"))) t)
 '(flymake-errline ((((class color) (background dark)) (:underline "red"))) t)
 '(flymake-warnline ((((class color) (background dark)) (:underline "orange"))) t))
