;;; toxi-theme.el --- REQUIRES EMACS 24

;; Copyright (C) 2013 Karsten Schmidt.
;;
;; Author: Karsten Schmidt <info@postspectacular.com>
;; Version: 0.1.0
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, version 3 of the License.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.

(unless (>= 24 emacs-major-version)
  (error "toxi-theme requires Emacs 24 or later."))

(deftheme toxi
  "toxi's color theme")

(let ((tgcol-blue-light "#89BDFF")
      (tgcol-gray "#595959")
      (tgcol-gray-darker "#383830")
      (tgcol-gray-darkest "#141411")
      (tgcol-gray-lightest "#595959")
      (tgcol-gray-light "#E6E6E6")
      (tgcol-green "#A6E22A")
      (tgcol-green-light "#A6E22E")
      (tgcol-grey-dark )
      (tgcol-magenta "#F92672")
      (tgcol-purple "#AE81FF")
      (tgcol-purple-light "#FD5FF1")
      (tgcol-yellow "#E6DB74")
      (tgcol-yellow-dark "#75715E")
      (tgcol-yellow-light "#F8F8F2"))
  (custom-theme-set-faces
   'toxi
   ;; Frame
   `(default ((t (:foreground "#a4ffd8" :background "#0b1210"))))
   `(cursor ((t (:foreground "white"))))
   `(hl-line ((t (:background "#272822"))))
   `(minibuffer-prompt ((t (:foreground "#14bccc" :bold t))))
   `(modeline ((t (:background "#465253" :foreground "#ffffff"))))
   `(modeline-inactive ((t (:background "#162223" :foreground "#355e6b"))))
   `(region ((t (:background "#441ea4"))))
   `(show-paren-match-face ((t (:background "#ffff00"))))
   ;; Main
   `(font-lock-builtin-face ((t (:foreground "#00ffff"))))
   `(font-lock-comment-face ((t (:foreground "#7d7d7d"))))
   `(font-lock-constant-face ((t (:foreground "#f2ee81"))))
   `(font-lock-doc-string-face ((t (:foreground "#40be67"))))
   `(font-lock-function-name-face ((t (:foreground "#ffff00"))))
   `(font-lock-keyword-face ((t (:foreground "#f90432"))))
   `(font-lock-string-face ((t (:foreground "#50de77"))))
   `(font-lock-type-face ((t (:foreground "#ff14bf"))))
   `(font-lock-variable-name-face ((t (:foreground "#ffee33"))))
   `(font-lock-warning-face ((t (:bold t :foreground "#ff0055"))))
   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face ((t (:foreground "#990000"))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground "#383838"))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground "#505050"))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground "#6c6c6c"))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground "#888888"))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground "#a7a7a7"))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground "#c4c4c4"))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground "#e1e1e1"))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground "#ffffff"))))
   ;; CUA
   `(cua-rectangle ((t (:background ,tgcol-gray-darkest))))
   ;; IDO
   `(ido-first-match ((t (:foreground "#ffff00"))))
   `(ido-only-match ((t (:foreground "#00ff00"))))
   `(ido-subdir ((t (:foreground "#00ffff"))))
   ;; Whitespace
   `(whitespace-space ((t (:foreground ,tgcol-gray))))
   ;; Yasnippet
   `(yas/field-highlight-face ((t (:background ,tgcol-gray-darker))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'toxi)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; toxi-theme.el ends here
