(use-package sgml-mode
  :bind (:map sgml-mode-map
              ("«" . my-sgml-mode-insert-less-then)
              ("»" . my-sgml-mode-insert-greater-then))
  :config
  (defun my-sgml-mode-insert-less-then ()
    "Insert < at current point in buffer."
    (interactive)
    (insert "<"))

  (defun my-sgml-mode-insert-greater-then ()
    "Insert > at current point in buffer."
    (interactive)
    (insert ">"))

  (defun my-sgml-close-tag (orig-fun &rest args)
    (interactive)
    "Close current element, possibly ending ruby block."
    (if (and
         (string= "text" (car (sgml-lexical-context)))
         (let ((context (save-excursion (sgml-get-context))))
           (if context
               (let ((tag-name (sgml-tag-name (car (last context)))))
                 (or
                  (string= "erb-multi-block" tag-name)
                  (string= "erb-block" tag-name))))))
        (progn
          (insert "<% end %>")
          (indent-according-to-mode))
      (apply orig-fun args)))
  (advice-add 'sgml-close-tag :around #'my-sgml-close-tag))
