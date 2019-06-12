(use-package org-gcal
  :ensure t
  :bind ("C-c a" . org-agenda)
  :hook ((org-agenda-mode . org-gcal-sync)
         (org-capture-after-finalize-hook . org-gcal-sync))
  :custom
  (org-gcal-file-alist '(("damien@bloom-life.com" .  "~/Desktop/Bloomlife/calendar.org")))
  (org-agenda-files '("~/Desktop/Bloomlife/org/dashboard.org"
                      "~/Desktop/Bloomlife/org/calendar.org"
                      "~/Desktop/Bloomlife/org/jira.org"))
  :config
  (let* ((auth (car (auth-source-search :max 1 :host "calendar.google.com" :require '(:user :secret))))
         (user (plist-get auth :user))
         (tmp-secret (plist-get auth :secret))
         (secret (if (functionp tmp-secret) (funcall tmp-secret) temp-secret)))
    (customize-set-variable 'org-gcal-client-id user)
    (customize-set-variable 'org-gcal-client-secret secret)))
