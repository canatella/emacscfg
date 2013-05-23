;;; dotshare-theme.el --- A color theme for Emacs 24.

;; Based on color-theme-dotshare.el:
;; Author: Christian Brassat <crshd@mail.com>
;; URL: http://dotshare.it/dots/191/

;; Ported to GNU Emacs 24's built-in theme system by Nicolas G. Querol <nicolas.gquerol@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Installation:
;;
;; Drop the theme in a folder that is in `custom-theme-load-path', do a
;; simple 'M-x load-theme dotshare' and enjoy!
;;
;; Don't forget that the theme requires Emacs 24.
;;

;;; Code

(deftheme dotshare
  "A colourful, dark and terminal-friendly theme")

(let ((class '((class color) (min-colors 89)))
      ;; color definitions
      ;; colors with +x are lighter, colors with -x are darker
      (dotshare-fg		"#d7d0c7")
      (dotshare-bg-1		"#101010")
      (dotshare-bg		"#151515")
      (dotshare-bg+1		"#202020")
      (dotshare-bg+2		"#5f5f5f")
      (dotshare-red+1		"#f55353")
      (dotshare-red		"#e84f4f")
      (dotshare-red-1		"#ce4646")
      (dotshare-red-2		"#a83939")
      (dotshare-red-3		"#682424")
      (dotshare-orange		"#dfaf8f")
      (dotshare-yellow		"#e1aa5d")
      (dotshare-yellow-1	"#c79752")
      (dotshare-yellow-2	"#a17a43")
      (dotshare-green-1		"#a2bc7b")
      (dotshare-green		"#b8d68c")
      (dotshare-green+1		"#c3e394")
      (dotshare-green+2		"#9fc59f")
      (dotshare-green+3		"#ceef9d")
      (dotshare-green+4		"#d9fca5")
      (dotshare-cyan		"#6d878d")
      (dotshare-blue+1		"#85cddc")
      (dotshare-blue		"#7dc1cf")
      (dotshare-blue-1		"#6ea9b5")
      (dotshare-blue-2		"#57868f")
      (dotshare-blue-3		"#38565c")
      (dotshare-blue-4		"#304a4f")
      (dotshare-blue-5		"#213236")
      (dotshare-magenta		"#9b64fb"))

  (custom-theme-set-faces
   'dotshare

   ;;; basic coloring
   `(cursor ((,class (:foreground ,dotshare-fg))))
   `(default ((,class (:foreground ,dotshare-fg :background ,dotshare-bg))))
   `(fringe ((,class (:foreground ,dotshare-bg+2 :background ,dotshare-bg))))
   `(escape-glyph-face ((,class (:foreground ,dotshare-red))))
   `(header-line ((,class (:foreground ,dotshare-yellow
				       :background ,dotshare-bg-1
				       :box (:line-width 1 :color ,dotshare-bg-1)))))
   `(hl-line ((,class (:background ,dotshare-bg+1))))
   `(linum ((,class (:foreground ,dotshare-bg+2 :background ,dotshare-bg-1))))
   `(minibuffer-prompt ((,class (:foreground ,dotshare-yellow))))
   `(menu ((,class (:foreground ,dotshare-fg :background ,dotshare-bg))))
   `(mode-line ((,class (:foreground ,dotshare-fg :background ,dotshare-bg+1
				     :box (:line-width 1 :color ,dotshare-bg+2)))))
   `(mode-line-inactive ((,class (:foreground ,dotshare-bg+1 :background ,dotshare-bg+2
					      :box (:line-width 1 :color ,dotshare-bg+2)))))
   `(mode-line-buffer-id ((,class (:inherit 'dotshare-yellow :weight bold))))
   `(mode-line-buffer-name ((,class (:foreground ,dotshare-green :weight bold))))
   `(mode-line-mode-face ((,class (:foreground ,dotshare-yellow))))
   `(mode-line-folder-face ((,class (:foreground ,dotshare-bg+2))))
   `(mode-line-modified-face ((,class (:foreground ,dotshare-orange))))
   `(mode-line-read-only-face ((,class (:foreground ,dotshare-red))))
   `(region ((,class (:background ,dotshare-bg+2))))
   `(secondary-selection ((,class (:background ,dotshare-bg+2))))
   `(trailing-whitespace ((,class (:background ,dotshare-red))))
   `(vertical-border ((,class (:foreground ,dotshare-fg))))

   ;; faces used by isearch
   `(isearch ((,class (:foreground ,dotshare-yellow :background ,dotshare-bg-1))))
   `(isearch-fail ((,class (:foreground ,dotshare-fg :background ,dotshare-red-3))))
   `(lazy-highlight ((,class (:foreground ,dotshare-yellow :background ,dotshare-bg+2))))

   ;; font-lock
   `(font-lock-builtin-face ((,class (:foreground ,dotshare-blue))))
   `(font-lock-comment-face ((,class (:foreground ,dotshare-green))))
   `(font-lock-comment-delimiter-face ((,class (:foreground ,dotshare-green))))
   `(font-lock-constant-face ((,class (:foreground ,dotshare-fg))))
   `(font-lock-doc-face ((,class (:foreground ,dotshare-green+1))))
   `(font-lock-doc-string-face ((,class (:foreground ,dotshare-blue+1))))
   `(font-lock-function-name-face ((,class (:foreground ,dotshare-blue))))
   `(font-lock-keyword-face ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(font-lock-negation-char-face ((,class (:foregorund ,dotshare-fg))))
   `(font-lock-preprocessor-face ((,class (:foreground ,dotshare-blue))))
   `(font-lock-string-face ((,class (:foreground ,dotshare-red))))
   `(font-lock-type-face ((,class (:foregorund ,dotshare-yellow))))
   `(font-lock-variable-name-face ((,class (:foreground ,dotshare-yellow))))
   `(font-lock-warning-face ((,class (:foreground ,dotshare-yellow-1 :weight bold :underline t))))
   `(font-lock-pseudo-keyword-face ((,class (:foreground ,dotshare-yellow))))
   `(font-lock-operator-face ((,class (:foreground ,dotshare-orange))))

   `(c-annotation-face ((,class (:inherit font-lock-constant-face))))

   ;;; external

   ;; auto-complete
   `(ac-candidate-face ((,class (:foreground ,dotshare-fg :background ,dotshare-bg+2))))
   `(ac-candidate-mouse-face ((,class (:background ,dotshare-blue-4))))
   `(ac-selection-face ((,class (:foreground "white" :background ,dotshare-blue-1))))
   `(ac-completion-face ((,class (:foreground ,dotshare-bg+2 :underline t))))
   `(popup-tip-face ((,class (:background ,dotshare-yellow :foreground ,dotshare-bg-1))))
   `(popup-scroll-bar-foreground-face ((,class (:background ,dotshare-fg))))
   `(popup-scroll-bar-background-face ((,class (:background ,dotshare-bg+2))))
   `(popup-isearch-match ((,class (:background ,dotshare-bg :foreground ,dotshare-fg))))

   ;; diff
   `(diff-added ((,class (:foreground ,dotshare-green+4))))
   `(diff-changed ((,class (:foreground ,dotshare-yellow))))
   `(diff-removed ((,class (:foreground ,dotshare-red))))
   `(diff-header ((,class (:background ,dotshare-bg+1))))
   `(diff-file-header
     ((,class (:background ,dotshare-bg+2 :foreground ,dotshare-fg :bold t))))

   ;; eshell
   `(eshell-prompt ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(eshell-ls-archive ((,class (:foreground ,dotshare-red-1 :weight bold))))
   `(eshell-ls-backup ((,class (:inherit font-lock-comment))))
   `(eshell-ls-clutter ((,class (:inherit font-lock-comment))))
   `(eshell-ls-directory ((,class (:foreground ,dotshare-blue+1 :weight bold))))
   `(eshell-ls-executable ((,class (:foreground ,dotshare-red+1 :weight bold))))
   `(eshell-ls-unreadable ((,class (:foreground ,dotshare-fg))))
   `(eshell-ls-missing ((,class (:inherit font-lock-warning))))
   `(eshell-ls-product ((,class (:inherit font-lock-doc))))
   `(eshell-ls-special ((,class (:inherit dotshare-yellow :weight bold))))
   `(eshell-ls-symlink ((,class (:foreground ,dotshare-cyan :weight bold))))

   ;; erc
   `(erc-action-face ((,class (:inherit erc-default-face))))
   `(erc-bold-face ((,class (:weight bold))))
   `(erc-current-nick-face ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(erc-dangerous-host-face ((,class (:inherit font-lock-warning))))
   `(erc-default-face ((,class (:foreground ,dotshare-fg))))
   `(erc-direct-msg-face ((,class (:inherit erc-default))))
   `(erc-error-face ((,class (:inherit font-lock-warning))))
   `(erc-fool-face ((,class (:inherit erc-default))))
   `(erc-highlight-face ((,class (:inherit hover-highlight))))
   `(erc-input-face ((,class (:foreground ,dotshare-yellow))))
   `(erc-keyword-face ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(erc-nick-default-face ((,class (:weight bold))))
   `(erc-nick-msg-face ((,class (:inherit erc-default))))
   `(erc-notice-face ((,class (:foreground ,dotshare-green))))
   `(erc-pal-face ((,class (:foreground ,dotshare-orange :weight bold))))
   `(erc-prompt-face ((,class (:foreground ,dotshare-orange :background ,dotshare-bg :weight bold))))
   `(erc-timestamp-face ((,class (:foreground ,dotshare-green+1))))
   `(erc-underline-face ((t (:underline t))))

   ;; flymake
   `(flymake-errline ((,class (:foreground ,dotshare-red-1 :weight bold :underline t))))
   `(flymake-warnline ((,class (:foreground ,dotshare-yellow-1 :weight bold :underline t))))

   ;; flyspell
   `(flyspell-duplicate ((,class (:foreground ,dotshare-yellow-1 :weight bold :underline t))))
   `(flyspell-incorrect ((,class (:foreground ,dotshare-red-1 :weight bold :underline t))))

   ;; gnus
   `(gnus-group-mail-1-face ((,class (:bold t :inherit gnus-group-mail-1-empty))))
   `(gnus-group-mail-1-empty-face ((,class (:inherit gnus-group-news-1-empty))))
   `(gnus-group-mail-2-face ((,class (:bold t :inherit gnus-group-mail-2-empty))))
   `(gnus-group-mail-2-empty-face ((,class (:inherit gnus-group-news-2-empty))))
   `(gnus-group-mail-3-face ((,class (:bold t :inherit 'nus-group-mail-3-empty))))
   `(gnus-group-mail-3-empty-face ((,class (:inherit gnus-group-news-3-empty))))
   `(gnus-group-mail-4-face ((,class (:bold t :inherit gnus-group-mail-4-empty))))
   `(gnus-group-mail-4-empty-face ((,class (:inherit gnus-group-news-4-empty))))
   `(gnus-group-mail-5-face ((,class (:bold t :inherit gnus-group-mail-5-empty))))
   `(gnus-group-mail-5-empty-face ((,class (:inherit gnus-group-news-5-empty))))
   `(gnus-group-mail-6-face ((,class (:bold t :inherit gnus-group-mail-6-empty))))
   `(gnus-group-mail-6-empty-face ((,class (:inherit gnus-group-news-6-empty))))
   `(gnus-group-mail-low-face ((,class (:bold t :inherit gnus-group-mail-low-empty))))
   `(gnus-group-mail-low-empty-face ((,class (:inherit gnus-group-news-low-empty))))
   `(gnus-group-news-1-face ((,class (:bold t :inherit gnus-group-news-1-empty))))
   `(gnus-group-news-2-face ((,class (:bold t :inherit gnus-group-news-2-empty))))
   `(gnus-group-news-3-face ((,class (:bold t :inherit gnus-group-news-3-empty))))
   `(gnus-group-news-4-face ((,class (:bold t :inherit gnus-group-news-4-empty))))
   `(gnus-group-news-5-face ((,class (:bold t :inherit gnus-group-news-5-empty))))
   `(gnus-group-news-6-face ((,class (:bold t :inherit gnus-group-news-6-empty))))
   `(gnus-group-news-low-face ((,class (:bold t :inherit gnus-group-news-low-empty))))
   `(gnus-header-content-face ((,class (:inherit message-header-other))))
   `(gnus-header-from-face ((,class (:inherit message-header-from))))
   `(gnus-header-name-face ((,class (:inherit message-header-name))))
   `(gnus-header-newsgroups-face ((,class (:inherit message-header-other))))
   `(gnus-header-subject-face ((,class (:inherit message-header-subject))))
   `(gnus-summary-cancelled-face ((,class (:foreground ,dotshare-orange))))
   `(gnus-summary-high-ancient-face ((,class (:foreground ,dotshare-blue))))
   `(gnus-summary-high-read-face ((,class (:foreground ,dotshare-green :weight bold))))
   `(gnus-summary-high-ticked-face ((,class (:foreground ,dotshare-orange :weight bold))))
   `(gnus-summary-high-unread-face ((,class (:foreground ,dotshare-fg :weight bold))))
   `(gnus-summary-low-ancient-face ((,class (:foreground ,dotshare-blue))))
   `(gnus-summary-low-read-face ((,class (:foreground ,dotshare-green))))
   `(gnus-summary-low-ticked-face ((,class (:foreground ,dotshare-orange :weight bold))))
   `(gnus-summary-low-unread-face ((,class (:foreground ,dotshare-fg))))
   `(gnus-summary-normal-ancient-face ((,class (:foreground ,dotshare-blue))))
   `(gnus-summary-normal-read-face ((,class (:foreground ,dotshare-green))))
   `(gnus-summary-normal-ticked-face ((,class (:foreground ,dotshare-orange :weight bold))))
   `(gnus-summary-normal-unread-face ((,class (:foreground ,dotshare-fg))))
   `(gnus-summary-selected-face ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(gnus-cite-1-face ((,class (:foreground ,dotshare-blue))))
   `(gnus-cite-10-face ((,class (:foreground ,dotshare-yellow-1))))
   `(gnus-cite-11-face ((,class (:foreground ,dotshare-yellow))))
   `(gnus-cite-2-face ((,class (:foreground ,dotshare-blue-1))))
   `(gnus-cite-3-face ((,class (:foreground ,dotshare-blue-2))))
   `(gnus-cite-4-face ((,class (:foreground ,dotshare-green+2))))
   `(gnus-cite-5-face ((,class (:foreground ,dotshare-green+1))))
   `(gnus-cite-6-face ((,class (:foreground ,dotshare-green))))
   `(gnus-cite-7-face ((,class (:foreground ,dotshare-red))))
   `(gnus-cite-8-face ((,class (:foreground ,dotshare-red-1))))
   `(gnus-cite-9-face ((,class (:foreground ,dotshare-red-2))))
   `(gnus-group-news-1-empty-face ((,class (:foreground ,dotshare-yellow))))
   `(gnus-group-news-2-empty-face ((,class (:foreground ,dotshare-green+3))))
   `(gnus-group-news-3-empty-face ((,class (:foreground ,dotshare-green+1))))
   `(gnus-group-news-4-empty-face ((,class (:foreground ,dotshare-blue-2))))
   `(gnus-group-news-5-empty-face ((,class (:foreground ,dotshare-blue-3))))
   `(gnus-group-news-6-empty-face ((,class (:foreground ,dotshare-bg+2))))
   `(gnus-group-news-low-empty-face ((,class (:foreground ,dotshare-bg+2))))
   `(gnus-signature-face ((,class (:foreground ,dotshare-yellow))))
   `(gnus-x-face ((,class (:background ,dotshare-fg :foreground ,dotshare-bg))))

   ;; ido
   `(ido-first-match ((,class (:foreground ,dotshare-green+3 :weight bold))))
   `(ido-only-match ((,class (:foreground ,dotshare-green+3 :weight bold))))
   `(ido-subdir ((,class (:foreground ,dotshare-fg))))

   ;; magit
   `(magit-section-title ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(magit-branch ((,class (:foreground ,dotshare-orange :weight bold))))
   `(magit-item-highlight ((,class (:background ,dotshare-bg+1 :weight bold))))

   ;; message-mode
   `(message-cited-text-face ((,class (:inherit font-lock-comment))))
   `(message-header-name-face ((,class (:foreground ,dotshare-green+1))))
   `(message-header-other-face ((,class (:foreground ,dotshare-green))))
   `(message-header-to-face ((,class (:inherit 'dotshare-yellow :weight bold))))
   `(message-header-from-face ((,class (:inherit 'dotshare-yellow :weight bold))))
   `(message-header-cc-face ((,class (:inherit 'dotshare-yellow :weight bold))))
   `(message-header-newsgroups-face ((,class (:inherit 'dotshare-yellow :weight bold))))
   `(message-header-subject-face ((,class (:inherit 'dotshare-orange :weight bold))))
   `(message-header-xheader-face ((,class (:foreground ,dotshare-green))))
   `(message-mml-face ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(message-separator-face ((,class (:inherit font-lock-comment))))

   ;; mew
   `(mew-face-header-subject ((,class (:foreground ,dotshare-orange))))
   `(mew-face-header-from ((,class (:foreground ,dotshare-yellow))))
   `(mew-face-header-date ((,class (:foreground ,dotshare-green))))
   `(mew-face-header-to ((,class (:foreground ,dotshare-red))))
   `(mew-face-header-key ((,class (:foreground ,dotshare-green))))
   `(mew-face-header-private ((,class (:foreground ,dotshare-green))))
   `(mew-face-header-important ((,class (:foreground ,dotshare-blue))))
   `(mew-face-header-marginal ((,class (:foreground ,dotshare-fg :weight bold))))
   `(mew-face-header-warning ((,class (:foreground ,dotshare-red))))
   `(mew-face-header-xmew ((,class (:foreground ,dotshare-green))))
   `(mew-face-header-xmew-bad ((,class (:foreground ,dotshare-red))))
   `(mew-face-body-url ((,class (:foreground ,dotshare-orange))))
   `(mew-face-body-comment ((,class (:foreground ,dotshare-fg :slant italic))))
   `(mew-face-body-cite1 ((,class (:foreground ,dotshare-green))))
   `(mew-face-body-cite2 ((,class (:foreground ,dotshare-blue))))
   `(mew-face-body-cite3 ((,class (:foreground ,dotshare-orange))))
   `(mew-face-body-cite4 ((,class (:foreground ,dotshare-yellow))))
   `(mew-face-body-cite5 ((,class (:foreground ,dotshare-red))))
   `(mew-face-mark-review ((,class (:foreground ,dotshare-blue))))
   `(mew-face-mark-escape ((,class (:foreground ,dotshare-green))))
   `(mew-face-mark-delete ((,class (:foreground ,dotshare-red))))
   `(mew-face-mark-unlink ((,class (:foreground ,dotshare-yellow))))
   `(mew-face-mark-refile ((,class (:foreground ,dotshare-green))))
   `(mew-face-mark-unread ((,class (:foreground ,dotshare-red-2))))
   `(mew-face-eof-message ((,class (:foreground ,dotshare-green))))
   `(mew-face-eof-part ((,class (:foreground ,dotshare-yellow))))

   ;; nav
   `(nav-face-heading ((,class (:foreground ,dotshare-yellow))))
   `(nav-face-button-num ((,class (:foreground ,dotshare-cyan))))
   `(nav-face-dir ((,class (:foreground ,dotshare-green))))
   `(nav-face-hdir ((,class (:foreground ,dotshare-red))))
   `(nav-face-file ((,class (:foreground ,dotshare-fg))))
   `(nav-face-hfile ((,class (:foreground ,dotshare-red-3))))

   ;; org-mode
   `(org-agenda-date-today
     ((,class (:foreground ,dotshare-fg :slant italic :weight bold))) t)
   `(org-agenda-structure
     ((,class (:inherit font-lock-comment-face))))
   `(org-archived ((,class (:foreground ,dotshare-fg :weight bold))))
   `(org-checkbox ((,class (:background ,dotshare-bg+2 :foreground ,dotshare-fg
					:box (:line-width 1 :style released-button)))))
   `(org-date ((,class (:foreground ,dotshare-blue :underline t))))
   `(org-deadline-announce ((,class (:foreground ,dotshare-red-1))))
   `(org-done ((,class (:bold t :weight bold :foreground ,dotshare-green+3))))
   `(org-formula ((,class (:foreground ,dotshare-yellow-2))))
   `(org-headline-done ((,class (:foreground ,dotshare-green+3))))
   `(org-hide ((,class (:foreground ,dotshare-bg-1))))
   `(org-level-1 ((,class (:foreground ,dotshare-orange))))
   `(org-level-2 ((,class (:foreground ,dotshare-green+1))))
   `(org-level-3 ((,class (:foreground ,dotshare-blue-1))))
   `(org-level-4 ((,class (:foreground ,dotshare-yellow-2))))
   `(org-level-5 ((,class (:foreground ,dotshare-cyan))))
   `(org-level-6 ((,class (:foreground ,dotshare-green-1))))
   `(org-level-7 ((,class (:foreground ,dotshare-red-3))))
   `(org-level-8 ((,class (:foreground ,dotshare-blue-4))))
   `(org-link ((,class (:foreground ,dotshare-yellow-2 :underline t))))
   `(org-scheduled ((,class (:foreground ,dotshare-green+4))))
   `(org-scheduled-previously ((,class (:foreground ,dotshare-red-3))))
   `(org-scheduled-today ((,class (:foreground ,dotshare-blue+1))))
   `(org-special-keyword ((,class (:foreground ,dotshare-yellow-1))))
   `(org-table ((,class (:foreground ,dotshare-green+2))))
   `(org-tag ((,class (:bold t :weight bold))))
   `(org-time-grid ((,class (:foreground ,dotshare-orange))))
   `(org-todo ((,class (:bold t :foreground ,dotshare-red :weight bold))))
   `(org-upcoming-deadline ((,class (:inherit font-lock-keyword-face))))
   `(org-warning ((,class (:bold t :foreground ,dotshare-red :weight bold))))

   ;; outline
   `(outline-8 ((,class (:inherit default))))
   `(outline-7 ((,class (:inherit outline-8 :height 1.0))))
   `(outline-6 ((,class (:inherit outline-7 :height 1.0))))
   `(outline-5 ((,class (:inherit outline-6 :height 1.0))))
   `(outline-4 ((,class (:inherit outline-5 :height 1.0))))
   `(outline-3 ((,class (:inherit outline-4 :height 1.0))))
   `(outline-2 ((,class (:inherit outline-3 :height 1.0))))
   `(outline-1 ((,class (:inherit outline-2  :height 1.0))))

   ;; post-mode
   `(post-email-address-text-face  ((,class (:foreground ,dotshare-yellow :weight bold))))
   `(post-emoticon-face  ((,class (:foreground ,dotshare-green+2 :weight bold))))
   `(post-header-keyword-face  ((,class (:foreground ,dotshare-bg+1))))
   `(post-header-value-face  ((,class (:foreground ,dotshare-fg))))
   `(post-multiply-quoted-text-face  ((,class (:foreground ,dotshare-orange))))
   `(post-quoted-text-face  ((,class (:foreground ,dotshare-yellow))))
   `(post-signature-text-face  ((,class (:foreground ,dotshare-bg+2))))
   `(post-underline-face  ((,class (:foreground ,dotshare-green))))
   `(post-url-face  ((,class (:foreground ,dotshare-blue-2 :underline t))))

   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face ((,class (:foreground ,dotshare-cyan))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground ,dotshare-yellow))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground ,dotshare-blue+1))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground ,dotshare-red+1))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground ,dotshare-green+1))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground ,dotshare-blue-1))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground ,dotshare-green+4))))
   `(rainbow-delimiters-depth-8-face ((,class (:foreground ,dotshare-red-3))))
   `(rainbow-delimiters-depth-9-face ((,class (:foreground ,dotshare-yellow-2))))
   `(rainbow-delimiters-depth-10-face ((,class (:foreground ,dotshare-green+2))))
   `(rainbow-delimiters-depth-11-face ((,class (:foreground ,dotshare-blue+1))))
   `(rainbow-delimiters-depth-12-face ((,class (:foreground ,dotshare-red-3))))

   ;; rpm-mode
   `(rpm-spec-dir-face ((,class (:foreground ,dotshare-green))))
   `(rpm-spec-doc-face ((,class (:foreground ,dotshare-green))))
   `(rpm-spec-ghost-face ((,class (:foreground ,dotshare-red))))
   `(rpm-spec-macro-face ((,class (:foreground ,dotshare-yellow))))
   `(rpm-spec-obsolete-tag-face ((,class (:foreground ,dotshare-red))))
   `(rpm-spec-package-face ((,class (:foreground ,dotshare-red))))
   `(rpm-spec-section-face ((,class (:foreground ,dotshare-yellow))))
   `(rpm-spec-tag-face ((,class (:foreground ,dotshare-blue))))
   `(rpm-spec-var-face ((,class (:foreground ,dotshare-red))))

   ;; show-paren
   `(show-paren-mismatch ((,class (:foreground ,dotshare-red+1 :background ,dotshare-bg :weight bold))))
   `(show-paren-match ((,class (:foreground ,dotshare-blue+1 :background ,dotshare-bg :weight bold))))

   ;; speedbar
   `(speedbar-button-face ((,class (:foreground ,dotshare-green+1))))
   `(speedbar-directory-face ((,class (:foreground ,dotshare-blue+1))))
   `(speedbar-file-face ((,class (:foreground ,dotshare-fg))))
   `(speedbar-highlight-face ((,class (:background ,dotshare-bg+2))))
   `(speedbar-selected-face ((,class (:background ,dotshare-bg+1))))
   `(speedbar-separator-face ((,class (:foreground ,dotshare-bg+1))))
   `(speedbar-tag-face ((,class (:foreground ,dotshare-yellow))))

   ;; tabbar
   `(tabbar-default ((,class (:foreground ,dotshare-fg :background ,dotshare-bg+1 :box (:line-width 1 :color ,dotshare-bg+1)))))
   `(tabbar-highlight ((,class (:foreground ,dotshare-fg))))
   `(tabbar-selected ((,class (:foreground ,dotshare-fg :box (:line-width 1 :color ,dotshare-bg+1)))))
   `(tabbar-button ((,class (:background ,dotshare-bg+1))))
   `(tabbar-button-highlight ((,class (:foreground ,dotshare-fg))))
   `(tabbar-unselected ((,class (:foreground ,dotshare-fg))))
   `(tabbar-separator ((,class (:foreground ,dotshare-fg))))

   ;; wl (wanderlust)
   ;; some faces end with -face, while other don't; confusing
   `(wl-highlight-folder-few-face ((,class (:foreground ,dotshare-red-2))))
   `(wl-highlight-folder-many-face ((,class (:foreground ,dotshare-red-1))))
   `(wl-highlight-folder-path-face ((,class (:foreground ,dotshare-orange))))
   `(wl-highlight-folder-unread-face ((,class (:foreground ,dotshare-blue))))
   `(wl-highlight-folder-zero-face ((,class (:foreground ,dotshare-fg))))
   `(wl-highlight-folder-unknown-face ((,class (:foreground ,dotshare-blue))))
   `(wl-highlight-message-citation-header ((,class (:foreground ,dotshare-red-1))))
   `(wl-highlight-message-cited-text-1 ((,class (:foreground ,dotshare-red))))
   `(wl-highlight-message-cited-text-2 ((,class (:foreground ,dotshare-green+2))))
   `(wl-highlight-message-cited-text-3 ((,class (:foreground ,dotshare-blue))))
   `(wl-highlight-message-cited-text-4 ((,class (:foreground ,dotshare-blue+1))))
   `(wl-highlight-message-header-contents-face ((,class (:foreground ,dotshare-green))))
   `(wl-highlight-message-headers-face ((,class (:foreground ,dotshare-red+1))))
   `(wl-highlight-message-important-header-contents ((,class (:foreground ,dotshare-green+2))))
   `(wl-highlight-message-header-contents ((,class (:foreground ,dotshare-green+1))))
   `(wl-highlight-message-important-header-contents2 ((,class (:foreground ,dotshare-green+2))))
   `(wl-highlight-message-signature ((,class (:foreground ,dotshare-green))))
   `(wl-highlight-message-unimportant-header-contents ((,class (:foreground ,dotshare-fg))))
   `(wl-highlight-summary-answered-face ((,class (:foreground ,dotshare-blue))))
   `(wl-highlight-summary-disposed-face ((,class (:foreground ,dotshare-fg
							      :slant italic))))
   `(wl-highlight-summary-new-face ((,class (:foreground ,dotshare-blue))))
   `(wl-highlight-summary-normal-face ((,class (:foreground ,dotshare-fg))))
   `(wl-highlight-summary-thread-top-face ((,class (:foreground ,dotshare-yellow))))
   `(wl-highlight-thread-indent-face ((,class (:foreground ,dotshare-magenta))))
   `(wl-highlight-summary-refiled-face ((,class (:foreground ,dotshare-fg))))
   `(wl-highlight-summary-displaying-face ((,class (:underline t :weight bold)))))

  (custom-theme-set-variables
   'dotshare

   `(ansi-color-names-vector [,dotshare-bg ,dotshare-red ,dotshare-green ,dotshare-yellow
					   ,dotshare-blue ,dotshare-magenta ,dotshare-cyan ,dotshare-fg])
   `(ansi-term-color-vector [,dotshare-bg ,dotshare-red ,dotshare-green ,dotshare-yellow
					  ,dotshare-blue ,dotshare-magenta ,dotshare-cyan ,dotshare-fg])))

(provide-theme 'dotshare)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; dotshare-theme.el ends here.
