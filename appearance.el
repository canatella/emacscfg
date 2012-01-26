;;; transparency
(set-frame-parameter (selected-frame) 'alpha '(85 85))
(add-to-list 'default-frame-alist '(alpha 85 85))

;;; font-lock
(global-font-lock-mode 1)

;;; use nice font
(set-face-font 'default "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

;;; no splash
(setq inhibit-startup-message t)

;;; no scrollbar and buttons
(scroll-bar-mode nil)
(tool-bar-mode nil)

;;; colors
(require 'color-theme)
(require 'color-theme-tango)
(setq color-theme-is-global t)
(color-theme-tango)

;; calendar starts on monday
(setq calendar-week-start-day 1)