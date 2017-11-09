;;; init.el --- Canatella's Emacs configuration

;;; Commentary:

;; This is my personal Emacs configuration.

;;; Code:


;; collect garbage after loading the config file.
(setq gc-cons-threshold 400000000)

;; Custom variables are setup using use-package.
(customize-set-variable 'custom-file "/dev/null")

;; This is for my custom packages
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

;; Packages
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;(unless (package-installed-p 'use-package)
;  (package-install 'use-package))

(eval-when-compile
  (add-to-list 'load-path (concat user-emacs-directory "packages/use-package/"))
  (require 'use-package)

  (defun seq-insert-after (element place-holder sequence)
    "Insert ELEMENT after PLACE-HOLDER into SEQUENCE."
    (when sequence
      (let ((e (car sequence)))
        (cons e
              (if (equal place-holder e)
                  (cons element (cdr sequence))
                (seq-insert-after element place-holder (cdr sequence)))))))

  ;; make sure we enable dash
  (use-package helm-dash
    :ensure t
    :config
    (setq helm-dash-docsets '()))

  (unless (seq-contains use-package-keywords :dash)
    (setq use-package-keywords
          (seq-insert-after :dash :delight use-package-keywords)))

  (defun use-package-normalize/:dash (name-symbol keyword arg)
    "Normalize use-package customize keyword."
    (let ((error-msg (format  "%s wants a (<symbol> <docset> docset)  or list of these" name-symbol)))
      (unless (listp arg)
        (use-package-error error-msg))
      (dolist (def arg arg)
        (unless (listp def)
          (use-package-error error-msg)))))

  (defun use-package-handler/:dash (name keyword args rest state)
    "Generate use-package customize keyword code."
    (let ((body (use-package-process-keywords name rest state)))
      (use-package-concat
       (seq-map (lambda (def)
                  (let ((mode (intern (format "%s-hook" (car def))))
                        (hook (intern (format "use-package-dash-setup-%s" (car def))))
                        (docsets (cdr def)))
                    `(progn
                       (seq-do #'helm-dash-ensure-docset-installed (quote ,docsets))
                       (defun ,hook ,()
                         (make-local-variable 'helm-dash-docsets)
                         (seq-do (lambda (docset)
                                   (add-to-list 'helm-dash-docsets docset))
                                 (quote ,docsets)))
                       (add-hook (quote ,mode) (function ,hook)))))
                args)
       body))))

(require 'diminish)
(require 'my-secrets)

(org-babel-load-file (concat user-emacs-directory "config.org"))

(setq gc-cons-threshold 800000)

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
