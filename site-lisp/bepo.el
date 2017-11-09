;;; bepo.el -- Ease key map when using Bépo

;;; Commentary:

;; This remaps some key to a more accesible keys in the Bépo layout.

;;; Code:
(define-minor-mode bepo-global-mode
  "Easy some global key mapping when using bépo keyboard"
  :init-value nil
  :lighter nil
  :group 'bepo
  :global t

  ;; When programming, <> are more importent then «»,
  (global-set-key (kbd "«") (lambda () (interactive) (insert "<")))
  (global-set-key (kbd "»") (lambda () (interactive) (insert ">")))
  (global-set-key (kbd "s-«") (lambda () (interactive) (insert "«")))
  (global-set-key (kbd "s-»") (lambda () (interactive) (insert "»")))

  ;; The c-x number shortcuts needs shift so unshift the one I use and use them
  ;; with command to make things even simpler
  (global-set-key (kbd "H-\"") #'delete-other-windows)
  (global-set-key (kbd "H-y") #'backward-paragraph)
  (global-set-key (kbd "H-x") #'forward-paragraph)
  (global-set-key (kbd "H-«") #'split-window-below)
  (global-set-key (kbd "H-»") #'split-window-right)
  (global-set-key (kbd "M-«") #'beginning-of-buffer)
  (global-set-key (kbd "M-»") #'end-of-buffer)
  (global-set-key (kbd "M-à") #'delete-horizontal-space)
  (global-set-key (kbd "¡") #'delete-indentation)
  (global-set-key (kbd "H-*") #'delete-window))

(provide 'bepo)

;;; bepo.el ends here
