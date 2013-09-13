;;; use default locale
(setq system-time-locale "C")

;;; backups
(setq backup-directory-alist
      '(("." . "~/.emacs.d/backup-files")))
(setq tramp-backup-directory-alist backup-directory-alist)
(setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

;;; use ssh for tramp
(setq tramp-default-method "ssh")

;;; remeber opened files
(savehist-mode 1)

;;; enable ido
(setq ido-enable-flex-matching t)
(ido-mode 1)
(ido-ubiquitous t) 

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

(defun ruby-string-interp ()
  (interactive)
  (insert "#{}")
  (backward-char))

(add-hook 'ruby-mode-hook
          (lambda () 
            (local-set-key (kbd "\C-c \C-e") 'ruby-close-block)
            (local-set-key (kbd "H-,") 'ruby-string-interp)
            (subword-mode 't)))

;;; flymake
;;(require 'flymake)
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
(add-hook 'c-mode-common-hook 'my-file-make-writeable)

;;; shebang are executable
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;; yasnippet
(require 'yasnippet)
(yas/initialize)
(setq yas/root-directory "~/.emacs.d/yasnippets")
(yas/load-directory yas/root-directory)

;;; rainbow mode
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;;; expand region
(add-to-list 'load-path "~/.emacs.d/site-lisp/expand-region.el")
(require 'expand-region)


(setq package-archives '(
                         ;;("ELPA" . "http://tromey.com/elpa/") 
                         ;;("gnu" . "http://elpa.gnu.org/packages/")
                         ;;("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ;;("SC"   . "http://joseito.republika.pl/sunrise-commander/"))
      ))

(setq stack-trace-on-error t)

;;; shell mode
(defun my-dirtrack-mode ()
  (shell-dirtrack-mode 0)
  (set-variable 'dirtrack-list '("\\(root\\|\\(\r?\ndam\\|dn\\)\\)@\\([^:]+:.*\\)\\(\r?\n\r?\n\\$ \\|# \\)" 3 nil))
  (dirtrack-mode 1))
(add-hook 'shell-mode-hook 'my-dirtrack-mode)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(autoload 'bash-completion-dynamic-complete 
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
  'bash-completion-dynamic-complete)
(add-hook 'shell-command-complete-functions
  'bash-completion-dynamic-complete)

(custom-set-variables
 '(tramp-default-method "ssh")          ; uses ControlMaster
 '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
 '(comint-scroll-to-bottom-on-output nil) ; always add output at the bottom
 '(comint-scroll-show-maximum-output t) ; scroll to show max possible output
 ;; '(comint-completion-autolist t)     ; show completion list when ambiguous
 '(comint-input-ignoredups t)           ; no duplicates in command history
 '(comint-completion-addsuffix t)       ; insert space/slash after file completion
 '(comint-buffer-maximum-size 20000)    ; max length of the buffer in lines
 '(comint-prompt-read-only t)         ; if this is t, it breaks shell-command
 '(comint-get-old-input (lambda () "")) ; what to run when i press enter on a
                                        ; line above the cur
 '(comint-input-ring-size 5000)         ; max shell history size
 '(protect-buffer-bury-p nil)
 )

;;; dired
(require 'dired-details)
(dired-details-install)

;; org-mode
(add-hook 'org-mode-hook 'my/org-mode-hook)

;; vc
(eval-after-load "vc-hooks"
  '(define-key vc-prefix-map "=" 'ediff-revision))
