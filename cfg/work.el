;; -*- lexical-binding: t; -*-
(defun bloomlife-visit-dashboard ()
  (interactive)
  (message "bloomlife visit dashboard")
  (unless (get-buffer "dashboard.org")
    (let ((left (selected-window))
          (right (split-window-right)))
      (with-selected-window left (find-file "~/Desktop/Bloomlife/org/dashboard.org")))))

(use-package magit-async-section :quelpa
  (magit-async-section :fetcher github :repo "canatella/magit-async-section"))
(use-package request :ensure t)
(use-package atlassian :quelpa
  (atlassian :fetcher github :repo "canatella/atlassian-el")
  :after request
  :custom (atlassian-user "damien@bloom-life.com")
  (atlassian-bitbucket-user "dmerenne"))

(use-package circleci :quelpa (circleci :fetcher github :repo "canatella/circleci-el"))
(use-package sonar :quelpa (sonar :fetcher github :repo "canatella/sonar-el"))

(use-package bloom :quelpa
  (bloom :fetcher git :url "git@bitbucket.org:bloomlife/bloom-el.git")
  :custom (bloom-global-minor-modes t)
  (bloom-global-minor-mode t)
  (bloom-magit-jira-projects '("HAP")))

(defun bloom-project-goodall-setup ()
  "Setup for goodall project"
  (setq-local compile-command "backend/gradlew -p backend --daemon --parallel assembleDist")
  (setq-local project-lint-command "ktlint backend/*/src/**/*.kt")
  (setq-local test-runner-backend 'kotest)
  (test-runner-mode t))



;;(setenv "FIRESTORE_EMULATOR_HOME" "/Users/dam/Desktop/Bloomlife/repos/firestore-rules")


(use-package slack
  :disabled :quelpa
  (slack :fetcher github :repo "aculich/emacs-slack" :branch "cookie")
  :custom (slack-buffer-emojify t)
  (slack-image-file-directory "/home/dam/.cache/emacs/slack")
  (slack-profile-image-file-directory "/home/dam/.cache/emacs/slack")
  (slack-prefer-current-team t)
  :config (mkdir "/home/dam/.cache/emacs/slack" t)
  (slack-register-team
   :name "bloom-life"
   :default t
   :token (auth-source-pick-first-password :host "bloom-life.slack.com" :user "damien@bloom-life.com")
   :cookie (auth-source-pick-first-password :host "bloom-life.slack.com" :user "damien@bloom-life.com^cookie")
   ;;   :subscribed-channels '(test-rename rrrrr)
   :full-and-display-names t))
