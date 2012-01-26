(defvar odl-mode-hook nil)

(defvar odl-mode-map
  (let ((odl-mode-map (make-keymap)))
    (define-key odl-mode-map "\C-j" 'newline-and-indent)
    odl-mode-map)
  "Keymap for ODL major mode")

(add-to-list 'auto-mode-alist '("\\.odl\\'" . odl-mode))
(add-to-list 'auto-mode-alist '("\\.map\\'" . odl-mode))

(defvar odl-keywords
  '("map" "set" "var" "read-only" "constraint" "default" "enum" "allow" "deny" "user" "group" "to" "read" "or" "write" "cached" "evented" "update" "persistent" "define" "out" "in" "add" "delete" "with" "using" "mandatory" "execute" "acl")
  "odl keywords")
(defvar odl-types
  '("uint32" "int32" "datamodel" "string" "bool" "object" "function" "parameter" "list" "uint16" "int16" "uint8" "int8")
  "odl types")
(defvar odl-constants
  '("true" "false")
  "odl constants")

(defvar odl-keywords-regexp (regexp-opt odl-keywords 'words))
(defvar odl-type-regexp (regexp-opt odl-types 'words))
(defvar odl-constant-regexp (regexp-opt odl-constants 'words))

(setq odl-font-lock-keywords
  `(
    (,odl-type-regexp . font-lock-type-face)
    (,odl-constant-regexp . font-lock-constant-face)
    (,odl-keywords-regexp . font-lock-keyword-face)
    ("\\<\\([a-zA-Z_]*\\) *("  1 font-lock-function-name-face)
    ("function *\\([a-zA-Z_]*\\)"  1 font-lock-function-name-face)
    ))

(defun odl-indent-line ()
  "Indent current line as ODL code"
  (interactive)

  ;; Set the point to beginning of line.
  (beginning-of-line)

  ;; The first indentation-related thing we do is to check to see if this is
  ;; the first line in the buffer, using the function bobp. If it is, we set
  ;; the indentation level to 0, using indent-line-to. indent-line-to indents
  ;; the current line to the given column. Please note that if this condition
  ;; is true, then the rest of the indentation code is not considered.
  (if (bobp)
      (indent-line-to 0)

  ;; Now we declare two variables. We will store the value of our intended
  ;; indentation level for this line in cur-indent. Then, when all of the
  ;; indentation options have been considered (rules 2-5), we will finally
  ;; make the indentation.
    (let ((not-indented t) (lines-back 0) cur-indent)

  ;; If we see that we are at the end of a block, we then set the indentation
  ;; level. We do this by going to the previous line (using the forward-line
  ;; function), and then use the current-indentation function to see how that
  ;; line is indented. Then we set cur-indent with the value of the previous
  ;; line's indentation, minus the odl-indent-width.
      (if (looking-at "^[^{\n]*}") ; Check for closing brace
	  (progn
            (message "close %i [%s] %s" lines-back (buffer-substring (line-beginning-position) (line-end-position)) (looking-at "^[^{\n]*}.*$"))
	    (save-excursion
	      (forward-line -1)
              (setq lines-back (+ lines-back 1))
	      (if (looking-at ".*{[^}\n]*$") ; If now looking at opening block
                  (setq cur-indent (current-indentation)) ;; duplicate indent
		(setq cur-indent (- (current-indentation) odl-indent-width)))
              )

  ;; Safety check to make sure we don't indent negative.
	    (if (< cur-indent 0)
		(setq cur-indent 0)))

        (save-excursion
	    (while not-indented
	      (forward-line -1)
              (setq lines-back (+ lines-back 1))
	      (if (looking-at "^[^{\n]*}") ; Closing block
		  (progn
                    (message "prev close")
		    (setq cur-indent (current-indentation))
		    (setq not-indented nil))

		(if (looking-at ".*{[^}\n]*$") ; Opening block
		    (progn
                      (message "prev open")
		      (setq cur-indent (+ (current-indentation) odl-indent-width))
		      (setq not-indented nil))

		  (if (bobp)
		      (setq not-indented nil)))))))

  ;; Finally, we execute the actual indentation, if we have actually
  ;; identified an indentation case. We have (most likely) already stored the
  ;; value of the indentation in cur-value. If cur-indent is empty, then we
  ;; always indent to column 0.

      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0)))))


(defvar odl-mode-syntax-table
  (let ((odl-mode-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" odl-mode-syntax-table)
    (modify-syntax-entry ?- "w" odl-mode-syntax-table)
    (modify-syntax-entry ?/ ". 124b" odl-mode-syntax-table)
    (modify-syntax-entry ?* ". 23" odl-mode-syntax-table)
    (modify-syntax-entry ?\n "> b" odl-mode-syntax-table)

    odl-mode-syntax-table)
  "Syntax table for odl-mode")

(defun odl-mode ()
  "Major mode for editing Object Definition Language files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table odl-mode-syntax-table)
  (use-local-map odl-mode-map)

  (set (make-local-variable 'font-lock-defaults) '(odl-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'odl-indent-line)
  (make-local-variable 'odl-indent-width)
  (setq odl-indent-width 2)

  (setq major-mode 'odl-mode)
  (setq mode-name "ODL")
  (run-hooks 'odl-mode-hook))
(provide 'odl-mode)
