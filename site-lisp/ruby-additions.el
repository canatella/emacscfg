;;; ruby-additions.el -- -- Ruby Helpers

;;; Commentary:

;;

;;; Code:


(require 'string-inflection)
(require 'projectile-rails)
(require 'itail)

(defun rails-log (&optional test)
  "Display rails development log or test log if TEST is not nil."
  (interactive "P")
  (let* ((bname (format "*rails %s log*" (if test "test" "dev")))
         (log (format "%slog/%s.log" (projectile-rails-root) (if test "test" "development")))
         (name (format "*itail: %s*" log))
         (buffer (get-buffer bname)))
    (if buffer (switch-to-buffer-other-window buffer)
      (itail log)
      (with-current-buffer name
        (rename-buffer bname)
        (switch-to-buffer-other-window (current-buffer))))))

(defun rails-clear-log ()
  "Clear rails log buffer."
  (interactive)
  (when (get-buffer "*rails dev log*")
    (with-current-buffer "*rails dev log*"
      (itail-clear)))
  (when (get-buffer "*rails test log*")
    (with-current-buffer "*rails test log*"
      (itail-clear))))

(defun ruby-plugin-or-project-root (filename)
  "Return the plugin root or the project root of FILENAME."
  (or (projectile-locate-dominating-file filename "lib")
      (projectile-project-root)))

(defun ruby-file-name (filename &optional root)
  "Return FILENAME relative to ROOT / either the lib, app or test/* directory."
  (let ((root (or root (ruby-plugin-or-project-root filename))))
    (replace-regexp-in-string
     "^\\(lib\\|app\\|test/[^/]+\\)/" ""
     (file-relative-name filename root))))

(defun ruby-file-name-require (filename &optional root)
  "Return the parent of FILENAME as needed for require relative to ROOT."
  (let ((parent (file-name-directory (ruby-file-name filename root))))
    (when parent (directory-file-name parent))))

(defun ruby-module-name (filename &optional root)
  "Return the module name of FILENAME relative to ROOT."
  (let* ((name (file-name-sans-extension (ruby-file-name filename root)))
         (names (split-string name "/")))
    (mapconcat #'string-inflection-pascal-case-function names "::")))

(provide 'ruby-additions)
;;; ruby-additions.el ends here
