
(setenv "PATH" "/app/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin")
(require 'package)
(customize-set-variable 'package-user-dir (concat user-emacs-directory "var/elpa"))
(customize-set-variable 'package-gnupghome-dir (concat package-user-dir "/gnupg"))
(customize-set-variable 'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			                    ("melpa" . "https://melpa.org/packages/")))
