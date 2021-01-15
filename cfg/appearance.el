;; -*- lexical-binding: t; -*-

(defvar cfg-theme-style 'light "Current style type")
(customize-set-variable 'custom-safe-themes t)

(use-package
  solarized-theme
  :ensure t
  :disabled :custom
  (solarized-distinct-fring-background '())
  (solarized-use-less-bold t)
  (solarized-use-variable-pitch '()))

(use-package nord-theme :ensure t :config
  (defun dark-theme ()
    "Switch to dark theme"
    (interactive)
    (setq cfg-theme-style 'dark)
    (mapcar #'disable-theme custom-enabled-themes)
    (load-theme 'nord t)
    (custom-set-faces
     '(show-paren-match-expression ((t (:background "#434C5E"))))))
  (dark-theme))

(use-package apropospriate-theme :ensure t :config
  (defun light-theme ()
    "Switch to light theme"
    (interactive)
    (setq cfg-theme-style 'light)
    (mapcar #'disable-theme custom-enabled-themes)
    (load-theme 'apropospriate-light t)
    (custom-set-faces
     '(show-paren-match-expression ((t (:background "#F5F5FC")))))))

(defun toggle-theme ()
  "Toggle theme between light and dark."
  (interactive)
  (if (eq cfg-theme-style 'light) (dark-theme) (light-theme)))

(use-package
  color-theme-sanityinc-tomorrow

  :disabled :config
  (color-theme-sanityinc-tomorrow-eighties))

(use-package arjen-grey-theme :disabled :config (load-theme 'arjen-grey))

(use-package sunburn-theme :disabled :ensure t :config (load-theme 'sunburn))

(use-package
  faces
  :config (cond
           ((and '() (member "Dank Mono" (font-family-list)))
            (set-face-attribute 'default nil :font "Dank Mono-15"))
           ((and t (member "Victor Mono" (font-family-list)))
            (set-face-attribute 'default nil :font "Victor Mono-14:medium"))
           ((and '() (member "Fira Code" (font-family-list)))
            (set-face-attribute 'default nil :font "Fira Code-14"))))

;;(use-package-local nano)

(use-package
  font-core
  :custom (global-font-lock-mode t  "Enable syntax highlighting.")
  :config (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
  (set-face-attribute 'font-lock-builtin-face nil :slant 'italic))

(defconst dank-ligatures
  '("!=" "!==" "/*" "*/" "{[" "]}" "[[" "]]" "::" ":::" "==" "===" "=>" "->" "<-" "++" "|>"))

(defconst victor-ligatures
  '("</" "</>" "/>" "~-" "-~" "~@" "<~" "<~>" "<~~" "~>" "~~" "~~>" ">=" "<=" "<!--" "##" "###"
    "####" "|-" "-|" "|->" "<-|" ">-|" "|-<" "|=" "|=>" ">-" "<-" "<--" "-->" "->" "-<" ">->" ">>-"
    "<<-" "<->" "->>" "-<<" "<-<" "==>" "=>" "=/=" "!==" "!=" "<==" ">>=" "=>>" ">=>" "<=>" "<=<"
    "<<=" "=<<" ".-" ".=" "=:=" "=!=" "==" "===" "::" ":=" ":>" ":<" ">:" ";;" "<|" "<|>" "|>" "<>"
    "<$" "<$>" "$>" "<+" "<+>" "+>" "?=" "/=" "/==" "/\\" "\\/" "__" "&&" "++" "+++"))

(defconst fira-ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>"
    "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~" "<~~" "</" "</>" "~@" "~-" "~=" "~>"
    "~~" "~~>" "%%" "x" ":" "+" "+" "*"))

(defun font-core-tie-compositions (char compositions)
  "Tie the characters of each item in COMPOSITIONS together.
Each item in COMPOSITIONS must start with CHAR.
Each composition must be supported by the font."
  (set-char-table-range composition-function-table char
                        `([,(regexp-opt compositions) 0 font-shape-gstring])))

(defun font-core-configure-ligatures (ligatures)
  (let ((by-first-char
         (seq-group-by (lambda (i) (elt i 0)) ligatures)))
    (seq-do
     (lambda (i)
       (font-core-tie-compositions (car i) (cdr i)))
     by-first-char)))

(font-core-configure-ligatures victor-ligatures)

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
   '((undecorated . t) (vertical-scroll-bars) (fullscreen . maximized)))
  (display-buffer-alist
   '((".*" display-buffer-reuse-window (reusable-frames . t)))
   "Do not always create a new window, reuse old ones.")
  :config (set-frame-parameter (selected-frame) 'alpha '(90 90))
  (add-to-list 'default-frame-alist '(alpha 90 90)))

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
