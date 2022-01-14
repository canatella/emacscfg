(with-eval-after-load 'hideshow
  (add-to-list 'hs-special-modes-alist
               (list 'nxml-mode
                     "<!--\\|<[^/>]*[^/]>"
                     "-->\\|</[^/>]*[^/]>"
                     "<!--"
                     'nxml-forward-element
                     nil)))

(use-package nxml-mode
  :hook (nxml-mode . hs-minor-mode)
  :bind (:map nxml-mode-map ("C-c h" . hs-hide-block) ("C-c s" . hs-show-block)))

(with-eval-after-load 'reformatter
  (reformatter-define xml-format :program "xmllint" :args '("--format" "-")))
