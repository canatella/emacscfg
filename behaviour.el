;;; backups
(setq backup-directory-alist
      '(("." . "~/.emacs.d/backup-files")))
(setq tramp-backup-directory-alist backup-directory-alist)
(setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

;;; remeber opened files
(savehist-mode 1)

;;; enable ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;;; html-mode
(add-hook 'sgml-mode-hook
	  (lambda () (local-set-key (kbd "\C-c \C-e") 'sgml-close-tag)))
(setq auto-mode-alist (cons '("\\.html.m4$" . html-mode) auto-mode-alist))

;; nxml-mode
(add-hook 'nxml-mode-hook
	  (lambda () (local-set-key (kbd "\C-c \C-e") 'nxml-finish-element)))

;;; latex-mode
(add-hook 'latex-mode-hook
	  (lambda () (local-set-key (kbd "\C-c \C-e") 'tex-close-latex-block)))

;;; ruby-mode
(defun ruby-close-block ()
  (interactive)
  (unless (string-match "^[[:blank:]]*$" (buffer-substring (line-beginning-position) (line-end-position)))
    (newline))
  (insert "end")
  (ruby-indent-line))

(add-hook 'ruby-mode-hook
          (lambda () 
            (local-set-key (kbd "\C-c \C-e") 'ruby-close-block)
            (subword-mode 't)))

;;; semantic
(require 'semantic)
(setq semanticdb-default-save-directory "~/.emacs.d/semantic-cache")

;;; flymake
(require 'flymake)
(setq flymake-run-in-place nil)

(defun my-toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))
;;; guess offset
(add-hook 'c-mode-common-hook 
  (lambda()
    (require 'dtrt-indent)
    (dtrt-indent-mode t)))

;;; c-mode
(font-lock-add-keywords 'c-mode
      '(("\\<\\(int8_t\\|int16_t\\|int32_t\\|int64_t\\|uint8_t\\|uint16_t\\|uint32_t\\|uint64_t\\)\\>" . font-lock-keyword-face)))
