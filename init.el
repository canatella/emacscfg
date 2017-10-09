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

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)

  (defun seq-insert-after (element place-holder sequence)
    "Insert ELEMENT after PLACE-HOLDER into SEQUENCE."
    (when sequence
      (let ((e (car sequence)))
        (cons e
              (if (equal place-holder e)
                  (cons element (cdr sequence))
                (seq-insert-after element place-holder (cdr sequence)))))))

  (unless (seq-contains use-package-keywords :customize)
    (setq use-package-keywords
          (seq-insert-after :customize :init use-package-keywords)))

  (defun use-package-normalize/:customize (name-symbol keyword arg)
    "Normalize use-package customize keyword."
    (let ((error-msg (format  "%s wants a (<symbol> <form> <optional string comment>) or list of these" name-symbol)))
      (unless (listp arg)
        (use-package-error error-msg))
      (dolist (def arg arg)
        (unless (listp def)
          (use-package-error error-msg))
        (seq-let [variable value comment] def
            (when (or (not variable)
                      (not value)
                      (> (length def) 3)
                      (and comment (not (stringp comment))))
              (use-package-error error-msg))))))

  (defun use-package-handler/:customize (name keyword arg rest state)
    "Generate use-package customize keyword code."
    (let ((body (use-package-process-keywords name rest state)))
      (dolist (def arg body)
        (seq-let [variable value comment] def
          (unless comment
            (setq comment (format "Customized with use-package %s" name)))
          (use-package-concat
           body
           `((customize-set-variable (quote ,variable) ,value ,comment)))))))

  (unless (seq-contains use-package-keywords :custom-faces)
    (setq use-package-keywords
          (seq-insert-after :custom-faces :customize use-package-keywords)))

  (defun use-package-normalize/:custom-faces (name-symbol keyword arg)
    "Normalize use-package custom-faces keyword."
    (let ((error-msg (format  "%s wants a (<symbol> <face-spec>) or list of these" name-symbol)))
      (unless (listp arg)
        (use-package-error error-msg))
      (dolist (def arg arg)
        (unless (listp def)
          (use-package-error error-msg))
        (seq-let [face spec] def
            (when (or (not face)
                      (not spec)
                      (> (length arg) 2))
              (use-package-error error-msg))))))

  (defun use-package-handler/:custom-faces (name keyword arg rest state)
    "Generate use-package custom-faces keyword code."
    (let ((body (use-package-process-keywords name rest state)))
      (dolist (def arg body)
        (use-package-concat
         body
         `((custom-set-faces (quote ,def)))))))

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
       body)))



  )

(require 'diminish)


(org-babel-load-file (concat user-emacs-directory "config.org"))

(setq gc-cons-threshold 800000)

;;; init.el ends here
