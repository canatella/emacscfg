(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename (expand-file-name "var/eln-cache/" user-emacs-directory))))

(customize-set-variable 'package-archive-priorities '(("gnu" . 30) ("nongnu" . 20) ("melpa" . 50)))
(customize-set-variable 'package-user-dir (concat user-emacs-directory "var/elpa/"))
(customize-set-variable 'package-gnupghome-dir (concat package-user-dir "gnupg/"))
(customize-set-variable 'package-native-compile t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defconst cfg-package-directory (format "%spkg/" user-emacs-directory))
(defconst cfg-lib-directory (format "%slib/" user-emacs-directory))
(defconst cfg-var-directory (format "%svar/" user-emacs-directory))

(customize-set-variable 'quelpa-checkout-melpa-p nil)
(customize-set-variable 'quelpa-dir (concat cfg-var-directory "quelpa"))
(customize-set-variable 'quelpa-build-dir cfg-package-directory)
(when validating-config
  (customize-set-variable 'use-package-verbose 'errors)
  (customize-set-variable 'use-package-expand-minimally t))

(unless (package-installed-p 'quelpa)
  (package-install 'quelpa))
(unless (package-installed-p 'quelpa-use-package)
  (package-install 'quelpa-use-package))

(require 'quelpa)
(require 'quelpa-use-package)

;; Don't use quelpa to install dependencies
(defun my-quelpa-package-install (arg &rest plist)
  "Build and install package from ARG (a recipe or package name).
PLIST is a plist that may modify the build and/or fetch process.
If the package has dependencies recursively call this function to install them.
Return new package version."
  (let* ((rcp (quelpa-arg-rcp arg))
         (file
          (when rcp
            (quelpa-build (append rcp plist)))))
    (when file
      (let* ((pkg-desc (quelpa-get-package-desc file))
             (requires (package-desc-reqs pkg-desc))
             (ver (package-desc-version pkg-desc)))
        (when requires
          (mapc
           (lambda (req)
             (unless (or (equal 'emacs (car req))
                         (quelpa--package-installed-p (car req) (cadr req)))
               (package-install (car req))))
           requires))
        (quelpa-package-install-file file)
        ver))))

(advice-add #'quelpa-package-install :override #'my-quelpa-package-install)

(eval-when-compile
  (add-to-list 'load-path (concat user-emacs-directory "lib/")))

(use-package system-packages
  :quelpa (system-packages :fetcher gitlab :repo "canatella/system-packages" :branch "add-package-mapping")
  :custom
  (system-packages-package-manager 'apt)
  (system-packages-map '("fd" (apt . ("fd-find")))))

;; Custom variables are setup using use-package.
(customize-set-variable 'custom-file "/dev/null")
(customize-set-variable 'inhibit-compacting-font-caches '())
