;;; veygo.el -- Veygo integration package

;;; Commentary:

;;  Provide Veygo build system integration.

;;; Code:

(require 'vip-build)
(require 'android)

(defun vip-ndk-addr2line-find-binary (path list)
  "Find binary PATH in LIST or in current workspace."
  (let* ((workspace (vip-toplevel))
         (list (if workspace (cons (format "%sbuild/debug/android-armeabi-v7a/lib" workspace)
                                   list)
                 list)))
    (android-ndk-addr2line-find-binary-default path list)))

(defun vip-logcat ()
  "Run logcat."
  (interactive)
  (android-logcat (append  '("veygo" "veygo.player") android-default-tags)))

(defvar veygo-stream-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "< b" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table used in `veygo-stream-mode'.")

(let ((veygo-stream-keywords '("name" "scheme" "type" "drm-company" "drm-server"))
      (veygo-stream-types '()))
  (let ((veygo-stream-keywords-regexp (regexp-opt veygo-stream-keywords 'words))
        (veygo-stream-types-regexp (regexp-opt veygo-stream-types 'words)))
    (defvar veygo-stream-font-lock-keywords
      `(
        ("\\(http.?://.+\\)" 1 font-lock-function-name-face)
        (,veygo-stream-types-regexp . font-lock-type-face)
        (,veygo-stream-keywords-regexp . font-lock-keyword-face)))))

(defun veygo-stream-indent-line ()
  "Indent current line as veygo-stream code."
  (interactive)
  (indent-line-to 0))

(defun veygo-stream-install-to-device ()
  "Install the current veygo-stream file to the device."
  (interactive)
  (shell-command (format "adb push %s /mnt/sdcard/veygo-stream.txt"
                         (buffer-file-name))))

;;;###autoload
(define-derived-mode veygo-stream-mode fundamental-mode "veygo-stream"
  "major mode for editing veygo-stream idl language code."
  (setq font-lock-defaults '(veygo-stream-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'veygo-stream-indent-line)
  (set-syntax-table veygo-stream-mode-syntax-table)
  (local-set-key [f10] #'veygo-stream-install-to-device))

(setq auto-mode-alist
      (cons '("veygo-stream\\.txt\\'" . veygo-stream-mode) auto-mode-alist))


(defun nxml-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end)))

(defun nxml-pretty-print-xml-buffer ()
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive)
  (save-excursion
    (nxml-pretty-print-xml-region (point-min) (point-max))))

(provide 'veygo)

;;; veygo.el ends here
