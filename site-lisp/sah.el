(require 'dired)
(require 'gud)
(require 'tail)
(require 'ido)

(defgroup sah nil "Integrate with SAH build system."
  :group 'environment)

(defcustom sah-p4-wijgmaal "sahwp4s01.be.softathome.com:1666"
  "The perforce server in Wijgmaal"
  :group 'sah
  :type :string)

(defcustom sah-p4-nanterre "sahwp4s01.be.softathome.com:1999"
  "The perforce server in Nanterre"
  :group 'sah
  :type :string)

(defcustom sah-p4-wijgmaal-workspace "sah5029_workspace_h1"
  "The default workspace for Wijgmaal"
  :group 'sah
  :type :string)

(defcustom sah-p4-nanterre-workspace "sah5029_workspace_h1"
  "The default workspace for Nanterre"
  :group 'sah
  :type :string)

(defcustom sah-default-config "sah/generic/pace-ava2426s2a2g/sah_multi_sip_normal/"
  "The default configuration when opening a project"
  :group 'sah
  :type :string)

(defcustom sah-prefix-key-string (kbd "C-c")
  "The default prefix key for the keymap"
  :group 'sah
  :type :sexp)

(defcustom sah-p4-workspace-filter "sah5029_workspace_h*"
  "The default workspace for Wijgmaal"
  :group 'sah
  :type :string)

(defvar sah-project nil "The current project")

(defvar sah-p4-buffer-name "*P4 Output*" "P4 output buffer.")

(defvar sah-build-buffer-name "*Build*" "Build output buffer.")

(defvar sah-wijgmaal-workspaces nil "The list of user workspaces in wijgmaal")

(defvar sah-nanterre-workspaces nil "The list of user workspaces in Nanterre")

(defvar sah-build-branch nil "The current build branch")

(defun sah-p4-exec (p4-port workspace interactive &rest args)
  "Execute a p4 command"
  (save-excursion
    (let ((output-buffer (get-buffer-create sah-p4-buffer-name)))
      (if (eq major-mode 'dired-mode)
          (let ((dir (dired-current-directory)))
            (set-buffer output-buffer)
            (setq default-directory dir)))
      (delete-region (point-min) (point-max))
      (let ((process (if interactive
                         (apply 'start-process "p4" sah-p4-buffer-name "p4"
                                "-p" p4-port
                                "-c" (car workspace)
                                "-d" default-directory args)
                       (apply 'call-process
                              "p4" nil sah-p4-buffer-name nil
                              "-p" p4-port
                              "-c" (car workspace)
                              "-d" default-directory args))))
        ))))

(defun sah-build-exec (p4-port workspace process command &rest args)
  "Execute a build command"
  (save-excursion
    (let ((output-buffer (get-buffer-create sah-build-buffer-name)))
      (set-buffer output-buffer)
      (setq default-directory (sah-build-directory))
      (setenv "P4PORT" p4-port)
      (setenv "P4CLIENT" (car workspace))
      (goto-char (point-max))
      (toggle-read-only 0)
      (insert (apply 'concat "Running " command " " (mapcar (lambda (w) (concat " " w)) args)))
      (goto-char (point-max))
      (insert "\n")
      (goto-char (point-max))
      (toggle-read-only 1)
      (let ((process (apply 'start-process-shell-command process output-buffer command args)))
        (set-process-filter process 'tail-filter)))))

(defun sah-make-exec (directory makefile &rest args)
  "Execute a make command"
  (save-excursion
    (let ((output-buffer (get-buffer-create sah-build-buffer-name)))
      (set-buffer output-buffer)
      (goto-char (point-max))
      (toggle-read-only 0)
      (insert (apply 'concat "Running make --directory " directory " -f " makefile (mapcar (lambda (w) (concat " " w)) args)))
      (goto-char (point-max))
      (toggle-read-only 1)
      (let ((process (apply 'start-process-shell-command "Make" output-buffer "make" "--directory" directory "-f" makefile args)))
        (set-process-filter process 'tail-filter)))))

(defun sah-workspaces (p4-port)
  "Return the list of perforce workspaces"
  (cond ((and sah-wijgmaal-workspaces (string= p4-port sah-p4-wijgmaal)) sah-wijgmaal-workspaces)
        ((and sah-nanterre-workspaces (string= p4-port sah-p4-nanterre)) sah-nanterre-workspaces)
        (t
         (let ((workspaces (split-string
                            (shell-command-to-string
                             (concat "P4PORT=" (or p4-port sah-p4-wijgmaal) " p4 workspaces -u " (getenv "P4USER") " | grep '" sah-p4-workspace-filter "'"))
                            "\n")))
           (let ((result (butlast (mapcar (lambda (w)
                                            (let ((info (split-string w)))
                                              (cons (nth 1 info) (file-name-as-directory (or (nth 4 info) "")))))
                                          workspaces))))
             (if (string= p4-port sah-p4-wijgmaal)
                 (setq sah-wijgmaal-workspaces result)
               (setq sah-nanterre-workspaces result))
             result)))))

(defun sah-workspace (p4-port &optional workspace-file)
  "Return the current workspace"
  (let ((workspace) (file-name (expand-file-name (or workspace-file (buffer-file-name)))))
    (dolist (w (sah-workspaces p4-port))
      (let ((workspace-directory (cdr w))
            (current-directory (substring file-name 0 (length (cdr w)))))
        (if (string= workspace-directory current-directory) (setq workspace w))))
    workspace))

(defun sah-workspace-wijgmaal (&optional workspace-file)
  "Return the current workspace for Wijgmaal"
  (or (and workspace-file (sah-workspace sah-p4-wijgmaal workspace-file))
      (let ((workspace))
        (dolist (w (sah-workspaces sah-p4-wijgmaal))
          (if (string= (car w) sah-p4-wijgmaal-workspace) (setq workspace w)))
        workspace)))

(defun sah-workspace-nanterre (&optional workspace-file)
  "Return the current workspace for Nanterre"
  (or (and workspace-file (sah-workspace sah-p4-nanterre workspace-file))
      (let ((workspace))
        (dolist (w (sah-workspaces sah-p4-nanterre))
          (if (string= (car w) sah-p4-nanterre-workspace) (setq workspace w)))
        workspace)
      (assoc "sah-p4-nanterre-workspace" (sah-workspaces sah-p4-nanterre))))

(defun sah-config-releases ()
  "Return the list of available release"
  (reverse
   (mapcar
    (lambda (w) (cons (cadr (split-string w "_V")) w))
    (butlast (split-string
              (shell-command-to-string
               (concat "P4PORT=" sah-p4-wijgmaal " p4 dirs //depot/config/REL/*"))
              "\n")))))

(defun sah-config-all ()
  "Return the list of available release"
  (reverse
   (cons "//depot/config/MAIN"
         (butlast (split-string
                   (shell-command-to-string
                    (concat "P4PORT=" sah-p4-wijgmaal " p4 dirs //depot/config/DEV/*"))
                   "\n")))))

(defun sah-build-all ()
  "Return the list of available release"
  (reverse
   (mapcar
    (lambda (w) (cadr (split-string w "//depot/build/")))
    (cons "//depot/build/MAIN"
          (butlast (split-string
                    (shell-command-to-string
                     (concat "P4PORT=" sah-p4-wijgmaal " p4 dirs //depot/build/REL/*"))
                    "\n"))))))


(defun sah-config-fetch-projects (config-directory &optional top)
  (if (not top) (setq top config-directory))
  (let ((project-list (split-string (shell-command-to-string
                                     (concat "P4PORT=" sah-p4-wijgmaal " p4 files " config-directory "/.../project.list")) "\n")))
    (remove-if-not stringp (mapcar
     (lambda (p) (file-name-directory (replace-regexp-in-string (file-name-as-directory top) "" (car (split-string p "#"))))) project-list))))


(defvar sah-config-projects-cache  () "projects cache")

(defun sah-config-projects (config-directory &optional top)
  "Return the available project for a release"
  (let ((projects (cdr (assoc config-directory sah-config-projects-cache))))
    (if projects
        projects
      (cdr (car (setq sah-config-projects-cache (cons (cons config-directory (sah-config-fetch-projects config-directory top)) sah-config-projects-cache)))))))

(defun sah-project-config-directory (project)
  "Return the configuration directory for a project"
  (let ((file (file-name-nondirectory (directory-file-name project))))
    (if (string-equal project "/")
        nil
      (if (string-equal (upcase file) file)
          project
        (sah-project-config-directory (file-name-directory (directory-file-name (expand-file-name project))))))))

(defun sah-project-config-branch (project)
  "Return the configuration branch for a project"
  (directory-file-name
   (replace-regexp-in-string
    (concat (cdr (sah-workspace-wijgmaal)) "config/")
    ""
    (sah-project-config-directory project))))

(defun sah-config-build-branch (config &optional project)
  (let ((project-list (concat config "/" (or project (car (sah-config-projects config))) "project.list")))
    (message project-list)
    (with-temp-buffer
      (insert (shell-command-to-string
               (concat "P4PORT=" sah-p4-wijgmaal " p4 print -q " project-list " | grep build=")))
      (goto-char (point-min))
      (end-of-line)
      (cadr (split-string (buffer-substring (point-min) (point)) "=")))))

(defvar sah-project-build-branches  () "build branches cache")

(defun sah-project-build-branch (project)
  "Return the build system branch for a project"
  (let ((build-branch (cdr (assoc project sah-project-build-branches))))
    (if sah-build-branch
      sah-build-branch
      (if build-branch
          build-branch
        (cdr (car (setq sah-project-build-branches (cons (cons project (sah-config-build-branch (concat "//depot/config/" (sah-project-config-branch project)))) sah-project-build-branches))))))))

(defun sah-project-build-directory (project)
  "Return the build directory for a project"
  (file-name-as-directory (concat (cdr (sah-workspace-wijgmaal)) "build/" (sah-project-build-branch project))))

(defun sah-project-build-p4-path (project)
  "Return the perforce path for the build system"
  (concat "//depot/build/" (sah-project-build-branch project)))

(defun sah-project-build-configured-p (project)
  "Check if a project is configured"
  (file-exists-p (concat (sah-project-build-directory project) "server.cfg")))

(defun sah-project-build-configure (project)
  "Configure the build system"
  (let ((server-cfg (concat (sah-project-build-directory project) "server.cfg")))
    (sah-p4-exec sah-p4-wijgmaal (sah-workspace-wijgmaal) nil "sync" "-f" (concat (sah-project-build-p4-path project) "/...#head"))
    (with-temp-buffer
      (insert (concat "w1=p4:" sah-p4-wijgmaal "/" (directory-file-name (car (sah-workspace-wijgmaal))) "\n"))
      (insert (concat "n1=p4:" sah-p4-nanterre "/" (directory-file-name (car (sah-workspace-nanterre))) "\n"))
      (write-region (point-min) (point-max) server-cfg))))

(defun sah-project-property (property)
  (cdr (assoc property sah-project)))

(defun sah-project-directory ()
  (sah-project-property 'project-directory))

(defun sah-project-list ()
  (sah-project-property 'project-list))

(defun sah-build-branch ()
  sah-build-branch)

(defun sah-build-directory ()
  (sah-project-property 'build-directory))

(defun sah-server-config ()
  (sah-project-property 'server-config))

(defun sah-config-branch ()
  (sah-project-property 'config-branch))

(defun sah-config-directory ()
  (sah-project-property 'config-directory))

(defun sah-config-file ()
  (sah-project-property 'config-file))

(defun sah-hardco-file ()
  (sah-project-property 'hardco-file))

(defun sah-output-directory ()
  (sah-project-property 'output-directory))

(defun sah-staging-directory ()
  (sah-project-property 'staging-directory))

(defun sah-release-directory ()
  (sah-project-property 'release-directory))

(defun sah-build-config ()
  (sah-project-property 'build-config))

(defun sah-build-info ()
  (sah-project-property 'build-info))

(defun sah-build-dep ()
  (sah-project-property 'build-dep))

(defun sah-component-config ()
  (sah-project-property 'component-config))

(defun sah-component-list ()
  (sah-project-property 'component-list))

(defvar sah-set-project-hook nil)

(defun sah-set-project (project)
  "Set the current project"
  (interactive "DProject directory: ")
  (let* ((project (expand-file-name (file-name-as-directory project)))
         (project-list (concat (file-name-as-directory project) "project.list")))
    (if (and (file-exists-p project-list) (file-regular-p project-list))
        (progn
          (sah-project-build-configure project)
          (setq sah-project (list (cons 'project-directory project)
                                  (cons 'project-list project-list)
                                  (cons 'build-branch (sah-project-build-branch project))
                                  (cons 'build-directory (sah-project-build-directory project))
                                  (cons 'server-config (concat (sah-project-build-directory project) "server.cfg"))
                                  (cons 'config-branch (sah-project-config-branch project))
                                  (cons 'config-directory (sah-project-config-directory project))
                                  (cons 'config-file (concat project "feature.config"))
                                  (cons 'hardco-file (concat project "hardco.cfg"))
                                  (cons 'output-directory (concat (sah-project-build-directory project) "output/"))
                                  (cons 'staging-directory (concat (sah-project-build-directory project) "output/staging/"))
                                  (cons 'release-directory (concat (sah-project-build-directory project) "output/release/"))
                                  (cons 'build-config (concat (sah-project-build-directory project) "buildconfig.default"))
                                  (cons 'build-info (concat (sah-project-build-directory project) "output/staging/buildconfig.info"))
                                  (cons 'build-dep (concat (sah-project-build-directory project) "output/staging/buildconfig.dep"))
                                  (cons 'component-config (concat (sah-project-build-directory project) "output/staging/components.config"))
                                  (cons 'component-list (concat (sah-project-build-directory project) "component.lst"))
                                  ))
          (setenv "STAGINGDIR" (sah-staging-directory))
          (setenv "PKG_CONFIG_LIBDIR" (format "%sbuild/pkg-config" (sah-staging-directory)))
          (setenv "PKG_CONFIG_TOP_BUILD_DIR" (sah-staging-directory))

          (run-hooks 'sah-set-project-hook)
          )
      (message "Directory %s does not seem to be a project directory" project))))

(defun sah-get-source ()
  "Synchronize the current project with perforce"
  (interactive)
  (sah-build-exec sah-p4-wijgmaal (sah-workspace-wijgmaal)
                  "getsource"
                  (concat (sah-build-directory) "build.sh")
                  (sah-project-directory) "synconly" "nocleanstaging"))

(defun sah-source-configured-p ()
  (file-exists-p  (concat (sah-build-directory) ".config")))

(defvar sah-config-source-hook nil)

(defun sah-config-source ()
  "Configure the source tree"
  (interactive)
  (make-directory (sah-staging-directory) 1)
  (make-directory (sah-release-directory) 1)
  (message (sah-hardco-file))
  ;; run config source
  (sah-build-exec sah-p4-wijgmaal (sah-workspace-wijgmaal)
                  "configsource"
                  (concat (sah-build-directory) "build.sh")
                  (sah-project-directory) "nosync" "nobuild" "nocleanstaging")
  (run-hooks 'sah-config-source-hook))

(defun sah-parse-info (file)
  "Parse a buildconfig.info"
  (let ((settings '()))
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (while (not (eobp))
        (let ((beg (point)))
          (forward-line 1)
          (forward-char -1)
          (if (string-match ".*=.*" (buffer-substring beg (point)))
              (let ((cl (split-string (buffer-substring beg (point)) "=")))
                (setq settings (cons (cons (car cl) (cadr cl)) settings))))
          (forward-line)))
      settings)))

(defun sah-parse-server-config (file)
  "Parse a server.cfg file and returns the workspaces"
  (let ((workspaces '()))
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (while (not (eobp))
        (let ((beg (point)))
          (forward-line 1)
          (forward-char -1)
          (if (string-match ".*=.*" (buffer-substring beg (point)))
              (let* ((cl (split-string (buffer-substring beg (point)) "="))
                     (wss (split-string (cadr cl) "/")))
                (message "%s %s" cl wss)
                (setq workspaces (cons (cons (car cl) (cadr wss)) workspaces))))
          (forward-line)))
      workspaces)))

(defun sah-project-components ()
  "Return the list of components for the current project"
  (if sah-project
      (let ((components '()))
        (with-temp-buffer
          (insert-file-contents (sah-component-list))
          (goto-char (point-min))
          (while (not (eobp))
            (let ((beg (point)))
              (forward-line 1)
              (forward-char -1)
              (if (string-match ".*=.*" (buffer-substring beg (point)))
                  (let ((cl (split-string (buffer-substring beg (point)) "=")))
                    (setq components (cons (car cl) components)))))
            (forward-line)))
        components)))

(defun sah-project-component-branches ()
  "Return the list of components branches for the current project"
  (if sah-project
      (let ((components '()))
        (with-temp-buffer
          (insert-file-contents (sah-build-dep))
          (goto-char (point-min))
          (while (not (eobp))
            (let ((beg (point)))
              (forward-line 1)
              (forward-char -1)
              (let ((cl (split-string (buffer-substring beg (point)) "=")))
                (setq components (cons (cons (car cl) (cadr cl)) components))))
            (forward-line)))
        components)))

(defun sah-project-component-directories ()
  "Return the list of components directories for the current project"
  (if sah-project
      (let ((components '()))
        (with-temp-buffer
          (insert-file-contents (sah-build-config))
          (goto-char (point-min))
          (while (not (eobp))
            (let ((beg (point)))
              (forward-line 1)
              (forward-char -1)
              (let ((cl (split-string (buffer-substring beg (point)) "=")))
                (setq components (cons (cons (downcase (car cl)) (file-name-as-directory (cadr cl))) components))))
            (forward-line)))
        components)))

(defun sah-project-component-paths ()
  "Return the list of Perforce path for each component"
  (if sah-project
      (let ((components '()))
        (with-temp-buffer
          (insert-file-contents (sah-component-list))
          (goto-char (point-min))
          (while (not (eobp))
            (let ((beg (point)))
              (forward-line 1)
              (forward-char -1)
              (if (string-match ".*=.*" (buffer-substring beg (point)))
                  (let* ((cl (split-string (buffer-substring beg (point)) "=")))
                    (setq components (cons (cons (car cl) (file-name-as-directory (cadr cl))) components)))))
            (forward-line)))
        components)))
(defun sah-project-component-directory (component)
  "Return the directory for a component"
  (let ((cdef (assoc component (sah-project-component-directories))))
    (if cdef
        (file-name-as-directory (cdr cdef))
      nil)))
      

(defvar sah-releases-history () "The history for release tags")

(defun sah-read-release ()
  "Read a release number from the minibuffer prompt and get the corresponding release"
  (let* ((releases (sah-config-releases))
         (default-release-tag (car (car releases)))
         (release-tags (mapcar 'car releases)))
    (assoc (ido-completing-read (concat "Release (" default-release-tag "): ") release-tags nil 1 nil 'sah-releases-history default-release-tag) releases)))

(defvar sah-config-history () "The history for configs")

(defun sah-read-config ()
  "Read a config path from the minibuffer prompt and get the corresponding release"
  (let* ((configs (sah-config-all)))
    (ido-completing-read (concat "Config: ") configs nil 1 nil 'sah-configs-history nil)))

(defvar sah-projects-history () "The history for projects")

(defun sah-read-project (release)
  "Read a project string from the minibuffer prompt"
  (let ((projects (sah-config-projects (cdr release)))
        (default-project sah-default-config))
    (ido-completing-read (concat "Project (" default-project "): ") projects nil 1 nil 'sah-projects-history default-project)))

(defun sah-read-config-project (config)
  "Read a project string from the minibuffer prompt"
  (let ((projects (sah-config-projects config))
        (default-project sah-default-config))
    (completing-read (concat "Project (" default-project "): ") projects nil 1 nil 'sah-projects-history default-project)))

(defvar sah-builds-history () "The history for builds")

(defun sah-read-build-branch (config project)
  "Read a build branch from the minibuffer prompt"
  (let ((default-build (sah-config-build-branch config project))
        (builds (sah-build-all)))
    (ido-completing-read (concat "Build (" default-build "): ") builds nil 1 nil 'sah-builds-history default-build)))

(defvar sah-wijgmaal-workspaces-history () "The history for Wijgmaal perforce workspaces names")

(defun sah-read-wijgmaal-workspace ()
  "Read a Wijgmaal Perforce workspace name from the minibuffer prompt"
  (let ((workspaces (mapcar 'car (sah-workspaces sah-p4-wijgmaal)))
        (default-workspace sah-p4-wijgmaal-workspace))
    (ido-completing-read (concat "Wijgmaal workspace (" default-workspace "): ") workspaces nil 1 nil 'sah-wijgmaal-workspaces-history default-workspace)))

(defvar sah-nanterre-workspaces-history () "The history for Nanterre perforce workspaces names")

(defun sah-read-nanterre-workspace ()
  "Read a Nanterre Perforce workspace name from the minibuffer prompt"
  (let ((workspaces (mapcar 'car (sah-workspaces sah-p4-nanterre)))
        (default-workspace sah-p4-nanterre-workspace))
    (ido-completing-read (concat "Nanterre workspace (" default-workspace "): ") workspaces nil 1 nil 'sah-nanterre-workspaces-history default-workspace)))

(defvar sah-components-history () "The history for component names")

(defun sah-buffer-component (&optional file)
  "Fetch the component for the current buffer or nil if the current buffer is not editing a file in a component"
  (let ((file-name (or file buffer-file-name))
        (directories (sah-project-component-directories))
        (component))
    (when file-name
      (dolist (dir directories)
        (let ((regexp (concat "^" (regexp-quote (cdr dir)))))
          (if (string-match regexp file-name)
              (setq component (car dir)))))
      component)))

(defun sah-read-component ()
  "Read a component name from the minibuffer"
  (let* ((components (sah-project-components))
         (default-component (sah-buffer-component))
         (prompt (concat "Component" (if default-component (concat " (" default-component ")")) ": ")))
    (ido-completing-read prompt components nil 1 nil 'sah-components-history default-component)))

(defun sah-open-project (release build project wijgmaal-workspace nanterre-workspace)
  "Checkout a release and configure the project"
  (interactive
   (let* ((release (sah-read-release))
          (project (sah-read-project release))
          (build (sah-read-build-branch (cdr release) project))
          (wijgmaal-workspace (sah-read-wijgmaal-workspace))
          (nanterre-workspace (sah-read-nanterre-workspace)))
     (list release build project wijgmaal-workspace nanterre-workspace)))
  ;; sync the release dir
  (setq sah-p4-wijgmaal-workspace wijgmaal-workspace)
  (setq sah-p4-nanterre-workspace nanterre-workspace)
  (setq sah-build-branch build)
  (let* ((config-dir (cdr release))
         (project-dir (concat (cdr (sah-workspace-wijgmaal)) (replace-regexp-in-string "//depot/" "" (concat config-dir "/" project "/")))))
    (message "p4 sync -f %s/...#head" config-dir)
    (sah-p4-exec sah-p4-wijgmaal (sah-workspace-wijgmaal) nil "sync" "-f" (concat config-dir "/...#head"))
    (message "opening project %s" project-dir)
    (sah-set-project project-dir)
    (message "marking project list as +w")
    (set-file-modes (sah-project-list) (logior (file-modes (sah-project-list)) ?\600))
    (sah-mode t)
    (pop-to-buffer (find-file (sah-project-list)))))

(defun sah-open-any-project (config build project wijgmaal-workspace nanterre-workspace)
  "Checkout a release and configure the project"
  (interactive
   (let* ((config (sah-read-config))
          (project (sah-read-config-project config))
          (build (sah-read-build-branch config project))
          (wijgmaal-workspace (sah-read-wijgmaal-workspace))
          (nanterre-workspace (sah-read-nanterre-workspace)))
     (list config build project wijgmaal-workspace nanterre-workspace)))
  ;; sync the release dir
  (setq sah-p4-wijgmaal-workspace wijgmaal-workspace)
  (setq sah-p4-nanterre-workspace nanterre-workspace)
  (setq sah-build-branch build)
  (let* ((config-dir config)
         (project-dir (concat (cdr (sah-workspace-wijgmaal)) (replace-regexp-in-string "//depot/" "" (concat config-dir "/" project)))))
    (message "p4 sync -f %s/...#head" config-dir)
    (sah-p4-exec sah-p4-wijgmaal (sah-workspace-wijgmaal) nil "sync" "-f" (concat config-dir "/...#head"))
    (message "opening project %s" project-dir)
    (sah-set-project project-dir)
    (message "marking project list as +w")
    (set-file-modes (sah-project-list) (logior (file-modes (sah-project-list)) ?\600))
    (sah-mode t)
    (pop-to-buffer (find-file (sah-project-list)))))

(defun sah-reopen-project (build)
  "Reopen a project using the given build directory"
  (interactive
   (let ((default (shell-command-to-string (format "echo -n $(realpath %s/output/..)" (cdr (sah-workspace-wijgmaal)))))
         (directory "~/"))
     (list (read-directory-name "Build dir: " default default))))
  (let* ((build-config (sah-parse-info (format "%s/output/staging/buildconfig.info" build)))
         (server-config (sah-parse-server-config (format "%s/server.cfg" build))))
    (setq sah-p4-wijgmaal-workspace (cdr (assoc "w1" server-config)))
    (setq sah-p4-nanterre-workspace (cdr (assoc "n1" server-config)))
    (message "%s" (format "%s" (cdr (assoc "BUILD_DEF" build-config))))
    (setq sah-build-branch (cdr (assoc "BUILD_VER" build-config)))
    (sah-set-project (format "%s" (cdr (assoc "BUILD_DEF" build-config))))
    (pop-to-buffer (find-file (sah-project-list)))
    (sah-switch-to-wijgmaal)))

(defvar sah-target-history () "The history for make targets")

(defun sah-make (target)
  "Run make in the build directory"
  (interactive
   (list (ido-completing-read "Target (all): " '("all" "components" "image") nil t nil 'targets "all")))
  (message target)
  (sah-make-exec (sah-build-directory) "Makefile" target))

(defun sah-make-component (component)
  "Rebuild the given component"
  (interactive
   (list (sah-read-component)))
  (sah-make-exec (sah-build-directory) "Makefile.components" (concat component "_component")))

(defun sah-make-component-and-deps (component)
  "Rebuild the given component and its dependencies"
  (interactive
   (list (sah-read-component)))
  (sah-make-exec (sah-build-directory) "Makefile.components" component))


(defun sah-visit-component-file (file)
  "Open a file in a component"
  (interactive
   (let* ((component (sah-read-component))
          (directory (file-name-as-directory (cdr (assoc component (sah-project-component-directories)))))
          (default (concat directory "Component.mk")))
     (list (read-file-name "Find file (Component.mk): " directory default))))
  (switch-to-buffer (find-file-noselect file))
  (sah-configure-p4))

(defun sah-path-wijgmaal-p (path)
  "Return t if a path is a Wijgmaal p4 path"
  (string-match "^w1:" path))

(defun sah-toolchain ()
  "Return the current toolchain directory"
  (let ((toolchain))
    (dolist (component-dir (sah-project-component-directories))
      (let ((component (car component-dir))
            (directory (cdr component-dir)))
        (if (string-match "^hardco_.*_toolchain_.*" component)
            (setq toolchain directory))))
    toolchain))

(defun sah-gdb-command ()
  "Return the gdb executable to use for the current project"
  ;;     (concat (sah-toolchain) "bin/mips-linux-uclibc-gdb"))
  "/home/sah5029/Toolchain/bin/mips-linux-uclibc-gdb")

(defun sah-sync-component (component)
  "Rebuild the given component"
  (interactive
   (list (sah-read-component)))
  (let* ((path (cdr (assoc component (sah-project-component-paths))))
         (port (if (sah-path-wijgmaal-p path) sah-p4-wijgmaal sah-p4-nanterre))
         (workspace (if (sah-path-wijgmaal-p path) (sah-workspace-wijgmaal) (sah-workspace-nanterre)))
         (branch (cdr (assoc component (sah-project-component-branches))))
         (p4-path (concat (file-name-as-directory (replace-regexp-in-string "^n1:" "/" (replace-regexp-in-string "^w1:" "//depot" path))) (file-name-as-directory branch) "...#head")))
    (sah-p4-exec port workspace t "sync" "-f" p4-path)))

(defun sah-clean-component (component)
  "Clean the given component"
  (interactive
   (list (sah-read-component)))
  (setenv "STAGINGDIR" (sah-staging-directory))
  (sah-make-exec (cdr (assoc component (sah-project-component-directories))) "Component.mk" "clean"))

(defun sah-clean-all-components ()
  "Clean all components"
  (interactive)
  (dolist (component (sah-project-components))
    (sah-clean-component component)))

(defun sah-open-project-list ()
  "Open the project list file"
  (interactive)
  (pop-to-buffer (find-file (sah-project-list))))

(defun sah-open-component-config ()
  "Open the project list file"
  (interactive)
  (pop-to-buffer (find-file (sah-component-config))))

(defun sah-switch-to-wijgmaal ()
  "Switch to the Wijgmaal workspace"
  (interactive)
  (p4-set-p4-port sah-p4-wijgmaal)
  (p4-set-client-name (car (sah-workspace-wijgmaal))))

(defun sah-switch-to-nanterre ()
  "Switch to the Nanterre workspace"
  (interactive)
  (p4-set-p4-port sah-p4-nanterre)
  (p4-set-client-name (car (sah-workspace-nanterre))))

(defun sah-configure-p4 ()
  "Configure perforce for the current file"
  (interactive)
  (let ((component (sah-buffer-component)))
    (when component
      (let ((path (cdr (assoc component (sah-project-component-paths)))))
        (cond ((and (string= sah-p4-nanterre (p4-get-p4-port)) (sah-path-wijgmaal-p path))
               (sah-switch-to-wijgmaal))
              ((and (string= sah-p4-wijgmaal (p4-get-p4-port)) (not (sah-path-wijgmaal-p path)))
               (sah-switch-to-nanterre)))))))

(defun sah-run-gdb (binary)
  "Run gdb"
  (interactive
   (list (read-file-name "executable: " (concat (sah-staging-directory) "bin/") nil 1)))
  ;; map the /mnt/nfs directory
  (shell-command-to-string (format "mkdir -p %s/mnt" (sah-staging-directory)))
  (shell-command-to-string (format "ln -fs $HOME %s/mnt/nfs" (sah-staging-directory)))
  ;; copy the libc and the uclibc shared libraries
  (shell-command-to-string (format "rm -f %s/lib/ld-uClibc.so.0 %s/libc.so %s/libc.so.0" (sah-staging-directory) (sah-staging-directory) (sah-staging-directory)))
  (shell-command-to-string (format "cp %s/lib/ld-uClibc.so.0 %s/lib/libc.so %s/libc/so.0 %s/lib" (sah-staging-directory) (sah-staging-directory) (sah-staging-directory) (sah-release-directory)))
  (message (concat (sah-gdb-command) " --i=mi " binary))
  (gdb (concat (sah-gdb-command) " --i=mi " binary))
  (switch-to-buffer gud-comint-buffer)
  (gud-call (concat "set solib-absolute-prefix" (sah-staging-directory)))
  (gud-call (concat "set solib-search-path " (sah-release-directory) "root_fs/lib"))
  (gud-call (concat "directory " (sah-workspace-wijgmaal))))

(defvar sah-prefix-key sah-prefix-key-string
  "The common prefix key used in sah mode.")

(defvar sah-prefix-map
  (let ((km (make-sparse-keymap)))
    (define-key km (kbd "l") 'sah-open-project-list)
    (define-key km (kbd "g") 'sah-get-source)
    (define-key km (kbd "c") 'sah-config-source)
    (define-key km (kbd "m") 'sah-make)
    (define-key km (kbd "C-m") 'sah-make-component)
    (define-key km (kbd "C-d") 'sah-make-component-and-deps)
    (define-key km (kbd "C-c") 'sah-clean-component)
    (define-key km (kbd "C-f") 'sah-visit-component-file)
    (define-key km (kbd "C-s") 'sah-sync-component)
    km)
  "The key bindings provided in SAH mode.")

(defvar sah-mode-map
  (let ((km (make-sparse-keymap)))
    (define-key km sah-prefix-key sah-prefix-map)
    km)
  "Keymap to use in tabbar mode")

(define-minor-mode sah-mode
  "Toggle SAH mode.
With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode.

When SAH mode is enabled, the following commands are
defined:

\\{sah-mode-map}

The common usage is to first open a project, then do a get source,
a config source and a make."
  :init-value nil
  :lighter " SAH"
  :keymap sah-mode-map
  :global t
  :require 'sah
  :group 'sah)

(defvar sah-histories '(sah-releases-history
                        sah-projects-history
                        sah-wijgmaal-workspaces-history
                        sah-nanterre-workspaces-history
                        sah-components-history))
(provide 'sah)
