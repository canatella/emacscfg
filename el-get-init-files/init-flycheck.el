;;(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'flycheck-mode-hook 'my/flycheck-hook)
(global-flycheck-mode)

(defadvice semantic-idle-summary-idle-function (around my/show-flycheck-error activate)
  (if (flycheck-overlay-errors-at (point))
      (flycheck-display-error-at-point)
    ad-do-it))

(defadvice flyc/maybe-fixup-message (around my/change-flycheck-error-face activate)
  ad-do-it
  (setq ad-return-value
        (let ((line-err-info-list (flyc/-get-error-at-point)))
          (propertize ad-return-value 'face
                      (cond ((string= (aref line-err-info-list 3) "e")
                             'flycheck-errline)
                            ((string= (aref line-err-info-list 3) "w")
                             'flycheck-warnline)
                            (t 'flycheck-infoline))))))
