;; -*- lexical-binding: t; -*-
(use-package mastodon
  :disabled
  :ensure t
  :custom
  (mastodon-client--token-file (no-littering-expand-var-file-name "mastodon/mastodon.plstore"))
  (mastodon-instance-url "https://masto.ai/")
  (mastodon-active-user "dam"))
