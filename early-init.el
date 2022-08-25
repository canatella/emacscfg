;;(setenv "PATH" "/app/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin")
(setq package-enable-at-startup nil
      warning-minimum-level :warning)
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))
