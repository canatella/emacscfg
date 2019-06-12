(use-package counsel-dash
  :ensure t
  :bind (("<f3>" . counsel-dash)
         ("<H-f3>" . counsel-dash-at-point))
  :custom
  (counsel-dash-browser-func #'eww-browse-url)
  :config
  (defun counsel-dash-at-point ()
    "Bring up a `counsel-dash' search interface with symbol at point."
    (interactive)
    (counsel-dash
     (substring-no-properties (or (thing-at-point 'symbol) "")))))
