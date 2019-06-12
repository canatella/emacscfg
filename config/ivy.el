(use-package ivy
  :ensure t
  :bind (("C-x b" . ivy-switch-buffer))
  :diminish
  :custom
  (ivy-magic-slash-non-match-action
   #'ivy-magic-slish-non-match-create
   "Create directory when hitting / without matches")
  :init
  ;;(setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  :config
  (ivy-mode t))

(use-package prescient
  :custom
  (prescient-filter-method "fuzzy")
  :ensure t)

(use-package ivy-prescient
  :ensure t
  :disabled
  :config
  (ivy-prescient-mode t)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (counsel-ag . ivy--regex-plus)
          (counsel-rg . ivy--regex-plus)
          (t      . ivy-prescient-re-builder))))

(use-package counsel
  :ensure t
  :bind (("C-x C-f" . counsel-find-file)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ([f9] . counsel-ag))
  :config
  (let ((done (where-is-internal #'ivy-done     ivy-minibuffer-map t))
        (alt  (where-is-internal #'ivy-alt-done ivy-minibuffer-map t)))
    (define-key counsel-find-file-map done #'ivy-alt-done)
    (define-key counsel-find-file-map alt  #'ivy-done)))

(use-package counsel-osx-app
  :ensure t)

(use-package counsel-projectile
  :ensure t)
