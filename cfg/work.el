;; -*- lexical-binding: t; -*-
(defun bloomlife-visit-dashboard ()
  (interactive)
  (message "bloomlife visit dashboard")
  (unless (get-buffer "dashboard.org")
    (let ((left (selected-window))
          (right (split-window-right)))
      (with-selected-window left
        (find-file "~/Desktop/Bloomlife/org/dashboard.org")))))

(use-package magit-async-section
  :quelpa (magit-async-section :fetcher github :repo "canatella/magit-async-section"))

(use-package atlassian
  :quelpa (atlassian :fetcher github :repo "canatella/atlassian-el")
  :custom
  (atlassian-user "damien@bloom-life.com")
  (atlassian-bitbucket-user "dmerenne"))

(use-package circleci
  :quelpa (circleci :fetcher github :repo "canatella/circleci-el"))
(use-package sonar
  :quelpa (sonar :fetcher github :repo "canatella/sonar-el"))

(use-package bloom
  :quelpa (bloom :fetcher git :url "git@bitbucket.org:bloomlife/bloom-el.git")
  :custom
  (bloom-global-minor-modes t)
  (bloom-global-minor-mode t)
  (bloom-magit-jira-projects '("GOOD" "HAP")))

(defun bloom-project-goodall-setup ()
  "Setup for goodall project"
  (setq-local compile-command "backend/gradlew -p backend --daemon --parallel assembleDist")
  (setq-local project-lint-command "ktlint backend/*/src/**/*.kt")
  (setq-local test-runner-backend 'kotest)
  (test-runner-mode t))


(use-package slack
  :disabled
  :quelpa (slack :fetcher github :repo "aculich/emacs-slack" :branch "cookie")
  :custom
  (slack-buffer-emojify t)
  (slack-image-file-directory "/home/dam/.cache/emacs/slack")
  (slack-profile-image-file-directory "/home/dam/.cache/emacs/slack")
  (slack-prefer-current-team t)
  :config
  (mkdir "/home/dam/.cache/emacs/slack" t)
  (slack-register-team
   :name "bloom-life"
   :default t
   :token (auth-source-pick-first-password :host "bloom-life.slack.com" :user "damien@bloom-life.com")
   :cookie
   (auth-source-pick-first-password
    :host "bloom-life.slack.com"
    :user "damien@bloom-life.com^cookie")
   ;;   :subscribed-channels '(test-rename rrrrr)
   :full-and-display-names t))

(use-package password-generator
  :config

  (defun password-generator-biot (&optional pre-len return)
    "Password generated with BioT rules.  PRE-LEN is prefix arg that defines password lenght.  RETURN specifies if password should be returned or inserted."
    (interactive)
    (let* ((password "")
           (pass-length 32)
           (symbols-for-pass "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"))
      (setq password (password-generator-generate-internal symbols-for-pass pass-length))
      (cond
       ((equal nil return)
        (insert password))
       (t
        password)))))
