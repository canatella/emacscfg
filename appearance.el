;;; transparency
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

;;; font-lock
(global-font-lock-mode 1)

;;; use nice font
(set-face-font 'default "-unknown-Ubuntu Mono-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")

;;; no splash
(setq inhibit-startup-message t)

;;; no scrollbar and buttons
(scroll-bar-mode -1)
(tool-bar-mode -1)

;;; colors
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'solarized-dark t)
;; hyper plane, tango 2, zen-and-art, solarized-dark, subatomic, dotshare

(setq calendar-week-start-day 1)
