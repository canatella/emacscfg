(use-package compile
  :bind (([f10] . recompile)
         ([H-f10] . compile)
         ([s-f10] . kill-compilation))
  :diminish '(compilation-in-progress . "⚙")
  :custom
  (compilation-ask-about-save '()
                              "Do not ask for save when compiling.")
  (compilation-scroll-output 'first-error
                             "Scroll down with output, but stop at first error."))
