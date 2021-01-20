;; -*- lexical-binding: t; -*-
(use-package-local use-theme)

(use-theme solarized
  :style dark
  :ensure t
  :disabled :custom
  (solarized-distinct-fringe-background '())
  (solarized-use-less-bold t)
  (solarized-use-variable-pitch '()))

(use-theme nord
  :style dark
  :custom-face '(show-paren-match-expression ((t (:background "#434C5E")))))

(use-theme apropospriate
  :name apropospriate-light
  :style light
  :custom-face '(show-paren-match-expression ((t (:background "#F5F5FC")))))

;;; Font configuration
(defconst cfg-fonts
  '(("Victor Mono" .
     ("14:medium" .
      ("</" "</>" "/>" "~-" "-~" "~@" "<~" "<~>" "<~~"
       "~>" "~~" "~~>" ">=" "<=" "<!--" "##" "###" "####"
       "|-" "-|" "|->" "<-|" ">-|" "|-<" "|=" "|=>" ">-"
       "<-" "<--" "-->" "->" "-<" ">->" ">>-" "<<-" "<->"
       "->>" "-<<" "<-<" "==>" "=>" "=/=" "!==" "!=" "<=="
       ">>=" "=>>" ">=>" "<=>" "<=<" "<<=" "=<<" ".-" ".="
       "=:=" "=!=" "==" "===" "::" ":=" ":>" ":<" ">:"
       ";;" "<|" "<|>" "|>" "<>" "<$" "<$>" "$>" "<+"
       "<+>" "+>" "?=" "/=" "/==" "/\\" "\\/" "__" "&&"
       "++" "+++")))
    ("Dank Mono" .
     ("15" . ("!=" "!==" "/*" "*/" "{[" "]}" "[[" "]]" "::" ":::" "==" "===" "=>" "->" "<-" "++" "|>")))
    ("Fira Code" .
     ("14" .
      ("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "[]"
       "::" ":::" ":=" "!!" "!=" "!==" "-}" "--" "---" "-->" "->"
       "->>" "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?"
       "#_" "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
       "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>"
       "^=" "$>" "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>"
       "<=" "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
       "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
       "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
       "<~" "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
       "x" ":" "+" "+" "*")))
    ("Cascadia" .
     ("14" .
      ("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
       "\\" "://")))))

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

(use-package-local ligature
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
     (alpha . (90 . 90))))
  (default-frame-alist
    `((undecorated . t)
      (vertical-scroll-bars)
      (fullscreen . maximized)
      (font . ,(cfg-default-font-spec))
      (alpha . (90 . 90))))
  (display-buffer-alist
   '((".*" display-buffer-reuse-window (reusable-frames . t)))
   "Do not always create a new window, reuse old ones."))

(use-package fringe :custom (fringe-mode '(8 . 8)))

(use-package
  ns-auto-titlebar
  :ensure t
  :if (memq window-system '(mac ns))
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
