;; hyperplane.el
;;
;; Copyright 2010 John Olsson (john@cryon.se)

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;; ---------
;; Changelog
;; ---------
;; 2010-11-16
;;  * added calender faces
;; 2010-11-12
;;  * added ansi-colors for term
;;  * added palette
;;  * cleaned up
;; 2010-11-10
;;  * initial version


;; the colors!


;; the elements




(deftheme hyperplane "Hyperplane translated")

(setq hp-background+4 "#464F56")
(setq hp-background+3 "#434B52")
(setq hp-background+2 "#40474E")
(setq hp-background+1 "#3D434A")
(setq hp-background   "#3a3f46")
(setq hp-background-1 "#373b42")
(setq hp-background-2 "#32363c")
(setq hp-background-3 "#2F3238")
(setq hp-background-4 "#2C2E34")

(setq hp-red           "#cc3030")
(setq hp-dark-orange   "#cc6e51")
(setq hp-beige         "#bba47c")
(setq hp-orange        "#ccad42")
(setq hp-yellow        "#c4d249")
(setq hp-green         "#7bbf11")
(setq hp-dark-green    "#3ab145")
(setq hp-cyan          "#6ccccb")
(setq hp-blue          "#4e9ecc")
(setq hp-baby-blue     "#80a0cc")
(setq hp-gray          "#8f90a4")
(setq hp-dark-gray     "#767790")
(setq hp-purple        "#9072b3")
(setq hp-cerise        "#b33fb2")
(setq hp-light-gray    "#b7c3cd")
(setq hp-white         "#dedee0")

(setq hp-total-red     "#ff0000")
(setq hp-total-green   "#00ff00")
(setq hp-total-blue    "#0000ff")
(setq hp-total-purple  "#a020f0")
(setq hp-total-cyan    "#00ffff")
(setq hp-total-yellow  "#ffff00")
(setq hp-total-white   "#ffffff")
(setq hp-total-black   "#000000")


;;               "#292A30"
;;               "#26262C"
;;               "#232228"
(setq hp-foreground    hp-light-gray)
(setq hp-comment       hp-dark-orange)
(setq hp-comment       hp-dark-orange)
(setq hp-identifier    hp-baby-blue)
(setq hp-string        hp-green)
(setq hp-preprocessor  hp-dark-orange)
(setq hp-builtin       hp-orange)
(setq hp-constant      hp-white)
(setq hp-doc           hp-comment) ; for the ladies!


(custom-theme-set-faces
 'hyperplane

 ;; (defface region
 ;;     `((((type tty) (class color))
 ;;        (:background "blue" :foreground "white"))
 ;;       (((type tty) (class mono))
 ;;        (:inverse-video t))
 ;;       (((class color) (background dark))
 ;;        (:background "blue"))
 ;;       (((class color) (background light))
 ;;        (:background "lightblue"))
 ;;       (t (:background "gray")))
 ;;   "Basic face for highlighting the region."
 ;;   :group 'basic-faces)

 ;; `(default ((((type tty) (class color))
 ;;             nil)
 ;;            (((class color) (min-colors 89))
 ;;             (:background
 ;;              ,hp-background
 ;;              :foreground ,hp-foreground))
 ;;            ;; (t (:foreground "white"))
 ;;            ))

 `(default ((((type tty) (class color))
             (:background
              "unspecified-bg"
              :foreground "white"))
            (((type tty) (class mono))
             (:inverse-video t))
            (t
             (:background
              ,hp-background
              :foreground ,hp-foreground))
            ;; (t (:foreground "white"))
            ))

 `(cursor ((t (:background
               ,hp-white))))

 `(stripe-highlight ((t (:background ,hp-background+2)))
   "Face for highlighting current overlay."
   :group 'basic-faces)

 `(fringe
   ((t (:background
        ,hp-background
        :foreground ,hp-comment))))

 `(linum
   ((t (:background
        ,hp-background
        :foreground
        ,hp-background+4
        :weight normal
        :italic nil
        :underline nil
        :overline nil))))

 `(region
   ((t (:background ,hp-dark-gray :foreground ,hp-background-4))))

 `(highlight
   ((t (:foreground ,hp-white))))
 ;; (margin
 ;;  ((t (:foreground ,hp-white))))

 `(mode-line
   ((t (:background
        ,hp-background-2
        :foreground
        ,hp-foreground))))

 `(mode-line-inactive
   ((t (:background
        ,hp-background-2
        :foreground
        ,hp-foreground))))

 `(info-menu-header ((t (:family "Georgia" :foreground ,hp-orange :weight bold))))

 `(header-line
   ((t (:background
        ,hp-background+4
        :foreground ,hp-dark-gray
        ;; :family "DejaVu Sans"
        ;; :box (:line-width
        ;;       1
        ;;       :color
        ;;       ,hp-background-4)
        ))))

 `(header-line-inactive ((t (:background ,hp-background :foreground ,hp-background+4))))

 ;; `(modeline-inactive
 ;;   ((t (:background ,hp-background-1 :foreground ,hp-dark-gray))))

 ;; `(modeline
 ;;   ((t (:background ,hp-background-4 :foreground ,hp-dark-gray))))

 `(mode-line-buffer-id ((t (:foreground ,hp-orange :weight bold))))
 ;; Tabbar
 `(default
   ((t (:foreground ,hp-foreground :background ,hp-background))))

 `(tabbar-button
   ((t (:inherit tabbar-default))))

 `(tabbar-default
   ((t (:background ,hp-background :foreground ,hp-dark-gray))))

 ;; (tabbar-highlight
 ;;  ((t (:underline nil))))

 `(tabbar-selected
   ((t (:inherit tabbar-default :foreground ,hp-orange :weight bold))))

 `(tabbar-unselected
   ((t (:inherit tabbar-default))))

 `(minibuffer-prompt
   ((t (:bold t :foreground ,hp-white))))

 `(show-paren-match
   ((t (:foreground ,hp-total-green :bold t))))

 `(show-paren-mismatch-face
   ((t (:foreground ,hp-total-red :bold t))))

 `(isearch
   ((t (:foreground ,hp-total-green :bold t))))

 `(link
   ((t (:foreground ,hp-blue :underline t))))

 ;; ---------
 ;; font-lock
 ;; ---------
 `(font-lock-comment-face
   ((t (:foreground ,hp-comment :italic t))))

 `(font-lock-string-face
   ((t (:foreground ,hp-string ;; :background ,hp-background-2
                    ;; :underline t
                    ))))

 `(font-lock-variable-name-face
   ((t (:foreground ,hp-identifier))))

 `(font-lock-type-face
   ((t (:foreground ,hp-foreground :bold t))))

 `(font-lock-keyword-face
   ((t (:foreground ,hp-identifier))))

 `(font-lock-function-name-face
   ((t (:foreground ,hp-orange :bold t))))

 `(font-lock-preprocessor-face
   ((t (:foreground ,hp-preprocessor))))

 `(font-lock-constant-face
   ((t (:foreground ,hp-constant))))

 `(font-lock-builtin-face
   ((t (:foreground ,hp-builtin))))

 `(font-lock-warning-face
   ((t (:foreground ,hp-red :bold t))))

 `(font-lock-doc-face
   ((t (:foreground ,hp-doc))))

 `(font-lock-negation-char-face
   ((t (:foreground ,hp-orange :bold t))))

 `(font-lock-comment-delimiter-face
   ((t (:inherit font-lock-comment-face))))

 ;; FIX: have not tested this yet
 `(font-lock-reference-face
   ((t (:bold t :foreground ,hp-total-yellow))))

 ;; (light-symbol-face
 ;;  ((t (:foreground ,hp-total-green))))

 `(light-symbol-face
   ((t (:foreground ,hp-red))))

 `(comint-highlight-prompt
   ((t (:foreground ,hp-orange :bold t))))

 `(flyspell-duplicate ((t (:foreground ,hp-red :underline t))))
 `(flyspell-incorrect ((t (:foreground ,hp-orange :underline t))))
 `(error ((t (:inherit font-lock-warning-face))))
 `(flymake-errline ((t (:underline (:color "red" :style wave)))))
 `(flymake-warnline ((t (:underline (:color "orange" :style wave)))))
 ;; ----------
 ;; Dired Plus
 ;; ----------

 `(diredp-dir-heading
   ((t (:inherit font-lock-function-name-face))))
 `(diredp-dir-priv
   ((t (:inherit font-lock-function-name-face))))
 `(diredp-display-msg
   ((t (:inherit font-lock-string-face))))
 `(diredp-file-suffix
   ((t (:inherit font-lock-variable-name-face))))
 ;; (diredp-ignored-file-name
 ;;  ((t (:foreground "#bebebe"))))
 ;; `(diredp-flag-mark-line ((t (:inherit default))))
 `(diredp-exec-priv ((t (:inherit default))))
 `(diredp-file-name ((t (:inherit default))))
 `(diredp-inode+size ((t (:inherit default))))
 `(diredp-no-priv ((t (:inherit default))))
 `(diredp-read-priv ((t (:inherit default))))
 `(diredp-write-priv ((t (:inherit default))))

 ;; ------
 ;; eshell
 ;; ------

 `(eshell-ls-clutter
   ((t (:inherit font-lock-comment-face))))

 `(eshell-ls-executable
   ((t (:foreground ,hp-string))))

 `(eshell-ls-directory
   ((t (:foreground ,hp-baby-blue :bold t))))

 `(eshell-ls-archive
   ((t (:foreground ,hp-purple))))

 `(eshell-ls-backup
   ((t (:inherit font-lock-comment-face))))

 `(eshell-ls-missing
   ((t (:inherit font-lock-warning-face))))

 `(eshell-ls-unreadable
   ((t (:inherit font-lock-warning-face))))

 `(eshell-ls-symlink
   ((t (:inherit font-lock-builtin-face))))

 `(eshell-prompt
   ((t (:foreground ,hp-light-gray :bold t))))

 ;; IDO
 `(ido-first-match ((t (:foreground ,hp-orange :bold t))))
 `(ido-only-match ((t (:foreground ,hp-green :bold t))))
 `(ido-subdir ((t (:foreground ,hp-baby-blue))))
 `(ido-indicator ((t (:foreground ,hp-purple))))

 `(org-hide ((t (:foreground ,hp-background))))
 `(org-column ((t (:background ,hp-background+2))))

 `(org-level-1 ((t (:foreground ,hp-orange :bold t))))
 ;; `(org-level-1 ((t (:foreground ,hp-dark-orange))))
 `(org-level-2 ((t (:foreground ,hp-green :bold t))))
 `(org-level-3 ((t (:foreground ,hp-dark-orange :bold t))))
 `(org-level-4 ((t (:foreground ,hp-blue :bold t))))
 `(org-level-5 ((t (:foreground ,hp-orange :bold t))))
 `(org-level-6 ((t (:foreground ,hp-green :bold t))))
 `(org-level-7 ((t (:foreground ,hp-dark-orange :bold t))))
 `(org-level-8 ((t (:foreground ,hp-blue :bold t))))

 ;; ---
 ;; erc
 ;; ---
 ;; (erc-default-face
 ;;  ((t (:foreground ,hp-foreground))))

 ;; (erc-current-nick-face
 ;;  ((t (:inherit erc-keyword-face))))

 ;; (erc-action-face
 ;;  ((t (:inherit erc-default-face))))

 ;; (erc-dangerous-host-face
 ;;  ((t (:inherit font-lock-warning-face))))

 ;; (erc-highlight-face
 ;;  ((t (:foreground ,hp-orange))))

 ;; (erc-direct-msg-face
 ;;  ((t (:foreground ,hp-foreground))))

 ;; (erc-nick-msg-face
 ;;  ((t (:foreground ,hp-white))))

 ;; (erc-fool-face
 ;;  ((t (:forground ,hp-dark-gray))))

 ;; (erc-input-face
 ;;  ((t (:foreground ,hp-white))))

 ;; (erc-error-face
 ;;  ((t (:inherit font-lock-warning-face))))

 ;; (erc-keyword-face
 ;;  ((t (:background ,hp-background-2))))

 ;; (erc-nick-default-face
 ;;  ((t (:foreground ,hp-white))))

 ;; (erc-prompt-face
 ;;  ((t (:inherit eshell-prompt))))

 ;; (erc-notice-face
 ;;  ((t (:foreground ,hp-dark-gray))))

 ;; (erc-timestamp-face
 ;;  ((t (:foreground ,hp-dark-gray))))

 ;; (erc-pal-face
 ;;  ((t (:foreground ,hp-green))))

 ;; ;; FIX: doesn't seem to work...
 ;; (erc-header-line
 ;;  ((t (:background ,hp-background-2 :foreground ,hp-purple))))

 ;; --------
 ;; calendar
 ;; --------
 `(calendar-today
   ((t (:foreground ,hp-green :bold t))))

 `(holiday
   ((t (:foreground ,hp-orange))))

 `(diary
   ((t (:foreground ,hp-purple))))

 ;; ---
 ;; nav
 ;; ---
 `(nav-face-heading
   ((t (:foreground ,hp-green))))

 `(nav-face-dir
   ((t (:inherit eshell-ls-directory))))

 `(nav-face-hdir
   ((t (:inherit nav-face-dir))))

 `(nav-face-button-num
   ((t (:inherit eshell-prompt))))

 `(nav-face-file
   ((t (:foreground ,hp-foreground))))

 ;; FIX: have not tested this yet
 `(nav-face-hfile
   ((t (:foreground ,hp-orange))))
 ;; If you want the colors to be solid, also set the :background to the same
 ;; color
 `(term-color-black
   ((t (:foreground ,hp-dark-gray))))
 `(term-color-red
   ((t (:foreground ,hp-red))))
 `(term-color-green
   ((t (:foreground ,hp-green))))
 `(term-color-yellow
   ((t (:foreground ,hp-orange))))
 `(term-color-blue
   ((t (:foreground ,hp-baby-blue))))
 `(term-color-magenta
   ((t (:foreground ,hp-purple))))
 `(term-color-cyan
   ((t (:foreground ,hp-purple))))
 `(term-color-white
   ((t (:foreground ,hp-white))))
 ;; Dumped from custom.el
 '(dired-async-in-process-face
   ((t (:background "tomato"))))
 '(diredp-flag-mark
   ((t (:foreground "Orange" :weight bold))))
 '(diredp-flag-mark-line
   ((t (:weight bold))))
 '(emms-browser-album-face
   ((t (:inherit font-lock-function-name-face :slant italic :weight bold :height 1.2 :family "Georgia"))))
 '(emms-browser-artist-face
   ((t (:inherit org-level-1 :foreground "#cc6e51" :family "DejaVu Sans"))))
 '(emms-browser-track-face
   ((t (:inherit default :family "DejaVu Sans"))))
 '(emms-browser-year/genre-face
   ((t (:foreground "#3ab145" :weight bold :family "DejaVu Sans"))))
 '(emms-playlist-selected-face
   ((t (:inherit font-lock-function-name-face :weight normal :family "DejaVu Sans"))))
 '(emms-playlist-track-face
   ((t (:family "DejaVu Sans"))))
 '(hl-line
   ((t (:background "#767790" :foreground "#3a3f46"))))
 '(magit-item-highlight
   ((t (:foreground "white"))))
 '(mu4e-header-highlight-face
   ((t (:inherit hl-line))))
 '(newsticker-treeview-face
   ((t nil)))
 '(newsticker-treeview-new-face
   ((t (:inherit newsticker-treeview-face :foreground "skyblue" :weight bold))))
 '(newsticker-treeview-old-face
   ((t (:inherit default))))
 '(newsticker-treeview-selection-face
   ((t (:background "navy"))))
 '(org-date
   ((t (:foreground "Cyan" :weight bold))))
 '(speedbar-file-face
   ((t nil)))
 '(speedbar-selected-face
   ((t (:inherit font-lock-function-name-face))))
 '(table-cell
   ((t (:foreground "thistle"))))
 '(variable-pitch
   ((t (:family "Georgia"))))
 `(git-gutter-fr:added
   ((t (:foreground ,hp-green))))
 `(git-gutter-fr:modified
   ((t (:foreground ,hp-purple))))
 `(git-gutter-fr:deleted
   ((t (:foreground ,hp-red)))))

(provide 'hyperplane-theme)

;; Local Variables:
;; lisp-backquote-indentation: nil
;; End:
