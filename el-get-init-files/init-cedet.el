(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode) 
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
(semantic-mode 1)


(semanticdb-enable-gnu-global-databases 'c-mode t)
(semanticdb-enable-gnu-global-databases 'c++-mode t)
 
(semantic-load-enable-all-ectags-support)
(global-srecode-minor-mode 1)

(defadvice semantic-mrub-completing-read (around semantic-mrub-completing-read-around activate)
  "use ido-completing-read in semantic-mrub-completing-read"
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
         (ans nil)
         (alist (semantic-mrub-ring-to-assoc-list ring))
         (first (cdr (car alist)))
         (semantic-mrub-read-history nil)
         (choices nil)
         )
    ;; Don't include the current tag.. only those that come after.
    (if (semantic-equivalent-tag-p (oref first tag)
                                   (semantic-current-tag))
        (setq first (cdr (car (cdr alist)))))
    ;; Create a fake history list so we don't have to bind
    ;; M-p and M-n to our special cause.
    (let ((elts (reverse alist)))
      (while elts
        (setq semantic-mrub-read-history
              (cons (car (car elts)) semantic-mrub-read-history))
        (setq elts (cdr elts))))
    (setq semantic-mrub-read-history (nreverse semantic-mrub-read-history))

    ;; Do the read/prompt
    (let ((prompt (if first (format "%s (%s): " prompt
                                    (semantic-format-tag-name
                                     (oref first tag) t)
                                    )
                    (concat prompt ": ")))
          )
      (setq ans
                                        ;(completing-read prompt alist nil nil nil 'semantic-mrub-read-history)))
            (ido-completing-read prompt semantic-mrub-read-history nil nil nil 'semantic-mrub-read-history)))
    ;; Calculate the return tag.
    (if (string= ans "")
        (setq ans first)
      ;; Return the bookmark object.
      (setq ans (assoc ans alist))
      (if ans
          (cdr ans)
        ;; no match.  Custom word.  Look it up somwhere?
        nil)
      )))

(setq ede-locate-setup-options
      '(ede-locate-global ede-locate-locate ede-locate-base))
(global-ede-mode 1)
(ede-enable-generic-projects)
