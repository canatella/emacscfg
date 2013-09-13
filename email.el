
(setq user-mail-address "damien.merenne@dsa-ac.de")
(setq user-full-name "Damien Merenne")

(setq wl-init-file "~/.emacs.d/wl/init.el")
(setq wl-folders-file "~/.emacs.d/wl/folders")
(setq wl-address-file "~/.emacs.d/wl/addresses")
(setq wl-alias-file "~/.emacs.d/wl/aliases")
(setq wl-ldap-server "dsa2a")
(setq wl-ldap-port 389)
(setq wl-ldap-base "ou=people,dc=dsa-ac,dc=de")
(setq wl-use-ldap t)

(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)
(autoload 'wl-user-agent-compose "wl-draft" nil t)

(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))

(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-auth-credentials (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "mail.dsa-ac.de"
      smtpmail-smtp-server "mail.dsa-ac.de"
      smtpmail-smtp-service 645
      smtpmail-debug-info t)
(require 'smtpmail)
