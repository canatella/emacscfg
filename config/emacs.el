(defun my-visit-config ()
    (interactive)
    (find-file "~/.emacs.d/config.org"))

(defun my-indent-buffer ()
         "Re-indent current buffer."
         (interactive)
         (delete-trailing-whitespace)
         (indent-region (point-min) (point-max))
         (untabify (point-min) (point-max)))

(use-package emacs
  :bind (("H-s" . save-buffer)
         ("<f12>" . my-visit-config)
         ("<f2>" . my-indent-buffer))
  :hook ((before-save . delete-trailing-whitespace)
         (minibuffer-setup . gc-cons-threshold-max)
         (minibuffer-exit . gc-cons-threshold-normal))
  :custom
  (inhibit-startup-screen t "No startup screen.")
  (ctl-arrow '() "Display octal value for control chars.")
  (display-raw-bytes-as-hex t "Use hexadecimal for non printable bytes.")
  (fill-column 80 "Auto fill at 80 chars.")
  (split-height-threshold '() "do not split window verticaly unless I ask for it.")
  (indent-tabs-mode '() "Use spaces for indentation.")
  :config
  (open-dribble-file "~/.emacs.d/dribble"))
