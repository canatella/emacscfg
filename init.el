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
(customize-set-variable 'inhibit-compacting-font-caches '())


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (add-to-list 'load-path (concat user-emacs-directory "pkg/use-package/"))
                   (add-to-list 'load-path (concat user-emacs-directory "lib/"))
                   (require 'use-package)
                   (customize-set-variable 'use-package-verbose t))

(defmacro use-package-local (package &rest args)
  "Configure package from pkg directory"
  (declare (indent 1))
  `(use-package ,package :load-path ,(format "%spkg/%s/" user-emacs-directory package) ,@args))

(defun load-config (config)
  (load (format "%scfg/%s.el" user-emacs-directory config)))


(load-config 'system)
(load-config 'completion)
(load-config 'editing)
(load-config 'viewer)
(load-config 'dired)
(load-config 'shell)
(load-config 'ide)
(load-config 'ide-android)
(load-config 'ide-c)
(load-config 'ide-elisp)
(load-config 'ide-java)
(load-config 'ide-python)
(load-config 'ide-ruby)
(load-config 'ide-rust)
(load-config 'ide-terraform)
(load-config 'work)
(load-config 'appearance)

(gc-cons-threshold-normal)

;;; init.el ends here
