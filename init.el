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

(defconst validating-config (getenv "VALIDATING_CONFIG"))


(defun load-config (config)
  (let ((file (format "%scfg/%s.el" user-emacs-directory config)))
    (message "Loading %s configuration" config)
    (load file)
    (message "Loaded %s configuration" config)))

(defmacro use-config (config &rest args)
  (unless (member :disabled args)
    `(load-config (quote ,config))))

(use-config packages)
(use-config system)
(use-config completion)
(use-config editing)
(use-config appearance)
(use-config viewer)
(use-config dired)
(use-config shell)
(use-config ide)
(use-config ide-android)
(use-config ide-asciidoc)
(use-config ide-c)
(use-config ide-docker)
(use-config ide-elisp)
(use-config ide-go)
(use-config ide-http)
(use-config ide-java)
(use-config ide-kotlin)
(use-config ide-protobuf)
(use-config ide-python)
(use-config ide-ruby)
(use-config ide-rust)
(use-config ide-terraform)
(use-config ide-tex)
(use-config ide-typescript)
(use-config ide-xml)
(use-config mail)
(use-config org)
(use-config social)
(use-config work)


;;(server-start)
(gc-cons-threshold-normal)

;;; init.el ends here
