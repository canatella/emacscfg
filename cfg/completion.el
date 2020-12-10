;; -*- lexical-binding: t; -*-

(use-package
  ivy
  :ensure t
  :bind (("C-x b" . ivy-switch-buffer))
  :diminish :custom
  (ivy-magic-slash-non-match-action #'ivy-magic-slash-non-match-create
                                    "Create directory when hitting / without matches")
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  (ivy-sort-matches-functions-alist
   '((t . ivy--shorter-matches-first)
     (project-find-file . cfg-ivy-sort-project-file-function)
     (counsel-ag . cfg-ivy-sort-project-file-function)
     (ivy-completion-in-region . ivy--shorter-matches-first)
     (ivy-switch-buffer . ivy-sort-function-buffer)))
  :init ;;(setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  :config (ivy-mode t)
  (defvar mohkale/ivy-collapse-paths t "when true, empty directories are chained together.")
  (defvar mohkale/ivy-collapse-paths--append-files nil
    "when true, the only file in a directory is appended to
that directory when shown by ivy. otherwise the directory
is shown by itself.")
  (defun collapse-directories (path files &optional read-directories-command)
    "collapses any hollow directory files under PATH.
a hollow directory is any directory which is either empty
or has only one child which must be a file. depending on
`mohkale/ivy-collapse-paths--append-files' that files is also
appended to the path.

if you'd like to specify you're own command for listing directories
(or have aliased `directory-files' for your own purposes, you can
specify the read-command as the final optional arg to this function."
    (or read-directories-command (setq read-directories-command #'directory-files))
    (mapcar
     (lambda (file)
       (when (and
              (ivy--dirname-p file)
              (not (or (string-equal file "./") (string-equal file "../"))))
         (let (dir-files file-count (do-recurse t))
           (ignore-errors ;; in case of permission errors
	     (while do-recurse
               (setq dir-files
                     (funcall read-directories-command (concat path file)
			      ;; all but . and ..
			      nil "^[^\\.]\\{1,2\\}")
                     file-count
                     (length dir-files))
               (cond
                ;; nothing left to recurse, end recursion
                ((eq file-count 0)
                 (setq do-recurse nil))
                ;; at least one found, cancel unless directory
                ((eq file-count 1)
                 (let* ((only-child (concat file (car dir-files))))
                   (if (file-directory-p (concat path only-child))
		       ;; include trailing / for identity purposes
		       (setq file (concat only-child "/"))
		     ;; encountered final leaf only-child, show if desired
		     (when mohkale/ivy-collapse-paths--append-files (setq file only-child))
                     (setq do-recurse nil))))
                ;; encountered non-hollow directory
                (t (setq do-recurse nil)))))))
       file)
     files))
  (defun counsel-find-file--collapse-directories-wrapper (func dir)
    (if (not mohkale/ivy-collapse-paths)
        (apply func dir nil) ;; no collapsing, leave as is
      (cl-letf*
          (((symbol-function 'actual-directory-files)
            (symbol-function 'directory-files))
           ((symbol-function 'actual-read-file-name-internal)
            (symbol-function 'read-file-name-internal))

           ;; wrap `read-file-name-internal' and `directory-files'
           ;; into collapsing directories when possible.
           ((symbol-function 'read-file-name-internal)
            (lambda (&rest args)
              (collapse-directories default-directory
                                    (apply #'actual-read-file-name-internal args)
                                    #'actual-directory-files)))
           ((symbol-function 'directory-files)
            (lambda (dir)
              (collapse-directories dir
                                    (mapcar
                                     ;; directory-files doesn't append / to dirs
                                     ;; so `ivy--dirname-p' won't work with them.
                                     (lambda (file)
                                       (if (file-directory-p (concat dir file))
                                           (setq file (concat file "/")))
                                       file)
                                     (actual-directory-files dir))
                                    #'actual-directory-files))))
        (apply func dir nil))))
  (advice-add 'ivy--sorted-files :around #'counsel-find-file--collapse-directories-wrapper))

(defun cfg-ivy-sort-project-file-function (name candidates)
  "Sort CANDIDATES according to their length, putting test directories last."
  (if (nthcdr ivy-sort-max-size candidates)
      candidates
    (seq-sort
     (lambda (x y)
       (let ((x-test-p (string-prefix-p "test/" x))
             (y-test-p (string-prefix-p "test/" y)))
         (cond
          ((and x-test-p y-test-p)
           (< (length x) (length y)))
          (x-test-p nil)
          (y-test-p t)
          (t (< (length x) (length y))))))
     candidates)))

(use-package prescient :custom (prescient-filter-method "fuzzy") :ensure t)

(use-package
  ivy-prescient
  :ensure t
  :disabled :config
  (ivy-prescient-mode t)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (counsel-ag . ivy--regex-plus)
          (counsel-rg . ivy--regex-plus)
          (t      . ivy-prescient-re-builder))))

(use-package
  counsel
  :ensure-system-package ag
  :ensure ag
  :bind (("C-x C-f" . counsel-find-file)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ([f9] . counsel-ag))
  :config (let
              ((done (where-is-internal #'ivy-done     ivy-minibuffer-map t))
               (alt (where-is-internal #'ivy-alt-done ivy-minibuffer-map t)))
            (define-key counsel-find-file-map done #'ivy-alt-done)
            (define-key counsel-find-file-map alt  #'ivy-done)))

(use-package counsel-osx-app :ensure t)

(use-package flx :ensure t)

(use-package
  amx
  :ensure t
  :custom (amx-show-key-bindings t "Display key bindings in M-x")
  :config (amx-mode t))

(use-package
  counsel-dash
  :ensure t
  :bind (("C-h d" . counsel-dash)
         ("C-h ." . counsel-dash-at-point))
  :custom (counsel-dash-browser-func #'xwwp-browse-url-other-window)
  (dash-docs-browser-func #'xwwp-browse-url-other-window)
  :config (defun counsel-dash-at-point
              ()
            "Bring up a `counsel-dash' search interface with symbol at point."
            (interactive)
            (counsel-dash (substring-no-properties (or (thing-at-point 'symbol) "")))))
