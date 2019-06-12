;; Setup modifier keys for macos.
(use-package ns-win
  :if (string= system-type "darwin")
  :custom
  (mac-right-command-modifier 'hyper)
  (mac-right-option-modifier '())
  (mac-option-modifier 'meta)
  (mac-command-modifier 'hyper))
