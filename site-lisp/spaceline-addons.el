;;; spaceline-alert.el -- Integration between alert.el and spaceline.el

;;; Commentary:

;; This package adds a visual clue in the spaceline modeline.

;;; Code:

(require 'cl-lib)

(defun spaceline-alert-output ()
  "Return the number of alert as string."
  (let ((face `(:height ,(spaceline-all-the-icons--height 0.9) :inherit)))
    (concat
     (propertize (all-the-icons-faicon "comments" :v-adjust 0.1)
                 'face `(:height ,(spaceline-all-the-icons--height 1.1) :family ,(all-the-icons-faicon-family) :inherit))
     " "
     (propertize (format "%s" (length alert-active-alerts)
                         'face face
                         'display '(raise 0.1))))))

(spaceline-define-segment alerts
  "An `alerts' segments displaying alert.el pending alerts."
  (spaceline-alert-output)
  :tight t)

(defun slack-unread-count ()
  "Count number of unread messages."
  (let ((teams (slack-team-connected-list))
        (count 0))
    (dolist (team teams count)
      (with-slots (groups ims channels) team
        (dolist (room (append ims groups channels))
          (setq count (+ count (oref room unread-count-display))))))))

(defun spaceline-slack-unread-output ()
  "Return the number of of unread message as string."
  (let ((face `(:height ,(spaceline-all-the-icons--height 0.9) :inherit)))
    (concat
     (propertize (all-the-icons-faicon "comments" :v-adjust 0.1)
                 'face `(:height ,(spaceline-all-the-icons--height 1.1) :family ,(all-the-icons-faicon-family) :inherit))
     " "
     (propertize (format "%s" (slack-unread-count)
                         'face face
                         'display '(raise 0.1))))))

(spaceline-define-segment slack
  "A `slack' segment displaying slack unread message count."
  (spaceline-slack-unread-output)
  :tight t)
(provide 'spaceline-addons)

;;; spaceline-addons.el ends here
