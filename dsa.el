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

(setq dsa/develop (file-name-as-directory "/home/dam/Build/build/fsdtool/arm-l04/"))
(setq dsa/tcl-major "8.5")
(setq dsa/tcl-minor "8.5.9")
(setq dsa/libc-projects '("aes" "des" "gaf" "mqs" "rtx" "xml" "anet" "calc" "cont" "file" "link" 
                          "prot" "rfid" "tftp" "time" "unix" "zlib" "libshared" "ascii" "cadul" 
                          "dbapi" "dtobj" "expat" "fzdio" "lptio" "mpsse" "share" "netsock" 
                          "mthread" "dsasystemjni" "unittest" "process" "bluetooth" "cipher" 
                          "xmlXerces" "rtx-2.2" "licapi" "prot2x" "display" "unicode"
                          "verinfo" "xmllibxml2" "measure" "logtool"))
(setq dsa/create-tag "/home/dam/Build/gentags.sh")

;(ede-cpp-root-project "fistcl" 
;                      :name "fisTCL"
;                      :version dsa/tcl-minor
;                      :file (format "%sextern/tcl%s/tcl%s/ChangeLog" dsa/develop 
;                                    dsa/tcl-major dsa/tcl-minor)
;                      :include-path (list "/generic" "/include"))
;
;(ede-cpp-root-project "fislibc" 
;                      :name "C libraries"
;                      :file (format "%slib/libc/Makefile" dsa/develop)
;                      :include-path (append (list "/") 
;                                            (mapcar (lambda (s) (format "/include/%s" s))
;                                                    dsa/libc-projects)
;                                            (mapcar (lambda (s) (format "/src/%s" s))
;                                                    dsa/libc-projects)))
;
;(ede-cpp-root-project "fisgate" 
;                      :name "Fisgate"
;                      :version "22.03"
;                      :file (concat dsa/develop "app/fisgate/fisgate/fisgate/Makefile.dsa")
;                      :include-path (list "/")
;                      :system-include-path (list "/usr/include" 
;                                                 (format "%slib/libc/include" dsa/develop)
;                                                 (format "%sextern/tcl%s/tcl%s/generic" dsa/develop 
;                                                         dsa/tcl-major dsa/tcl-minor)
;                                                 (format "%sextern/tcl%s/tcl%s/unix" dsa/develop 
;                                                         dsa/tcl-major dsa/tcl-minor))
;                      :spp-table '(("HAVE_CONFIG_H" . "")
;                                   ("LINUX" . "")
;                                   ("FISGATE_LX" . "")))

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
                      :include-path (list "/common" "/lib" "/server" "/sysupdater"
                                          "/sysupdater/mtd" "/client" "/tools" "/mdiclient")
                      :system-include-path (list "/usr/include" 
                                                 (format "%slib/libc/include" dsa/develop)
                                                 (format "%sapp/tools/redcat" dsa/develop)
                                                 (format "%sextern/tcl%s/tcl%s/generic" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor)
                                                 (format "%sextern/tcl%s/tcl%s/unix" dsa/develop 
                                                         dsa/tcl-major dsa/tcl-minor))
                      :spp-table '(("HAVE_CONFIG_H" . "")
                                   ("LINUX" . "")
                                   ("CONFIG_REDCAT" . "")))

;; distribution testing
;(ede-cpp-root-project "prosh" 
;                      :name "Prosh"
;                      :file (concat dsa/develop "app/tools/prosh/prosh.spec")
;                      :include-path (list "/")
;                      :system-include-path (list "/usr/include" 
;                                                 (format "%slib/libc/include" dsa/develop)))

;; distribution testing
(ede-cpp-root-project "wland" 
                      :name "Wland"
                      :file (concat dsa/develop "app/tools/wland/wland.spec")
                      :include-path (list "/")
                      :system-include-path (list "/usr/include" 
                                                 (format "%slib/libc/include" dsa/develop)))
(ede-cpp-root-project "wpa_supplicant" 
                      :name "WPA supplicant"
                      :file (concat dsa/develop "extern/wpa_supplicant/wpa_supplicant.spec")
                      :include-path (list "/" "/includes")
                      :system-include-path (list "/usr/include")
                      :spp-table '(("CONFIG_DBUS" . ""))
                      )


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

(defun dsa/org-buffer ()
  (let ((buffer (get-buffer-create "*dsa build*")))
    (with-current-buffer buffer
      (setq read-only-mode t)
      (setq mode-name "DSA Build")
      (make-local-variable 'dsa/org-tramp)
      (make-local-variable 'dsa/org-original-buffer)
      (make-local-variable 'dsa/org-original-point)
      (make-local-variable 'dsa/org-official)
      (make-local-variable 'dsa/org-after-success)
      (setq dsa/org-after-success nil
            dsa/org-tramp nil)
      buffer)))

(defun dsa/org-coldstart ()
  (org-entry-get (point) "COLDSTART" t))

(defun dsa/org-develop ()
  (org-entry-get (point) "DEVELOP" t))

(defun dsa/org-cvs-tag ()
  (org-entry-get (point) "CVSTAG" t))

(defun dsa/org-build ()
  (org-entry-get (point) "BUILD" t))

(defun dsa/org-spec-file ()
  (save-excursion
    (org-mark-subtree)
    (goto-char (region-beginning))
    (re-search-forward "\\[\\[cvs:\\([^\]]+\.spec\\)\\]\\]" (region-end))
    (match-string 1)))

(defun dsa/org-component-path ()
  (file-name-directory (dsa/org-spec-file)))

(defun dsa/map-file (path)
  (replace-regexp-in-string "^/vmssk1:/home/dn/" "/home/dam/Build/" path))

(defun dsa/org-develop-path (path)
  (concat (dsa/org-develop) path))

(defun dsa/org-local-develop-path (path)
  (dsa/map-file (dsa/org-develop-path path)))

(defun dsa/org-visit-cvs-file (path)
  (let ((local-path (dsa/org-local-develop-path path)))
    (message local-path)
    (when (not (file-exists-p local-path))
      (cvs-checkout (list (file-name-directory path)) (dsa/org-develop)))
    (find-file-other-window local-path)))

(defun dsa/cvs-extract-rpms (buffer)
  (let ((rpms ()))
    (with-current-buffer buffer
      (end-of-buffer)
      (search-backward "+ ls -tl /home/dsa/packages" nil t)
      (forward-line)
      (while (re-search-forward " \\(/home/dsa/packages.*rpm\\)$" nil t)
        (push (match-string 1) rpms))
      (end-of-buffer)
      rpms)))

(defun dsa/org-build-handle-exit (process-status exit-status msg)
  "Write MSG in the current buffer and hack its `mode-line-process'."
  (let ((inhibit-read-only t)
	(status (cons msg exit-status))
	(omax (point-max))
	(opoint (point)))
    ;; Record where we put the message, so we can ignore it later on.
    (goto-char omax)
    (insert ?\n mode-name " " (car status))
    (if (and (numberp compilation-window-height)
	     (zerop compilation-window-height))
	(message "%s" (cdr status)))
    (if (bolp)
	(forward-char -1))
    (insert " at " (substring (current-time-string) 0 19))
    (goto-char (point-max))
    ;; Prevent that message from being recognized as a compilation error.
    (add-text-properties omax (point)
			 (append '(compilation-handle-exit t) nil))
    (setq mode-line-process
	  (let ((out-string (format ":%s [%s]" process-status (cdr status)))
		(msg (format "%s %s" mode-name
			     (replace-regexp-in-string "\n?$" ""
						       (car status)))))
	    (message "%s" msg)
	    (propertize out-string
			'help-echo msg 'face (if (> exit-status 0)
						 'compilation-error
					       'compilation-info))))
    ;; Force mode line redisplay soon.
    (force-mode-line-update)
    (if (and opoint (< opoint omax))
	(goto-char opoint))))

(defun dsa/org-build-sentinel (process event)
  (unwind-protect
      (with-current-buffer (process-buffer process)
        (if (and dsa/org-after-success (equal event "finished\n"))
            (funcall dsa/org-after-success process)))
    (if (memq (process-status process) '(exit signal))
        (let ((buffer (process-buffer process)))
          (if (null (buffer-name buffer))
              ;; buffer killed
              (set-process-buffer process nil)
            (with-current-buffer buffer
              ;; Write something in the compilation buffer
              ;; and hack its mode line.
              (dsa/org-build-handle-exit (process-status process)
                                         (process-exit-status process)
                                         event)
              ;; Since the buffer and mode line will show that the
              ;; process is dead, we can delete it now.  Otherwise it
              ;; will stay around until M-x list-processes.
              (delete-process process)
              (setq dsa/org-after-success nil)))))))

(defun dsa/org-build-process (name command &optional dir success)
  (let ((buffer (dsa/org-buffer))
        (default-directory dir))
    (with-current-buffer buffer
      (setq dsa/org-after-success success
            mode-line-process (list (propertize ":%s" 'face 'compilation-warning)))
      (setq mode-name (format "DSA Build: %s" name))
      (force-mode-line-update)
      (when (not dsa/org-tramp)
        (setq dsa/org-tramp (find-file-noselect dir)))
      (setq default-directory (or dir default-directory))
      (erase-buffer)
      (insert (format"Running %s in %s\n\n" command default-directory)))
    (set-window-buffer (next-window) buffer)
    (message "using handler %s" (find-file-name-handler dir 'start-file-process))
    (set-process-sentinel 
     (start-file-process-shell-command name buffer command)
     'dsa/org-build-sentinel)))

(defun dsa/org-cvs-build-success (process)
  (let ((buffer (process-buffer process)))
    (when (boundp 'dsa/org-original-buffer)
      (let ((original-point dsa/org-original-point)
            (official dsa/org-official))
        (with-current-buffer  dsa/org-original-buffer
          (save-excursion
            (message "point %s" original-point)
            (outline-end-of-subtree)
            (let ((rpms (dsa/cvs-extract-rpms buffer))
                  (end-of-subtree (point))
                  (matcher (if official "Official releases:\n\n" "Test releases:\n\n")))
              (goto-char original-point)              
              (if (not (re-search-forward matcher end-of-subtree t))
                  (insert matcher))
              (while (looking-at "\s+/home/dsa/packages/.*\.rpm")
                (kill-line 1))
              (dolist (rpm rpms)
                (org-indent-line-function)
                (insert (concat rpm "\n"))))))))))


(defun dsa/cvs-build (coldstart build spec &optional official success)
  (let ((command (format "/usr/local/bin/cvs2rpm -n %s --build %s %s" (if (not official) "--test-spec" "")
			 build spec)))
    (dsa/org-build-process "cvs2rpm" command coldstart success)))

(defun dsa/org-cvs-build (&optional official)
  (interactive "P")
  (save-excursion
    (let ((develop (dsa/org-develop))
	  (spec (dsa/org-spec-file))
          (build (dsa/org-build))
          (original-buffer (current-buffer))
          (original-point (point)))
      (with-current-buffer (dsa/org-buffer)
        (setq dsa/org-original-buffer original-buffer
              dsa/org-original-point original-point
              dsa/org-official official))
      (if (not (and spec build))
          (error "cannot find spec or build"))
      (message "building spec %s" spec)
      (dsa/cvs-build develop build spec official 'dsa/org-cvs-build-success))))

(defvar dsa/coldstart-directories-cache nil)

(defun dsa/coldstart-directories (&optional host)
  (setq dsa/coldstart-directories-cache
        (or dsa/coldstart-directories-cache
            (let ((command (format "ssh %s find /export/boot/ -mindepth 2 -maxdepth 2 -type d -printf \\\"%%p \\\""
                                   (or host "vmssk1"))))
              (split-string (shell-command-to-string command))))))

(defun dsa/org-rpm-install (path rpm)
  (interactive
   (let* ((path (or (dsa/org-coldstart)
                    (read-file-name "Coldstart path: ")))
          (rpm (save-excursion
                 (beginning-of-line-text)
                 (if (re-search-forward "\\(/home/dsa/packages/.*\.rpm\\)" nil t)
                     (match-string 1)))))
     (list path rpm)))
  (dsa/org-build-process "dsarpm" (format "sudo /opt/dsa/tools/bin/dsarpm . --force -Uv %s" rpm)
			 (dsa/org-coldstart)))

(defun dsa/org-rpm-files (rpm)
  (interactive 
   (list (save-excursion
           (beginning-of-line-text)
           (if (re-search-forward "\\(/home/dsa/packages/.*\.rpm\\)" nil t)
               (match-string 1)))))
  (dsa/org-build-process "rpm" (format "rpm -qpl %s" rpm) (dsa/org-develop)))

(defun dsa/org-compile ()
  (interactive)
  (save-excursion
    (beginning-of-line-text)
    
    (if (looking-at "/home/dsa/packages/.*\.rpm")
        (call-interactively 'dsa/org-rpm-install)
      (call-interactively 'dsa/org-cvs-build))))


(defun dsa/org-vc-dir ()
  (interactive)
   (vc-dir (file-name-directory (dsa/org-local-develop-path (dsa/org-spec-file)))))

(defun dsa/org-cvs-do-tag (flags)
  (interactive "MFlags: ")
  (let ((tag (dsa/org-cvs-tag))
        (path (dsa/org-component-path)))
    (dsa/org-build-process "cvs rtag" (format "cvs tag %s %s %s" flags tag path) (dsa/org-develop))))


