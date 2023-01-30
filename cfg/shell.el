(use-package vterm
  :ensure t
  :hook (vterm-mode . with-editor-export-editor)
  :custom
  (vterm-shell "/bin/bash")
  (vterm-kill-buffer-on-exit t)
  (vterm-eval-cmds
   '(("find-file" find-file)
     ("message" message)
     ("vterm-clear-scrollback" vterm-clear-scrollback)
     ("woman" woman)))
  :bind (("C-c e" . vterm-end-of-line) :map project-prefix-map ("s" . project-vterm))
  :custom
  (vterm-buffer-name-string "*vterm %s*")
  (vterm-max-scrollback 1000000)
  :config
  (defun project-vterm ()
    "Start a vterm buffer in current project"
    (interactive)
    (let* ((default-directory (project-root (project-current t)))
           (default-project-shell-name
            (format "*vterm %s*"
                    (file-name-nondirectory
                     (directory-file-name (file-name-directory default-directory)))))
           (shell-buffer (get-buffer default-project-shell-name)))
      (if (and shell-buffer (not current-prefix-arg))
          (pop-to-buffer shell-buffer)
        (vterm (generate-new-buffer-name default-project-shell-name)))
      (setq-local vterm-buffer-name-string default-project-shell-name))))
