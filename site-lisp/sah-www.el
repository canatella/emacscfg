(defun sah-www-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion

        (back-to-indentation)

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun sah-www-js2-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        ))))

(defun sah-www-downcase-initial (string)
  (concat (downcase (substring string 0 1)) (substring string 1)))


(defun sah-www-test ()
  (let* ((functional (if (string-match "^\\([a-zA-Z0-9._]+\\) = Sah\\.Test\\.functional" (buffer-string))
                         (match-string 1 (buffer-string))))
         (view-controller (if (string-match "<form name=\"\\([a-zA-Z0-9._]+\\)\"" (buffer-string))
                              (match-string 1 (buffer-string))))
         (controller (cond (view-controller view-controller)
                           ((string-match "^\\([a-zA-Z0-9._]+\\) = Class\\.create(Controllers\\.BaseController" (buffer-string))
                            (match-string 1 (buffer-string)))))
         (unit (if (string-match "^\\([a-zA-Z0-9._]+\\) = Sah\\.Test\\.unit" (buffer-string))
                    (match-string 1 (buffer-string))))
         (model (if (string-match "^\\([a-zA-Z0-9._]+\\) = Class\\.create(Sah\\.Models\\." (buffer-string))
                    (match-string 1 (buffer-string))))
         (klass (cond (functional (replace-regexp-in-string "^Test\." "" functional))
                      (controller controller)
                      (unit  (replace-regexp-in-string "^Test\." "" unit))
                      (model model)))
         (test (cond (functional functional)
                     (unit unit)
                     (controller (concat "Test." controller))
                     (model (concat "Test." model))))
         (page (cond (functional "/test-functional.html")
                     (controller "/test-functional.html")
                     (model "/test-unit.html")
                     (unit "/test-unit.html")))
         (klass-file (format "%s%s%s.js"
                             (sah-project-component-directory (sah-buffer-component))
                             (cond ((or controller functional) "web/js/controllers/")
                                   ((or model unit) "web/js/sah/models/"))
                             (sah-www-downcase-initial (car (last (split-string klass "\\."))))))
         (test-file (format "%s%s%s.js"
                             (sah-project-component-directory (sah-buffer-component))
                             (cond ((or controller functional) "web/js/test/controllers/")
                                   ((or model unit) "web/js/test/sah/models/"))
                             (sah-www-downcase-initial (car (last (split-string test "\\."))))))
         (view (if (or functional controller)
                   (let ((test-code (if functional (buffer-string)
                                      (save-excursion
                                        (set-buffer (find-file-noselect test-file))
                                        (buffer-string)))))
                     (progn (string-match "^[a-zA-Z._]+ = Sah\\.Test\\.functional(\"\\([^\"]+\\)\"" test-code)
                            (match-string 1 test-code)))))
         (view-file (format "%sviews%s.m4"
                            (sah-project-component-directory "sah_services_www_apps_configurator")
                            view)))
    (if (or controller model functional unit)
        (list (cons :klass klass) (cons :test test)
              (cons :klass-file klass-file) (cons :test-file test-file)
              (cons :view-file view-file) (cons :view view) (cons :test-page page)))))

(defun sah-www-switch-klass-test ()
  (interactive)
  (let ((test (sah-www-test)))
    (if test
        (let* ((klass-file (cdr (assoc :klass-file test)))
               (test-file  (cdr (assoc :test-file test)))
               (file (cond ((string= klass-file (buffer-file-name)) test-file)
                           ((string= test-file (buffer-file-name)) klass-file)))
               (buffer (find-file-noselect file))
               (window (get-buffer-window buffer)))
          (if window (select-window window)
            (switch-to-buffer buffer))))))

(defun sah-www-switch-klass-view ()
  (interactive)
  (let ((test (sah-www-test)))
    (if test
        (let* ((klass-file (cdr (assoc :klass-file test)))
               (view-file  (cdr (assoc :view-file test)))
               (file (cond ((string= klass-file (buffer-file-name)) view-file)
                           ((string= view-file (buffer-file-name)) klass-file)))
               (buffer (find-file-noselect file))
               (window (get-buffer-window buffer)))
          (if window (select-window window)
            (switch-to-buffer buffer))))))

(defun sah-www-run-test ()
  (interactive)
  (save-buffer)
  (let ((test (sah-www-test)))
    (if test
        (progn
          (call-process "make" nil nil 1 "-C" (sah-project-component-directory "sah_services_www_framework") "tests")
          (sah-www-firefox-load "(192.168.1.1|livebox)" (format "%s?%s&unfold"
                                                                (cdr (assoc :test-page test))
                                                                (cdr (assoc :test test))))))))

(defun sah-www-js2-mode-hook ()
  (require 'espresso)
  (require 'moz)
  (moz-minor-mode t)
  (setq espresso-indent-level 2
        indent-tabs-mode nil
        c-basic-offset 2)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'sah-www-js2-indent-function)
  (define-key js2-mode-map [(control meta q)] 'sah-wwww-indent-sexp)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))

  ;; fix bug with my-indent-sexp
  (setq c-current-comment-prefix
        (if (listp c-comment-prefix-regexp)
            (cdr-safe (or (assoc major-mode c-comment-prefix-regexp)
                          (assoc 'other c-comment-prefix-regexp)))
          c-comment-prefix-regexp)))



(add-hook 'js2-mode-hook 'sah-www-js2-mode-hook)

(defun sah-www-firefox-reload (location)
  (comint-send-string (inferior-moz-process)
                      (concat "for (i = 0; i < gBrowser.browsers.length; i++) {"
                              "browser = gBrowser.browsers[i];"
                              "if (browser.contentWindow.location.toString().match(/" location "/)) {"
                              "browser.reload(); gBrowser.selectTabAtIndex(i); break; }}")))

(defun sah-www-firefox-load (location page)
  (comint-send-string (inferior-moz-process)
                      (concat "for (i = 0; i < gBrowser.browsers.length; i++) {"
                              "browser = gBrowser.browsers[i];"
                              "if (browser.contentWindow.location.toString().match(/" location "/)) {"
                              "browser.reload(); gBrowser.selectTabAtIndex(i);"
                              "browser.contentWindow.location = '" page "';"
                              " break; }}; repl.home();")))



(defun sah-www-rebuild-and-reload ()
  (interactive)
  (if (and sah-project
           (or (string= (sah-buffer-component) "sah_services_www_apps_configurator")
               (string= (sah-buffer-component) "sah_services_www_framework")))
      (progn
        (call-process "make" nil nil 1 "-C" (sah-project-component-directory "sah_services_www_framework")
                      "rebuild")
        ;; wait for nfs to catch up
        (sah-www-firefox-reload "(192.168.1.1|livebox)"))))

(defun sah-www-visit-controller (file)
  "Open a controller file"
  (interactive
   (let* ((component "sah_services_www_apps_configurator")
          (directory (file-name-as-directory (concat (cdr (assoc component (sah-project-component-directories)))
                                                     "web/js/controllers"))))
     (list (read-file-name "Find controller: " directory))))
  (switch-to-buffer (find-file-noselect file))
  (let ((test (sah-www-test)))
    (if test
        (progn
          (find-file-other-window (cdr (assoc :test-file test)))
          (find-file-other-window (cdr (assoc :view-file test)))))))




(defun sah-www-visit-functional (file)
  "Open a controller file"
  (interactive
   (let* ((component "sah_services_www_apps_configurator")
          (directory (file-name-as-directory (concat (cdr (assoc component (sah-project-component-directories)))
                                                     "web/js/test/controllers"))))
     (list (read-file-name "Find functional test: " directory))))
  (switch-to-buffer (find-file-noselect file)))

(defun sah-www-visit-view (file)
  "Open a controller file"
  (interactive
   (let* ((component "sah_services_www_apps_configurator")
          (directory (file-name-as-directory (concat (cdr (assoc component (sah-project-component-directories)))
                                                     "views"))))
     (list (read-file-name "Find view: " directory))))
  (switch-to-buffer (find-file-noselect file)))

(defun sah-www-visit-model (file)
  "Open a controller file"
  (interactive
   (let* ((component "sah_services_www_framework")
          (directory (file-name-as-directory (concat (cdr (assoc component (sah-project-component-directories)))
                                                     "web/js/sah/models"))))
     (list (read-file-name "Find model: " directory))))
  (switch-to-buffer (find-file-noselect file))
  (let ((test (sah-www-test)))
    (if test
        (find-file-other-window (cdr (assoc :test-file test))))))

(defun sah-www-visit-unit (file)
  "Open a controller file"
  (interactive
   (let* ((component "sah_services_www_framework")
          (directory (file-name-as-directory (concat (cdr (assoc component (sah-project-component-directories)))
                                                     "web/js/test/sah/models"))))
     (list (read-file-name "Find unit test: " directory))))
  (switch-to-buffer (find-file-noselect file)))

(provide 'sah-www)
