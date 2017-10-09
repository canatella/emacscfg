;;; hls-smptett.el -- Apple HLS streaming format helpers

;;; Commentary:

;;

;;; Code:

(require 'dom)
(require 'dash)
(require 's)

(defun hls-smptett-xml (buffer)
  "Parse current BUFFER as xml."
  (save-excursion
    (with-current-buffer buffer
      (libxml-parse-xml-region (point-min) (point-max)))))

(defun hls-smptett-show-images (xml)
  "Display embedded smptett encoded images in XML."
  (interactive "b")
  (save-excursion
    (goto-char (point-min))
    (-each (dom-by-tag xml 'image)
      (lambda (image-tag)
        (let* ((txt (dom-text image-tag))
               (img (create-image (base64-decode-string txt) 'png t)))
          (search-forward txt)
          (replace-match "\n")
          (insert-image img (s-trim txt))
          (insert "\n"))))))

(defun hls-smptett-parse-time (time-string)
  "Parse the smptett TIME-STRING."
  (when (string-match "\\([0-9]+\\):\\([0-9]+\\):\\([0-9]+\.[0-9]+\\)" time-string)
    (+ (* (string-to-number (match-string 1 time-string)) 3600)
       (* (string-to-number (match-string 2 time-string)) 60)
       (string-to-number (match-string 3 time-string)))))

(defun hls-smptett-add-timestamp-tooltip (div-tag attr)
  "Add a tooltip with the unix timestamp in DIV-TAG over attribute ATTR."
  (let* ((txt (dom-attr div-tag attr))
         (timestamp (hls-smptett-parse-time txt)))
    (when (search-forward txt)
      (put-text-property (match-beginning 0) (match-end 0)
                         'display (format "%s (%.3f)" txt timestamp)))))

(defun hls-smptett-show-timestamps (xml)
  "Add tooltip for each timestamp in XML."
  (save-excursion
    (goto-char (point-min))
    (-each (dom-by-tag xml 'div)
      (lambda (div-tag)
        (hls-smptett-add-timestamp-tooltip div-tag 'begin)
        (hls-smptett-add-timestamp-tooltip div-tag 'end)))))

(defun hls-smptett-pretty-print (buffer)
  "Pretty print smptett xml in BUFFER."
  (interactive "b")
  (save-excursion
    (nxml-mode)
    (goto-char (point-min))
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region (point-min) (point-max))))

(define-derived-mode hls-smptett-mode nxml-mode "smptett"
  "Major mode for editing smptett files."
  (let ((xml (hls-smptett-xml (current-buffer))))
    (hls-smptett-show-images xml)
    (hls-smptett-show-timestamps xml)
    (hls-smptett-pretty-print (current-buffer))
    (set-buffer-modified-p nil)
    (read-only-mode t)))

(setq auto-mode-alist
      (cons '("\\.smptett\\'" . hls-smptett-mode) auto-mode-alist))

(provide 'hls-smptett)
;;; hls-smptett.el ends here
