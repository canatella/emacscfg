(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(require 'appearance)

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-recipes")
(setq el-get-user-package-directory "~/.emacs.d/el-get-init-files")
(setq el-get-sources '((:name flycheck
			      :type github
			      :pkgname "lunaryorn/flycheck"
			      :description "On-the-fly syntax checking extension"
			      )))
(package-initialize)
(setq my-packages
      (append
       '(yasnippet color-theme-solarized ido-ubiquitous cedet sr-speedbar rainbow-delimiters
		   ri org-mode rnc-mode)
            (mapcar 'el-get-source-name el-get-sources)))
(el-get 'sync my-packages)

(require 'behaviour)
(require 'editing)
(require 'bindings)
(require 'duma)

;; (toggle-frame-fullscreen)
;; dired-hide-details-mode

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu nil)
 '(ac-use-fuzzy nil)
 '(auto-save-list-file-prefix "~/.emacs.d/var/auto-save-list/.saves-")
 '(browse-url-browser-function (quote browse-url-chromium))
 '(c-basic-offset 4)
 '(comint-buffer-maximum-size 20000)
 '(comint-completion-addsuffix t)
 '(comint-get-old-input (lambda nil "") t)
 '(comint-input-ignoredups t)
 '(comint-input-ring-size 5000)
 '(comint-move-point-for-output nil)
 '(comint-prompt-read-only t)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(comment-auto-fill-only-comments t)
 '(compilation-ask-about-save nil)
 '(ctl-arrow nil)
 '(custom-safe-themes
   (quote
    ("b6f7795c2fbf75baf3419c60ef7625154c046fc2b10e3fdd188e5757e08ac0ec" "085b401decc10018d8ed2572f65c5ba96864486062c0a2391372223294f89460" "4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "fe6330ecf168de137bb5eddbf9faae1ec123787b5489c14fa5fa627de1d9f82b" "21d9280256d9d3cf79cbcf62c3e7f3f243209e6251b215aede5026e0c5ad853f" "787574e2eb71953390ed2fb65c3831849a195fd32dfdd94b8b623c04c7f753f0" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "936e5cac238333f251a8d76a2ed96c8191b1e755782c99ea1d7b8c215e66d11e" "3dd173744ae0990dd72094caef06c0b9176b3d98f0ee5d822d6a7e487c88d548" "246a51f19b632c27d7071877ea99805d4f8131b0ff7acb8a607d4fd1c101e163" "30fe7e72186c728bd7c3e1b8d67bc10b846119c45a0f35c972ed427c45bacc19" "b4018b7d8352dc7f21c0906cd33621ec487e872a97527dcdad590f0fb50cf9e8" "68769179097d800e415631967544f8b2001dae07972939446e21438b1010748c" "d921083fbcd13748dd1eb638f66563d564762606f6ea4389ea9328b6f92723b7" "89f613708c8018d71d97e3da7a1e23c8963b798252f1ac2ab813ad63b7a4b341" "6cfe5b2f818c7b52723f3e121d1157cf9d95ed8923dbc1b47f392da80ef7495d" "5e1d1564b6a2435a2054aa345e81c89539a72c4cad8536cfe02583e0b7d5e2fa" "9f443833deb3412a34d2d2c912247349d4bd1b09e0f5eaba11a3ea7872892000" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "c6ebed7f56bdd9d5382c2c440738fc335da3b53c3fa776716dc1b3e47e9cba7d" "3126286c8f46e987b9c43149851f8b4a60886a5236a1593aeae689e2c18c182e" "9bbcab6ecf2622cf7bd613cf1ce5478f6c3ab135f933d3b48d2594edbafb9503" default)))
 '(diff-switches "-u")
 '(ecb-layout-window-sizes
   (quote
    (("my"
      (ecb-speedbar-buffer-name 0.1638655462184874 . 0.6842105263157895)
      (ecb-history-buffer-name 0.1638655462184874 . 0.2982456140350877)))))
 '(ecb-options-version "2.40")
 '(ede-project-placeholder-cache-file "~/.emacs.d/var/ede-projects.el")
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(espresso-enabled-frameworks (quote (javascript prototype)))
 '(espresso-indent-level 2)
 '(flymake-compilation-prevents-syntax-check nil)
 '(flymake-gui-warnings-enabled nil)
 '(flymake-no-changes-timeout 0.3)
 '(global-font-lock-mode t)
 '(global-semantic-idle-completions-mode nil nil (semantic/idle))
 '(ido-enable-flex-matching t)
 '(ido-mode (quote both) nil (ido))
 '(ido-everywhere t)
 '(ido-ignore-files
   (quote
    ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "\\.gc\\(da\\|no\\)")))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
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
 '(protect-buffer-bury-p nil)
 '(safe-local-variable-values (quote ((flycheck-clang-include-path (duma/project/root)))))
 '(savehist-file "~/.emacs.d/var/history")
 '(savehist-mode t)
 '(scroll-bar-mode nil)
 '(semantic-complete-inline-analyzer-displayor-class (quote semantic-displayor-ghost))
 '(semantic-complete-inline-analyzer-idle-displayor-class (quote semantic-displayor-ghost))
 '(semantic-displayor-tooltip-mode (quote standard))
 '(semantic-mode t)
 '(semanticdb-default-save-directory "~/.emacs.d/var/semanticdb")
 '(sr-speedbar-width-x 48)
 '(srecode-map-save-file "~/.emacs.d/var/srecode-map.el")
 '(tail-hide-delay 2)
 '(tail-max-size 10)
 '(tail-volatile nil)
 '(text-scale-mode-step 1.02)
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh" t)
 '(vc-cvs-diff-switches "-u")
 '(woman-cache-level 3)
 '(woman-imenu t)
 '(yas/also-auto-indent-first-line t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flymake-errline ((t (:background "#002b36" :inverse-video nil))) t)
 '(flymake-warnline ((((class color) (background dark)) (:underline "orange"))) t)
 '(region ((t (:background "gray20"))))
 '(yas/field-highlight-face ((t (:background "DimGrey" :foreground "black")))))
