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
  (global-set-key (kbd "s-a") #'backward-char)
  (global-set-key (kbd "s-e") #'forward-char)
  (global-set-key (kbd "s-u") #'previous-line)
  (global-set-key (kbd "s-i") #'next-line)
  (global-set-key (kbd "s-à") #'beginning-of-line)
  (global-set-key (kbd "s-.") #'end-of-line)
  (global-set-key (kbd "s-b") #'sp-backward-sexp)
  (global-set-key (kbd "s-o") #'sp-forward-sexp)
  (global-set-key (kbd "C-M-d") #'sp-up-sexp)
  (global-set-key (kbd "C-M-l") #'sp-down-sexp)
  (global-set-key (kbd "s-k") #'sp-kill-sexp)
  (global-set-key (kbd "s--") #'negative-argument)
  (global-set-key (kbd "s-,") #'negative-argument)
  (global-set-key (kbd "C-«") #'beginning-of-buffer)
  (global-set-key (kbd "C-»") #'end-of-buffer)

  (global-set-key (kbd "s-x") ctl-x-map)
  (global-set-key (kbd "s-\"") #'delete-other-windows)
  (global-set-key (kbd "s-«") #'split-window-below)
  (global-set-key (kbd "s-»") #'split-window-right)
  (global-set-key (kbd "M-«") #'beginning-of-buffer)
  (global-set-key (kbd "M-»") #'end-of-buffer)
  (global-set-key (kbd "M-à") #'delete-horizontal-space)
  (global-set-key (kbd "¡") #'delete-indentation)
  (global-set-key (kbd "s-*") #'delete-window))

(provide 'bepo)

;;; bepo.el ends here
