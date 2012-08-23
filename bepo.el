;; lets try editing on left hand, moving on right

(defun bépo-scroll-down ()
  (interactive)
  (next-line 15))

(defun bépo-scroll-up ()
  (interactive)
  (previous-line 15))

(defun bépo-ido-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map (kbd "C-t ") 'ido-prev-match)
  (define-key ido-completion-map (kbd "C-r ") 'ido-next-match)
  )

(defun -ido-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map (kbd "C-t ") 'ido-prev-match)
  (define-key ido-completion-map (kbd "C-r ") 'ido-next-match)
  )


(defun bépo-mode ()
  (interactive)

  ;; kill-region on C-g 
  (global-unset-key (kbd "C-,"))
  (global-unset-key (kbd "C-w"))
  (global-set-key (kbd "C-,") 'kill-region)

  ;; kill-ring-save on M-g
  (global-unset-key (kbd "M-,"))
  (global-unset-key (kbd "M-w"))
  (global-set-key (kbd "M-,") 'kill-ring-save)
  
  ;; set-mark-command on C-.
  (global-unset-key (kbd "C-."))
  (global-unset-key (kbd "C-SPC"))
  (global-set-key (kbd "C-.") 'set-mark-command)

  ;; yank on C-p
  (global-unset-key (kbd "C-p"))
  (global-unset-key (kbd "C-y"))
  (global-set-key (kbd "C-p") 'yank)

  ;; yank-pop on M-p
  (global-unset-key (kbd "M-p"))
  (global-unset-key (kbd "M-y"))
  (global-set-key (kbd "M-p") 'yank-pop)
  
  ;; moves on arrow like dtsr
  (global-unset-key (kbd "C-f"))
  (global-unset-key (kbd "C-b"))
  (global-unset-key (kbd "C-n"))
  (global-unset-key (kbd "C-d"))
  (global-unset-key (kbd "C-s"))
  (global-unset-key (kbd "C-t"))
  (global-unset-key (kbd "C-r"))
  (global-set-key (kbd "C-t") 'backward-char)
  (global-set-key (kbd "C-r") 'forward-char)
  (global-set-key (kbd "C-d") 'previous-line)
  (global-set-key (kbd "C-s") 'next-line)

  ;; idem for word and scroll
  (global-unset-key (kbd "M-f"))
  (global-unset-key (kbd "M-b"))
  (global-unset-key (kbd "M-v"))
  (global-unset-key (kbd "C-v"))
  (global-unset-key (kbd "M-d"))
  (global-unset-key (kbd "M-s"))
  (global-unset-key (kbd "M-t"))
  (global-unset-key (kbd "M-r"))
  (global-set-key (kbd "M-t") 'backward-word)
  (global-set-key (kbd "M-r") 'forward-word)
  (global-set-key (kbd "M-d") 'bépo-scroll-up)
  (global-set-key (kbd "M-s") 'bépo-scroll-down)

  ;; paragraph move
  (global-set-key (kbd "C-(") 'backward-paragraph)
  (global-set-key (kbd "C-)") 'forward-paragraph)

  ;; delete is on v
  (global-set-key (kbd "C-v") 'delete-char)
  (global-set-key (kbd "M-v") 'kill-Word)
  
  ;; isearch on the é
  (global-set-key (kbd "C-é") 'isearch-forward)
  (global-set-key (kbd "M-é") 'isearch-backward)

  ;; isearch on the é
  (global-set-key (kbd "C-é") 'isearch-forward)
  (global-set-key (kbd "M-é") 'isearch-backward)

  ;; s-i is C-x
  (global-set-key (kbd "s-i") 'Control-X-prefix)

  (add-hook 'ido-setup-hook 'bépo-ido-keys) 
)

(bépo-mode)
