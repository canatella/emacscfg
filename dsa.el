;;(defun my-dsa-c-mode-hook ()
;;  (interactive)
;;  (subword-mode 't)
;;  (gtags-mode 't)
;;  (semantic-mode 't)
;;  (semantic-idle-summary-mode 't)cd
;;  (semantic-stickyfunc-mode 't)
;;  (semanticdb-enable-gnu-global-databases 'c-mode)
;;  (semanticdb-enable-gnu-global-databases 'c++-mode)
;;  (define-key c-mode-map (kbd "H-j") 'semantic-ia-fast-jump)
;;  (define-key c++-mode-map (kbd "H-j") 'semantic-ia-fast-jump))
;;
;;(add-hook 'c-mode-common-hook 'my-dsa-c-mode-hook)

;;                :include-path '("/"
;;                                "/Common"
;;                                "/Interfaces"
;;                                "/Libs"
;;                               )
;;                :system-include-path '("~/exp/include")
;;                :spp-table '(("isUnix" . "")
;;                             ("BOOST_TEST_DYN_LINK" . "")))

(setq dsa/develop (file-name-as-directory "/home/dam/Build/develop/"))
(setq dsa/tcl-major "8.5")
(setq dsa/tcl-minor "8.5.9")
(setq dsa/libc-projects '("aes" "des" "gaf" "mqs" "rtx" "xml" "anet" "calc" "cont" "file" "link" 
                          "prot" "rfid" "tftp" "time" "unix" "zlib" "libshared" "ascii" "cadul" 
                          "dbapi" "dtobj" "expat" "fzdio" "lptio" "mpsse" "share" "netsock" 
                          "mthread" "dsasystemjni" "unittest" "process" "bluetooth" "cipher" 
                          "xmlXerces" "rtx-2.2" "licapi" "prot2x" "display" "unicode"
                          "verinfo" "xmllibxml2" "measure" "logtool"))
(setq dsa/create-tag "/home/dam/Build/gentags.sh")

(ede-cpp-root-project "fistcl" 
                      :name "fisTCL"
                      :version dsa/tcl-minor
                      :file (format "%sextern/tcl%s/tcl%s/ChangeLog" dsa/develop 
                                    dsa/tcl-major dsa/tcl-minor)
                      :include-path (list "/generic" "/include"))

(ede-cpp-root-project "fislibc" 
                      :name "C libraries"
                      :file (format "%slib/libc/Makefile" dsa/develop)
                      :include-path (append (list "/") 
                                            (mapcar (lambda (s) (format "/include/%s" s))
                                                    dsa/libc-projects)
                                            (mapcar (lambda (s) (format "/src/%s" s))
                                                    dsa/libc-projects)))

(ede-cpp-root-project "fisgate" 
                      :name "Fisgate"
                      :version "22.03"
                      :file (concat dsa/develop "app/fisgate/fisgate/fisgate/Makefile.dsa")
                      :include-path (list "/")
                      :system-include-path (list "/usr/include" 
                                                 (format "%slib/libc/include" dsa/develop)
                                                 (format "%sextern/tcl%s/tcl%s/generic" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor)
                                                 (format "%sextern/tcl%s/tcl%s/unix" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor))
                      :spp-table '(("HAVE_CONFIG_H" . "")
                                   ("LINUX" . "")
                                   ("FISGATE_LX" . "")))

(ede-cpp-root-project "redcat" 
                      :name "Redcat"
                      :version "1.71"
                      :file (concat dsa/develop "app/tools/redcat/redcat.spec")
                      :include-path (list "/")
                      :system-include-path (list "/usr/include" 
                                                 (format "%slib/libc/include" dsa/develop)
                                                 (format "%sextern/tcl%s/tcl%s/generic" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor)
                                                 (format "%sextern/tcl%s/tcl%s/unix" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor))
                      :spp-table '(("HAVE_CONFIG_H" . "")
                                   ("LINUX" . "")))

(ede-cpp-root-project "mdimanager" 
                      :name "MDIManager"
                      :version "1.4.25"
                      :file (concat dsa/develop "app/tester/vci_update/mdimanager/mdimanager.spec")
                      :include-path (list "/common" "/lib")
                      :system-include-path (list "/usr/include" 
                                                 (format "%slib/libc/include" dsa/develop)
                                                 (format "%sapp/tools/redcat" dsa/develop)
                                                 (format "%sextern/tcl%s/tcl%s/generic" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor)
                                                 (format "%sextern/tcl%s/tcl%s/unix" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor))
                      :spp-table '(("HAVE_CONFIG_H" . "")
                                   ("LINUX" . "")))

;; distribution testing
(ede-cpp-root-project "prosh" 
                      :name "Prosh"
                      :file (concat dsa/develop "app/tools/prosh/prosh.spec")
                      :include-path (list "/")
                      :system-include-path (list "/usr/include" 
                                                 (format "%slib/libc/include" dsa/develop)))

;(ede-cpp-root-project "poci" 
;                      :name "Poci"
;                      :version "22.03"
;                      :file (concat dsa/develop "app/fisgate/poci/poci/Makefile.dsa")
;                      :include-path (list "/")
;                      :system-include-path (list "/usr/include" 
;                                                 (concat dsa/develop "lib/libc/include")
;                                                 (format "%sextern/tcl%s/tcl%s/generic" dsa/develop 
;                                                         dsa/tcl-major dsa/tcl-minor)
;                                                 (format "%sextern/tcl%s/tcl%s/unix" dsa/develop 
;                                                         dsa/tcl-major dsa/tcl-minor))
;                      :spp-table '(("HAVE_CONFIG_H" . "")
;                                   ("LINUX" . "")
;                                   ("FISGATE_LX" . "")))
;
(defun dsa/create-tag-script ()
  (interactive)
  (with-temp-file dsa/create-tag
    (insert "#!/bin/sh\n")
    (mapc (lambda (project)
            (insert (format "gtags -i %s\n" 
                            (replace-regexp-in-string "/home/dam/Build/" "/home/dn/"
                                                      (ede-cpp-root-project-root (file-name-directory (oref project :file)))))))
          ede-cpp-root-project-list))
  (set-file-modes dsa/create-tag ?\755))

(setq auto-mode-alist (cons '("Makefile" . makefile-gmake-mode) auto-mode-alist))

