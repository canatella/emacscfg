;;; transparency
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

;;; use nice font
(set-face-font 'default "-unknown-Ubuntu Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

;;; calendar starts on day one
(setq calendar-week-start-day 1)

(provide 'appearance)
