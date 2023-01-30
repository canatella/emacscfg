(use-package org
  :ensure t
  :bind (("C-c c" . #'consult-org-capture))
  ;;  :hook (org-mode . #'cfg-setup-org-mode)
  :custom
  (org-src-fontify-natively t "Fontify code blocks.")
  (org-generic-id-locations-file (no-littering-expand-var-file-name "org/org-generic-id-locations"))
  (org-src-tab-acts-natively t "Ident using language behaviour in code blocks.")
  (org-return-follows-link t "Return key follows link")
  (org-directory "~/Drive/Org/")
  (org-agenda-files (list (concat org-directory "calendars/")))
  (org-capture-templates
   '(("t" "Task" entry (file "tasks.org") "* TODO %? %^g\n%U" :empty-lines 1)
     ("q" "Question" entry (file "tasks.org") "* TODO %?\n%U\n%^{for}p" :empty-lines 1)))

  :config
  (defun cfg-setup-org-tags ()
    "Setup org tags"
    (turn-on-auto-fill)
    (let* ((date-re "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}")
           (time-re "[0-9]\\{2\\}:[0-9]\\{2\\}")
           (day-re "[A-Za-z]\\{3\\}")
           (day-time-re (format "\\(%s\\)? ?\\(%s\\)?" day-re time-re)))
      (setq svg-tag-tags
            `( ;; Org tags
              (":\\([A-Za-z][A-Za-z0-9]+\\)" . ((lambda (tag) (svg-tag-make tag))))
              (":\\([A-Za-z][A-Za-z0-9]+[ \-]\\)" . ((lambda (tag) tag)))

              ;; Task priority
              ("\\[#[A-Z]\\]"
               .
               ((lambda (tag) (svg-tag-make tag :face 'org-priority :beg 2 :end -1 :margin 0))))

              ;; Progress
              ("\\(\\[[0-9]\\{1,3\\}%\\]\\)"
               .
               ((lambda (tag) (svg-progress-percent (substring tag 1 -2)))))
              ("\\(\\[[0-9]+/[0-9]+\\]\\)"
               .
               ((lambda (tag) (svg-progress-count (substring tag 1 -1)))))

              ;; TODO / DONE
              ("TODO" . ((lambda (tag) (svg-tag-make "TODO" :face 'org-todo :inverse t :margin 0))))
              ("DONE" . ((lambda (tag) (svg-tag-make "DONE" :face 'org-done :margin 0))))

              ;; Agenda
              ("\\(personal\\):" .
               ((lambda (tag)
                  (svg-lib-tag
                   "personal"
                   nil
                   :stroke 0
                   :font-weight 'semibold
                   :background "#a3be8c"
                   :foreground "#2e3440"))))
              ("\\(work\\):" .
               ((lambda (tag)
                  (svg-lib-tag
                   "work"
                   nil
                   :stroke 0
                   :font-weight 'semibold
                   :background "#b48ead"
                   :foreground "#2e3440"))))

              ;; Citation of the form [cite:@Knuth:1984]
              ("\\(\\[cite:@[A-Za-z]+:\\)"
               .
               ((lambda (tag) (svg-tag-make tag :inverse t :beg 7 :end -1 :crop-right t))))
              ("\\[cite:@[A-Za-z]+:\\([0-9]+\\]\\)"
               .
               ((lambda (tag) (svg-tag-make tag :end -1 :crop-left t))))


              ;; Active date (with or without day name, with or without time)
              (,(format "\\(<%s>\\)" date-re)
               .
               ((lambda (tag) (svg-tag-make tag :beg 1 :end -1 :margin 0))))
              (,(format "\\(<%s \\)%s>" date-re day-time-re)
               .
               ((lambda (tag) (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0))))
              (,(format "<%s \\(%s>\\)" date-re day-time-re)
               .
               ((lambda (tag) (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0))))

              ;; Inactive date  (with or without day name, with or without time)
              (,(format "\\(\\[%s\\]\\)" date-re)
               .
               ((lambda (tag) (svg-tag-make tag :beg 1 :end -1 :margin 0 :face 'org-date))))
              (,(format "\\(\\[%s \\)%s\\]" date-re day-time-re)
               .
               ((lambda (tag)
                  (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0 :face 'org-date))))
              (,(format "\\[%s \\(%s\\]\\)" date-re day-time-re)
               .
               ((lambda (tag)
                  (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0 :face 'org-date))))))
      (svg-tag-mode t)))
  (add-hook 'org-mode-hook #'cfg-setup-org-tags)
  (add-hook 'org-agenda-mode-hook #'cfg-setup-org-tags)
  (defun org-agenda-show-svg ()
    (let* ((case-fold-search nil)
           (keywords (mapcar #'svg-tag--build-keywords svg-tag--active-tags))
           (keyword (car keywords)))
      (while keyword
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward (nth 0 keyword) nil t)
            (overlay-put
             (make-overlay (match-beginning 0) (match-end 0))
             'display
             (nth 3 (eval (nth 2 keyword))))))
        (pop keywords)
        (setq keyword (car keywords)))))
  (add-hook 'org-agenda-finalize-hook #'org-agenda-show-svg))

(use-package org-gcal
  :ensure t)

(use-package org-agenda
  :bind (:map org-agenda-mode-map ("M-." . #'org-agenda-goto) ("g" . #'org-calendar-refresh)))

(defun consult--org-capture-templates ()
  "Return a list of capture templates."
  (thread-first
   org-capture-templates
   (org-capture-upgrade-templates)
   (org-contextualize-keys org-capture-templates-contexts)))


;;;###autoload
(defun consult-org-capture ()
  "Choose a capture template."
  (interactive)
  ;; This is a list of org capture templates that take the form (KEYS DESC ...)
  (let* ((read-string
          (seq-map
           (lambda (it) (format "%s %s" (car it) (cadr it))) (consult--org-capture-templates)))
         (selection (completing-read "Capture template: " read-string nil :require-match))
         (key (car (split-string selection "\s" t))))
    (org-capture nil key)))

(defvar org-calendar-sync-processes '())

(defun org-calendar-sync (title email url calendar)
  "Synchronize calendar at URL for EMAIL with TITLE."
  (let* ((calendar-dir (concat org-directory "calendars/"))
         (calendar-file (expand-file-name (concat calendar-dir email ".org")))
         (ics-file (expand-file-name (concat calendar-dir email ".ics")))
         (buffer "*org-calendar-sync*")
         (cmd
          (format "curl -s -o %s %s && %s -count -d %s -a %s %s"
                  ics-file
                  url
                  (expand-file-name "~/.local/bin/ical2org")
                  calendar-file
                  calendar-file
                  ics-file)))
    (mkdir calendar-dir t)
    (with-current-buffer buffer
      (insert (format "Running %s\n" cmd))
      (start-process-shell-command "calsync" buffer cmd))))

(defun org-calendar-sync-all (callback)
  "Synchronize agendas."
  (message "synchronizing calendars...")
  (let
      ((calendars
        '(("Personal calendar"
           "dmerenne@gmail.com"
           "https://calendar.google.com/calendar/ical/dmerenne%40gmail.com/private-c885f6b2cd33378cfef6e35733b91bd4/basic.ics"
           "personal")
          ("Work calendar"
           "damien@bloom-life.com"
           "https://calendar.google.com/calendar/ical/damien%40bloom-life.com/private-29f3b5faabf9628322f2663dacadb417/basic.ics"
           "work"))))
    (setq org-calendar-sync-processes
          (seq-map (apply-partially #'apply #'org-calendar-sync) calendars))
    (seq-do
     (lambda (process)
       (set-process-sentinel process (apply-partially #'org-calendar-wait callback)))
     org-calendar-sync-processes)))

(defun org-calendar-wait (callback process event)
  "Handle EVENT on calendar sync PROCESS."
  (when (string= event "finished\n")
    (setq org-calendar-sync-processes (cdr org-calendar-sync-processes)))
  (unless org-calendar-sync-processes
    (funcall callback)))

(defun org-calendar ()
  "Synchronize calendars and run `org-agenda'."
  (interactive)
  (org-calendar-sync-all #'org-agenda))

(defun org-calendar-refresh ()
  "Refresh agenda"
  (interactive)
  (org-calendar-sync-all #'org-agenda-redo-all))

(use-package orgit
  :ensure t)
