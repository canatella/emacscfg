(require 'org)
(require 'magit)
;;; Code:

(org-link-set-parameters
 "vip"
 :follow #'org-link-vip-open)

(defun org-link-vip-open (path)
  "Open org vip link for PATH."
  (let ((vip "/Users/dam/Desktop/Veygo/vip/"))
    (if (string-match "^/\\(vip-\\|vendor/\\)[^/]+$" path)
        (magit-status-internal (concat vip path))
      (find-file (concat vip path)))))

(provide 'org-vip)
