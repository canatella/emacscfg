;; -*- lexical-binding: t; -*-
(use-package aio :ensure t)

(defun bloomlife-visit-dashboard ()
  (interactive)
  (message "bloomlife visit dashboard")
  (unless (get-buffer "dashboard.org")
    (let ((left (selected-window))
          (right (split-window-right)))
      (with-selected-window left (find-file "~/Desktop/Bloomlife/org/dashboard.org")))))

(use-package-local jiracs
  :custom ;;
  (jiracs-jira-url "https://bloomlife.atlassian.net/")
  (jiracs-jira-available-projects '("BLP" "DM")))

(use-package-local bloomlife ;;
  :after (cmake-api android)
  :config ;;
  (bloom-global-minor-mode t))

;;(setenv "FIRESTORE_EMULATOR_HOME" "/Users/dam/Desktop/Bloomlife/repos/firestore-rules")
