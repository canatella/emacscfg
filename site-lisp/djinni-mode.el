;;; djinni-mode.el -- Editing djinni idl files.

;; Author: Damien Merenne
;; URL: https://github.com/canatella/djinni-mode-el
;; Created: 2014-02-11
;; Keywords: convenience
;; Package-Requires: ((emacs "24.1"))

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; This package provides syntax highlighting for djinni idl files.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(defvar djinni-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "< b" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table used in `djinni-mode'.")

(let ((djinni-keywords '("enum" "record" "interface" "static"))
      (djinni-types '("bool" "i8" "i16" "i32" "i64" "f32" "f64"
                      "string" "binary" "date" "list" "set" "map"
                      "optional")))
  (let ((djinni-keywords-regexp (regexp-opt djinni-keywords 'words))
        (djinni-types-regexp (regexp-opt djinni-types 'words)))
    (defvar djinni-font-lock-keywords
      `(
        ("\\+[cjo]" . font-lock-keyword-face)
        ("\\([a-zA-Z0-9_]+\\)(" 1 font-lock-function-name-face)
        (":\\s-*\\([a-zA-Z0-9_]+\\)" 1 font-lock-type-face)
        ("\\([a-zA-Z0-9_]+\\)\\s-*=" 1 font-lock-type-face)
        ("<\\s-*\\([a-zA-Z0-9_]+\\)\\s-*>" 1 font-lock-type-face)
        ("\\([a-zA-Z0-9_]+\\)\\s-*:" 1 font-lock-variable-name-face)
        (,djinni-types-regexp . font-lock-type-face)
        (,djinni-keywords-regexp . font-lock-keyword-face)))))

(defcustom djinni-indent-level 4
  "The default indentation level for djinni idl files."
  :type '(integer)
  :group 'djinni)

(defvar djinni-start-definition-regexp
  "\\s-*[a-zA-Z0-9_]+\\s-*=\\s-*\\(enum\\|record\\|interface\\)\\(\\s-+\\+[cjo]\\)*\\s-*{"
  "Match the beginning of a djinni type definition.")

(defvar djinni-end-definition-regexp
  "^\\s-*\\}"
  "Match the end of a djinni type definition.")

(defun djinni-calculate-next-indent-level ()
  "Calculate the indent level for the next line."
  (cond
   ((bobp) 0)
   ((looking-at "^\\s-*\\(#.*\\)?$") (progn (forward-line -1)
                                            (djinni-calculate-next-indent-level)))
   ((looking-at djinni-start-definition-regexp) djinni-indent-level)
   ((looking-at djinni-end-definition-regexp) 0)
   ('t djinni-indent-level)))

(defun djinni-calculate-indent-level ()
  "Calculate the indent level for the current line."
  (cond
   ((bobp) 0)
   ((looking-at "^\\s-*\\(#.*\\)?$") (djinni-calculate-next-indent-level))
   ((looking-at djinni-start-definition-regexp) 0)
   ((looking-at djinni-end-definition-regexp) 0)
   ('t djinni-indent-level)))

(defun djinni-indent-line ()
  "Indent current line as djinni idl code."
  (interactive)
  (indent-line-to
   (save-excursion
     (beginning-of-line)
     (djinni-calculate-indent-level))))

;;;###autoload
(define-derived-mode djinni-mode fundamental-mode "djinni"
  "major mode for editing djinni idl language code."
  (setq font-lock-defaults '(djinni-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'djinni-indent-line)
  (set-syntax-table djinni-mode-syntax-table))

(setq auto-mode-alist
      (cons '("\\.djinni\\'" . djinni-mode) auto-mode-alist))


(provide 'djinni-mode)
;;; djinni-mode.el ends here
