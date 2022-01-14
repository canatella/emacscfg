(use-package smtpmail
  :custom (send-mail-function 'smtpmail-send-it)
  (smtpmail-smtp-server "mail.gandi.net")
  (smtpmail-smtp-service 587))
