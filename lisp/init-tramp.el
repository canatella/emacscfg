(setq tramp-backup-directory-alist backup-directory-alist
      ;; defaults to ssh
      tramp-default-method "ssh")

;;; allow opening as root with sudo over ssh
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))

(provide 'init-tramp)
