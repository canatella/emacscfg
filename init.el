;;; init.el --- Canatella's Emacs configuration

;;; Commentary:

;; This is my personal Emacs configuration.

;;; Code:


;; collect garbage after loading the config file.
(defvar gc-cons-threshold-default gc-cons-threshold
  "Default value fo `gc-cons-threshold'.")

(defun gc-cons-threshold-max ()
  "Disable gc."
  (setq gc-cons-threshold-default gc-cons-threshold)
  (setq gc-cons-threshold most-positive-fixnum))

(defun gc-cons-threshold-normal ()
  "Enable gc."
  (setq gc-cons-threshold gc-cons-threshold-default))

(gc-cons-threshold-max)

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
  (use-package counsel-dash
    :ensure t
    :config
    (mkdir "~/.docsets" t)
    (setq counsel-dash-docsets '()))

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
                         (make-local-variable 'counsel-dash-docsets)
                         (seq-do (lambda (docset)
                                   (add-to-list 'counsel-dash-docsets docset))
                                 (quote ,docsets)))
                       (add-hook (quote ,mode) (function ,hook)))))
                args)
       body))))

(require 'diminish)
(require 'my-secrets)

(org-babel-load-file (concat user-emacs-directory "config.org"))

(gc-cons-threshold-normal)

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
