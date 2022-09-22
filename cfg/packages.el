(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))

(customize-set-variable 'package-archive-priorities
                        '(("gnu" . 30)
                          ("nongnu" . 20)
                          ("melpa" . 50)))
(customize-set-variable 'package-user-dir (concat user-emacs-directory "var/elpa/"))
(customize-set-variable 'package-gnupghome-dir (concat package-user-dir "gnupg/"))
(customize-set-variable 'package-native-compile t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defconst cfg-package-directory (format "%spkg/" user-emacs-directory))
(defconst cfg-lib-directory (format "%slib/" user-emacs-directory))

(customize-set-variable 'quelpa-checkout-melpa-p nil)
(customize-set-variable 'quelpa-dir (concat user-emacs-directory "var/quelpa/"))
(customize-set-variable 'quelpa-build-dir cfg-package-directory)
(when validating-config
  (customize-set-variable 'use-package-verbose 'errors)
  (customize-set-variable 'use-package-expand-minimally t))

(unless (package-installed-p 'quelpa) (package-install 'quelpa))
(unless (package-installed-p 'quelpa-use-package) (package-install 'quelpa-use-package))

(require 'quelpa)
(require 'quelpa-use-package)


(eval-when-compile (add-to-list 'load-path (concat user-emacs-directory "lib/")))

;; Custom variables are setup using use-package.
(customize-set-variable 'custom-file "/dev/null")
(customize-set-variable 'inhibit-compacting-font-caches '())
