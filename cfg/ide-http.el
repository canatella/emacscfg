;; -*- lexical-binding: t; -*-

(use-package restclient
  :ensure t
  :after mmm-mode
  :mode ("\\.http\\'" . restclient-mode)
  :custom (restclient-log-request nil "Do not log requests")
  :config

  (mmm-add-group
   'restclient-elisp
   '((restclient-elisp-variable-multiline
      :submode emacs-lisp-mode
      :face mmm-code-submode-face
      :delimiter-mode nil
      :front ":= <<\n"
      :back "\n#\n")
     (restclient-elisp-variable-singleline
      :submode emacs-lisp-mode
      :face mmm-code-submode-face
      :delimiter-mode nil
      :front ":= ("
      :back ")\n")
     (restclient-json-body
      :submode js-mode
      :face mmm-code-submode-face
      :delimiter-mode nil
      :front "\n\n{"
      :back "}\n\n")))
  (add-to-list 'mmm-mode-ext-classes-alist '(restclient-mode "\\.http\\'" restclient-elisp)))

(use-package restclient-jq
  :ensure t)

(use-package hmac
  :quelpa (hmac :fetcher github :repo "grimnebulin/emacs-hmac"))

(cl-defun
 biot-build-search-request (&key filter) (url-hexify-string (json-serialize `(filter: ,filter))))

(cl-defun
 biot-build-search-filter (parameter &key in eq lt lte gt gte like from to is-null is-not-null not)
 (let ((filters
        (seq-filter
         #'identity
         (list
          (when in
            `(in . ,in))
          (when eq
            `(eq . ,eq))
          (when lt
            `(lt . ,lt))
          (when lte
            `(lte . ,lte))
          (when gt
            `(gt . ,gt))
          (when gte
            `(gte . ,gte))
          (when like
            `(like . ,like))
          (when from
            `(from . ,from))
          (when to
            `(to . ,to))
          (when is-null
            `(isNull . ,is-null))
          (when is-not-null
            `(isNotNull . ,is-not-null))
          (when not
            `(not . ,not))))))
   `(,parameter . (,filters))))

(cl-defmacro
 biot-search-request (&key filter) "Build a BioT search request query argument using FILTER."
 `(biot-build-search-request
   :filter (biot-build-search-filter (quote ,(car filter)) ,@ (cdr filter))))
