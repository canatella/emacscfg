;; -*- lexical-binding: t; -*-
(defun bloomlife-visit-dashboard ()
  (interactive)
  (message "bloomlife visit dashboard")
  (unless (get-buffer "dashboard.org")
    (let ((left (selected-window))
          (right (split-window-right)))
      (with-selected-window left (find-file "~/Desktop/Bloomlife/org/dashboard.org")))))

(use-package magit-async-section :straight
  (magit-async-section :type git :host github :repo "canatella/magit-async-section"))
(use-package atlassian :straight (atlassian :type git :host github :repo "canatella/atlassian-el"))
(use-package circleci :straight (circleci :type git :host github :repo "canatella/circleci-el"))
(use-package sonar :straight (sonar :type git :host github :repo "canatella/sonar-el"))
(use-package bloomlife :straight
  (bloomlife :type git :host bitbucket :protocol ssh :repo "bloomlife/bloom-el") ;;
  :after (cmake-api android)
  :config ;;
  (bloom-global-minor-mode t))

;;(setenv "FIRESTORE_EMULATOR_HOME" "/Users/dam/Desktop/Bloomlife/repos/firestore-rules")
