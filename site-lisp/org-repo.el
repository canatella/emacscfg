(require 'org)
(require 'repo)

;;; Code:
(defun org-repo-store-link ()
  "Store a link to a repo status buffer."
  (when (eq major-mode 'repo-status-mode)
    (let* ((workspace repo-workspace)
           (link (format "repo:%s" workspace))
           (description (format "repo status for %s" workspace)))
      (org-store-link-props
       :type "repo"
       :link link
       :description description))))

(org-link-set-parameters
 "repo"
 :follow #'repo-status
 :store #'org-repo-store-link)

(provide 'org-repo)
