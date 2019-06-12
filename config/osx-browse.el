(use-package osx-browse
  :ensure t
  :if (string= system-type "darwin"))

(use-package browse-url
  :custom
  (browse-url-browser-function #'osx-browse-url-firefox))
