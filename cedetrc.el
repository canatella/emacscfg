;;; minimial-cedet-config.el --- Working configuration for CEDET from bzr
 
;; Copyright (C) Alex Ott
;;
;; Author: Alex Ott <alexott@gmail.com>
;; Keywords: cedet, C++, Java
;; Requirements: CEDET from bzr (http://cedet.sourceforge.net/bzr-repo.shtml)
 
;; Do checkout of fresh CEDET, and use this config (don't forget to change path below)
 
(setq cedet-root-path (file-name-as-directory "~/.emacs.d/site-lisp/cedet/"))
 
(load-file (concat cedet-root-path "cedet-devel-load.el"))
(add-to-list 'load-path (concat cedet-root-path "contrib"))
 
;; select which submodes we want to activate
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode) 
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)

;; Activate semantic
(semantic-mode 1)
 
;; load contrib library
(require 'eassist)
 
;; load the sr speedbar stuff
(require 'sr-speedbar)

;; toggle and select speedbar
(defun my-speedbar-toggle () 
  (interactive) 
  (if (sr-speedbar-exist-p)
      (sr-speedbar-close)
     (sr-speedbar-open) (sr-speedbar-select-window)))

;; customisation of modes
(defun my/cedet-hook ()
  (interactive)
  (local-set-key (kbd "H-j") 'semantic-ia-fast-jump)
  (local-set-key (kbd "H-t") 'my-speedbar-toggle)
  (local-set-key (kbd "s-j") 'semantic-analyze-proto-impl-toggle)
  (local-set-key (kbd "s-q") 'semantic-symref)
)
;;  ;;

(add-hook 'speedbar-reconfigure-keymaps-hook 'my-speedbar-toggle)

;;  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
;;  (local-set-key "\C-c=" 'semantic-decoration-include-visit)
;; 
;;  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
;;  (local-set-key "\C-cq" 'semantic-ia-show-doc)
;;  (local-set-key "\C-cs" 'semantic-ia-show-summary)
;;  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
;;  )

(add-hook 'c-mode-common-hook 'my/cedet-hook)
(add-hook 'lisp-mode-hook 'my/cedet-hook)
;;(add-hook 'scheme-mode-hook 'alexott/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'my/cedet-hook)

 
;;(defun my/c-mode-cedet-hook ()
;;  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
;;  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
;;  (local-set-key "\C-ce" 'eassist-list-methods)
;;  (local-set-key "\C-c\C-r" 'semantic-symref)
;;  )
;;(add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook)

(semanticdb-enable-gnu-global-databases 'c-mode t)
(semanticdb-enable-gnu-global-databases 'c++-mode t)
 
(when (cedet-ectag-version-check t)
  (semantic-load-enable-primary-ectags-support))
 
;; SRecode
(global-srecode-minor-mode 1)
 
(defadvice semantic-mrub-completing-read (around semantic-mrub-completing-read-around activate)
  "use ido-completing-read in semantic-mrub-completing-read"
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
         (ans nil)
         (alist (semantic-mrub-ring-to-assoc-list ring))
         (first (cdr (car alist)))
         (semantic-mrub-read-history nil)
         (choices nil)
         )
    ;; Don't include the current tag.. only those that come after.
    (if (semantic-equivalent-tag-p (oref first tag)
                                   (semantic-current-tag))
        (setq first (cdr (car (cdr alist)))))
    ;; Create a fake history list so we don't have to bind
    ;; M-p and M-n to our special cause.
    (let ((elts (reverse alist)))
      (while elts
        (setq semantic-mrub-read-history
              (cons (car (car elts)) semantic-mrub-read-history))
        (setq elts (cdr elts))))
    (setq semantic-mrub-read-history (nreverse semantic-mrub-read-history))

    ;; Do the read/prompt
    (let ((prompt (if first (format "%s (%s): " prompt
                                    (semantic-format-tag-name
                                     (oref first tag) t)
                                    )
                    (concat prompt ": ")))
          )
      (setq ans
                                        ;(completing-read prompt alist nil nil nil 'semantic-mrub-read-history)))
            (ido-completing-read prompt semantic-mrub-read-history nil nil nil 'semantic-mrub-read-history)))
    ;; Calculate the return tag.
    (if (string= ans "")
        (setq ans first)
      ;; Return the bookmark object.
      (setq ans (assoc ans alist))
      (if ans
          (cdr ans)
        ;; no match.  Custom word.  Look it up somwhere?
        nil)
      )))

;; EDE
(setq ede-locate-setup-options
      '(ede-locate-global ede-locate-locate ede-locate-base))
(global-ede-mode 1)
(ede-enable-generic-projects)

 
;; Setup JAVA....
;;(require 'cedet-java)
 
;;; minimial-cedet-config.el ends here
