;;; transparency
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

;;; font-lock
(global-font-lock-mode 1)

;;; use nice font
(set-face-font 'default "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

;;; no splash
(setq inhibit-startup-message t)

;;; no scrollbar and buttons
(scroll-bar-mode -1)
(tool-bar-mode -1)

;;; colors
(load-theme 'my-tango-dark t)

;; calendar starts on monday
(setq calendar-week-start-day 1)
