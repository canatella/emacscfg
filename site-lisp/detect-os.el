;;; detect-os.el -- Tools to detect current os.

;;; Commentary:

;;

;;; Code:

;;;###autoload
(defmacro when-macos (&rest body)
  "When running on MacOS, evaluate BODY like `nprog'."
  (declare (indent 0) (debug t))
  `(when (string-equal system-type "darwin")
     ,@body))

(provide 'detect-os)

;;; detect-os.el ends here
