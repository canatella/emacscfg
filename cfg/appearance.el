;; -*- lexical-binding: t; -*-
(use-package use-theme :quelpa (use-theme :fetcher github :repo "canatella/use-theme"))

(use-theme solarized-theme
  :ensure t
  :name solarized-dark
  :style dark

  :disabled :custom
  (solarized-distinct-fringe-background '())
  (solarized-use-less-bold t)
  (solarized-use-variable-pitch '()))

(use-theme solarized-theme  :ensure t :name solarized-light-high-contrast :style light :disabled t)

(use-theme nord-theme
  :ensure t
  :style dark

  :disabled :custom-face
  '(show-paren-match-expression ((t (:background "#434C5E")))))

(use-theme apropospriate-theme
  :ensure t
  :name apropospriate-light
  :style light

  :disabled :custom-face
  '(show-paren-match-expression ((t (:background "#F5F5FC")))))

(use-theme nano-theme
  :after use-theme
  :name ((dark . nano-dark)
         (light . nano-light))
  ;;  :custom (nano-fonts-use t)
  ;;  :custom-face (nano-mono ((t (:family "Victor Mono"))))
  :custom-face (show-paren-match-expression ((t (:extend t :weight extra-bold :background "#3B4252"))))
  :quelpa (nano-theme :fetcher github :repo "canatella/nano-theme":branch "fix-load-theme-support"))

;;;;; Font configuration
(load-config 'ligature)

(defun cfg-default-font ()
  "Return the first available font."
  (or
   (seq-find
    (lambda (font)
      (member (car font) (font-family-list)))
    cfg-fonts)
   (car cfg-fonts)))

(defun cfg-default-font-spec ()
  "Return the resource font spec."
  (let ((font (cfg-default-font)))
    (concat (car font) "-" (cadr font))))

(defun cfg-default-ligatures () "Return the default ligatures." (cddr (cfg-default-font)))

(use-package
  font-core
  :custom (global-font-lock-mode t  "Enable syntax highlighting.")
  :config (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
  (set-face-attribute 'font-lock-builtin-face nil :slant 'italic))

(use-package ligature
  :ensure t
  :config (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode (cfg-default-ligatures))
  (global-ligature-mode t))

(use-package all-the-icons :ensure t)

(use-package
  all-the-icons-dired
  :ensure t
  :after (dired all-the-icons)
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package
  frame
  :custom (frame-background-mode 'dark "Using a dark theme.")
  (initial-frame-alist
   `((undecorated . t)
     (vertical-scroll-bars)
     (fullscreen . maximized)
     (font . ,(cfg-default-font-spec))
     (alpha . (95 . 95))))
  (default-frame-alist
   `((undecorated . t)
     (vertical-scroll-bars .nil)
     (fullscreen . maximized)
     (tool-bar-liens . 0)
     (menu-bar-liens . 0)
     (font . ,(cfg-default-font-spec))
     (alpha . (95 . 95))))
  (display-buffer-alist
   '((".*" display-buffer-reuse-window (reusable-frames . t)))
   "Do not always create a new window, reuse old ones.")
  (window-divider-mode t "Show separator between frames")
  (window-divider-default-right-width 1)
  :custom-face (window-divider ((t (:foreground "#b0bec5")))))

(use-package fringe :custom (fringe-mode '(8 . 8)))

(use-package ns-auto-titlebar :ensure t :if
  (memq window-system '(mac ns))
  :custom (ns-auto-titlebar-mode t))

(use-package
  ns-win
  :if (memq window-system '(mac ns))
  :custom (mac-right-command-modifier 'super)
  (mac-right-option-modifier '())
  (mac-option-modifier 'meta)
  (mac-command-modifier 'super))

(use-package scroll-bar :custom (scroll-bar-mode '() "No scroll bar."))

(use-package tool-bar :custom (tool-bar-mode '() "No tool bar."))

(when (fboundp 'set-fontset-font)
  (set-fontset-font t '(#x1f000 . #x1faff) (font-spec :family "Noto Color Emoji")))
;;(use-package nano-emacs :straight
;;  (nano-emacs :type git :host github :repo "rougier/nano-emacs")
;;  :config (require 'nano-faces)
;;  (require 'nano-writer))

;;(use-package mode-line
;;  :custom-face (mode-line ((t (:family "Ubuntu Condensed" :height 100))))
;;  (mode-line-active ((t (:family "Ubuntu Condensed"))))
;;  (mode-line-buffer-id ((t (:family "Ubuntu Condensed"))))
;;  (mode-line-emphasis ((t (:family "Ubuntu Condensed"))))
;;  (mode-line-highlight ((t (:family "Ubuntu Condensed"))))
;;  (mode-line-inactive ((t (:family "Ubuntu Condensed")))))
