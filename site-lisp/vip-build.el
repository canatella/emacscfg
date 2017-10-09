;;; vip-build.el -- Running vip build system from Emacs

;; Author: Damien Merenne
;; URL: https://github.com/canatella/vip-build-el
;; Created: 2014-02-11
;; Keywords: convenience
;; Package-Requires: ((emacs "24.3") (Dash "2.12"))

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; This package the vip-build system into Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'ert)
(require 'dash)
(require 's)
(require 'dom)
(require 'projectile)
(require 'magit)
(require 'ediff)
(require 'rtags)
(require 'ido)

(defgroup vip-build nil "Veygo Intelligence Platform build system support."
  :group 'convenience)

(defcustom vip-android-abis '("armeabi-v7a")
  "Android abis to build for."
  :group 'vip-build
  :type '(repeat string))

(defcustom vip-ios-abis '("armv7s")
  "IOs abis to build for."
  :group 'vip-build
  :type '(repeat string))

(defcustom vip-ruby-executable "ruby"
  "IOs abis to build for."
  :group 'vip-build
  :type 'string)

(defcustom vip-main-project "app-veygodemo-cordova"
  "Which project do we need to build."
  :group 'vip-build
  :type '(radio (const "app-veygodemo-android")
                (const "app-veygodemo-cordova")))

(defcustom vip-platforms '("local" "all" "ios-armv7" "android-armeabi-v7a")
  "IOs abis to build for."
  :group 'vip-build
  :type '(repeat string))


(defvar vip-last-workspace nil "The last workspace used in an interactive command.")
(defvar vip-last-project nil "The last project used in an interactive command.")

(defvar vip-manifests-cache (make-hash-table) "A cache for loaded manifests.")

(defun vip-workspace-p (directory)
  "True if DIRECTORY is a vip build workspace."
  (file-executable-p (concat (file-name-as-directory directory)
                             "builder/bin/build")))

(ert-deftest vip-workspace-p-test ()
  (should-not (vip-workspace-p "/I/Do/Not/Exist/"))
  (should (vip-workspace-p "~/Desktop/Veygo/vip")))

(defun vip-project-p (directory)
  "True if DIRECTORY is a vip project."
  (and (file-exists-p (concat (file-name-as-directory directory)
                                  "veygo.rb"))
       ;; Exclude builder/lib/veygo.rb
       (not (string-match "/builder/lib" directory))))

(defun vip-manifest-path (workspace)
  "Return the repo manifest for WORKSPACE."
  (format "%s.repo/manifest.xml" workspace))

(ert-deftest vip-manifest-path-test ()
  (should (equal "~/Desktop/Veygo/vip/.repo/manifest.xml"
                 (vip-manifest "~/Desktop/Veygo/vip/"))))

(defun vip-manifest (workspace)
  "Load the manifest for WORKSPACE."
  (or (gethash workspace vip-manifests-cache)
      (puthash workspace (with-temp-buffer
                           (insert-file-contents (vip-manifest-path workspace))
                           (libxml-parse-xml-region (point-min) (point-max)))
               vip-manifests-cache)))

(defun vip-toplevel (&optional directory)
  "Walk up DIRECTORY hierarchy to find one with a builder/bin/build file.

Use `default-directory' if DIRECTORY is nil."
  (let ((workspace
         (locate-dominating-file
          (or directory
              (buffer-file-name)
              default-directory)
          (function vip-workspace-p))))
    (when workspace
      (file-name-as-directory (file-truename workspace)))))

(defun vip-current-workspace ()
    "Return current workspace."
  (vip-toplevel))

(ert-deftest vip-toplevel-test ()
  (should (string= (vip-toplevel "~/Desktop/Veygo/vip/builder/bin/build")
                   "/Users/dam/Desktop/Veygo/vip/")))

(defun vip-read-workspace ()
  "Read a vip workspace name."
  (file-name-as-directory
   (file-truename
    (read-file-name "Vip workspace: " (vip-toplevel)
                    nil t "." (function vip-workspace-p)))))

(defun vip-workspace-name (workspace)
  "Return the name of WORKSPACE."
  (file-name-nondirectory (directory-file-name workspace)))

(ert-deftest vip-workspace-name-test ()
  (should (string= (vip-workspace-name "/foo/bar/workspace/")
                   "workspace")))

(defun vip-build-executable (workspace)
  "Return the build command for WORKSPACE."
  (concat workspace "/builder/bin/build"))

(defun vip-project-names (workspace)
  "Return a list of available projects in WORKSPACE."
  (-filter (lambda (name)
             (vip-project-p (concat workspace name)))
           (append (directory-files workspace)
                   (-map (lambda (d) (concat "vendor/" d))
                         (directory-files (concat workspace "vendor/"))))))

(defun vip-project-source (workspace project)
  "Return the path to the project source for WORKSPACE PROJECT."
  (file-name-as-directory (concat workspace project)))

(defun vip-project-names-manifest (workspace)
  "Return a list of available projects in WORKSPACE manifest."
  (-map (lambda (n) (dom-attr n 'path)) (dom-by-tag (vip-manifest workspace) 'project)))

(defun vip-own-projects (workspace)
  "Return a list of non-vendor project in WORKSPACE."
  (-filter (lambda (s) (not (s-starts-with? "vendor/" s)))
           (vip-project-names-manifest workspace)))

(defun vip-vendor-projects (workspace)
  "Return a list of vendor project in WORKSPACE."
  (-filter (lambda (s) (s-starts-with? "vendor/" s))
           (vip-project-names-manifest workspace)))

(defun vip-current-project (&optional file-name)
  "Return the current project for FILE-NAME or current buffer file."
  (let ((path (locate-dominating-file
               (or file-name (buffer-file-name) default-directory)
               (function vip-project-p))))
    (when path
      (directory-file-name
       (replace-regexp-in-string (regexp-quote (vip-toplevel path)) ""
                                 (file-truename path))))))

(ert-deftest vip-current-project-test ()
  (should
   (string= (vip-current-project"~/Desktop/Veygo/vip/vendor/djinni/CMakeLists.txt")
            "vendor/djinni")))

(defvar vip-project-history '() "History for project completion.")

(defun vip-project-history-last-other (project)
  "Find the first item in `vip-project-history' that is not PROJECT."
  (--first (not (string= project it)) vip-project-history))

(defun vip-read-project (workspace &optional default)
  "Prompt for a project name in WORKSPACE, defaulting to DEFAULT or current project."
  (ido-completing-read "Project: " (vip-project-names-manifest workspace) nil t nil
                       'vip-project-history (or default (vip-current-project))))

(defun vip-target-names ()
  "Return a list of available build targets."
  '("config" "build" "clean" "rtags" "install" "config build install"))

(defun vip-read-target (workspace project)
  "Prompt for a target name in WORKSPACE PROJECT."
  (ido-completing-read "Target: " (vip-target-names) nil t "build"))

(defun vip-fetch-workspace (&optional ask)
  "Fetch a workspace, prompting if ASK is not nil."
  (let ((workspace (or (and (not ask)
                            (or (vip-toplevel) vip-last-workspace))
                       (vip-read-workspace))))
    (when workspace
      (setq vip-last-workspace workspace))
    workspace))

(defun vip-fetch-project (workspace &optional default ask)
  "Fetch a project in WORKSPACE, defaulting to DEFAULT or current project.

Prompt if ASK is not nil."
  (let ((project (or (and (not ask) default)
                     (vip-read-project workspace default))))
    (when project
      (setq vip-last-project project))
    project))

(defun vip-fetch-target (workspace project)
  "Fetch a target in WORKSPACE for PROJECT."
  (or (and (not current-prefix-arg) "config build install")
      (vip-read-target workspace project)))

(defun vip-build-parameters (&optional ask)
  "Fetch build parameters, prompting if ASK is not nil.

Return a list with a workspace, a project and a target."
  (let* ((workspace (vip-fetch-workspace))
         (project (vip-fetch-project workspace vip-main-project ask))
         (target (vip-fetch-target workspace project)))
    (list workspace project target)))

(defun vip-target-parameters ()
  "Fetch target shortcut parameters.

Return a list with a workspace and a project."
  (let* ((workspace (vip-fetch-workspace))
         (project (vip-fetch-project workspace vip-main-project)))
    (list workspace project)))

(defun vip-build-command (workspace project target &optional no-dep no-device from modified local)
  "Return vip build command for WORKSPACE PROJECT TARGET.

If NO-DEP is not nil, do not build dependencies.
If NO-DEVICE is not nil, build for configured architectures.
FROM can be set to a project, it will build FROM with all reverse dependencies
until PROJECT.
If MODIFIED is not nil, rebuild only modifed projects.
If LOCAL is not nil, build for host."
  (let ((android-abis (s-join "," vip-android-abis))
        (ios-abis (s-join "," vip-ios-abis)))
    (format "%s %s -d %s %s %s %s %s %s %s %s %s"
            vip-ruby-executable
            (vip-build-executable workspace)
            (if (and no-device (not local)) (concat "--android-abis=" android-abis) "")
            (if (and no-device (not local)) (concat "--ios-abis=" ios-abis) "")
            (if no-dep "-1" "")
            (if no-device "" "--device")
            (if from (format "-f %s" from) "")
            (if modified "-m" "")
            (if local "-l" "")
            project target)))

(defun vip-compile (workspace command)
  "In WORKSPACE run compile COMMAND."
  (let ((default-directory workspace))
    (compile command)))

(defun vip-build (workspace project target &optional no-dep no-device from modified local)
  "Run vip builder in WORKSPACE for PROJECT TARGET.

If NO-DEP is not nil, do not build dependencies.
If NO-DEVICE is not nil, build only for configured architecture.
FROM can be set to a project, it will build FROM with all reverse dependencies
until PROJECT.
If MODIFIED is not nil, rebuild only modifed projects.
If LOCAL is not nl, build for local host."
  (interactive (vip-build-parameters))
  (let ((command (vip-build-command workspace project target no-dep no-device from modified local)))
    (vip-compile workspace command)))

(defun vip-build-no-dep (workspace project target)
  "Run vip builder in WORKSPACE for PROJECT TARGET."
  (interactive (vip-build-parameters current-prefix-arg))
  (let ((command (vip-build-command workspace project target t)))
    (compile command)))

(defun vip-build-modified (workspace project target)
  "Run vip builder in WORKSPACE for PROJECT TARGET, rebuilding only modified projects."
  (interactive (vip-build-parameters current-prefix-arg))
  (let ((command (vip-build-command workspace project target nil nil nil t)))
    (vip-compile workspace command)))

(defun vip-build-test (workspace project &optional test)
  "Run unit-tests in WORKSPACE for PROJECT, rebuilding only modified projects.

If TEST it not nil, it should be a list of test description to
match the test to run."
  (interactive
   (let* ((workspace (vip-fetch-workspace))
           (project (vip-fetch-project workspace (vip-current-project))))
        (list workspace project)))
  (let* ((test-binary (vip-staging-file
                      workspace (format "bin/%s-test" project) "local"))
         (test-command (format "%s --reporter=info %s" test-binary
                               (s-join "" (--map (format " --only=\"%s\"" it)
                                                 test))))
         (compile-command (vip-build-command workspace project "config build install" nil t nil t t)))
    (vip-compile workspace (format "%s && %s" compile-command test-command))))

(defun vip-install (workspace project)
  "Run vip builder config target in WORKSPACE for PROJECT."
  (interactive (vip-target-parameters))
  (vip-build workspace project "install"))

(defun vip-rtags (workspace project)
  "Run vip builder config target in WORKSPACE for PROJECT."
  (interactive (vip-target-parameters))
  (vip-build workspace project "rtags"))

(defun vip-clean (workspace project)
  "Run vip builder config target in WORKSPACE for PROJECT."
  (interactive (vip-target-parameters))
  (vip-build workspace project "clean"))

(defun vip-build-setup (workspace)
  "Setup build directory in WORKSPACE."
  (start-process-shell-command "vip-build" "*Messages*"
                               (vip-build-command workspace "builder" "config")))

(defun vip-rdm-config-file (workspace)
  "Return the name of the rtags rdm config file for current WORKSPACE."
  (let ((config (format "%sbuild/debug/all/tools/rdm/rdm.rc" workspace)))
    (unless (file-exists-p config)
      (vip-build-setup workspace))
    config))

(ert-deftest vip-rdm-config-file-test ()
  (should
   (string= (vip-rdm-config-file
             (vip-toplevel "~/Desktop/Veygo/vip/builder/bin/build"))
            "/Users/dam/Desktop/Veygo/vip/build/debug/all/tools/rdm/rdm.rc")))

(defun vip-rdm-maybe-start (workspace)
  "Start the rtags rdm daemon for vip WORKSPACE if its not running."
  (interactive (list (vip-fetch-workspace)))
  (let* ((config (vip-rdm-config-file workspace))
         (rtags-process-flags (format "--config \"%s\"" config)))
    (rtags-start-process-unless-running)))

(defun vip-file (path)
  "Return a file PATH relative to the vip root."
  (concat (vip-toplevel) path))

(defun vip-staging-file (workspace path &optional platform)
  "Return the path for the file in the build directory of WORKSPACE at PATH.

If PLATFORM is not nil, return the path for platform, other return the path for all."
  (concat workspace "build/debug/" (or platform "all") "/" path))

(defun vip-project-build (workspace project &optional platform)
  "Return the build directory for WORKSPACE PROJECT.

If PLATFORM is not nil, return the path for platform, other return the path for all."
  (file-name-as-directory (vip-staging-file workspace (concat "projects/" project) platform)))

(defun vip-project-build-file (workspace project path &optional platform)
  "Return the path for the file in WORKSPACE PROJECT at PATH.

If PLATFORM is not nil, return the path for platform, other return the path for all."
  (concat (vip-project-build workspace project platform) path))

(defun vip-project-build-find-file (workspace project path &optional platforms)
  "Find the path for the file in WORKSPACE PROJECT at PATH.

Look into PLATFORMS or `vip-platforms' if it is nil, look into vip-platforms."
  (seq-find #'file-exists-p
            (seq-map (lambda (platform)
                       (concat (vip-project-build workspace project platform) path))
                     (or platforms vip-platforms))))

(defun vip-config-file (workspace name)
  "Return the path for a config file in WORKSPACE named NAME."
  (concat (vip-staging-file workspace "tools/config/") name))

(defun vip-kconfig (workspace)
  "Return the kconfig file for WORKSPACE."
  (vip-config-file workspace "kconfig"))

(defun vip-find-kconfig (&optional workspace)
  "Visit the kconfig file for WORKSPACE."
  (interactive (list (vip-fetch-workspace)))
  (find-file (vip-kconfig workspace)))

(defun vip-config (workspace)
  "Load the vip configuration in WORKSPACE."
  (with-temp-buffer
    (insert-file-contents (vip-config-file workspace "kconfig.el"))
    (eval (car (read-from-string (buffer-string))))))

(defun vip-feature (workspace name)
  "Fetch feature in WORKSPACE with symbol NAME from configuration."
  (alist-get name (vip-config workspace)))

(defun vip-platforms (workspace)
  "List of enabled platforms in WORKSPACE."
  (let ((re "^config-enable-\\(android\\|ios\\)-abi-\\(.*\\)$"))
    (-map (lambda (e)
            (if (string-match re e)
                (concat (match-string 1 e) "-" (match-string 2 e))))
          (-filter (lambda (e) (string-match-p re e))
                   (-map (lambda (e) (symbol-name (car e))) (vip-config workspace))))))

(defun vip-read-platform (workspace)
  "Prompt for a platform in WORKSPACE."
  (ido-completing-read "Platform: " (vip-platforms workspace) nil t nil nil "all"))

(defmacro vip-with-project (workspace project &rest body)
  "Go into WORKSPACE PROJECT directory and evaluate BODY like nprog."
  (declare (indent 2) (debug t))
  `(save-excursion
    (with-temp-buffer
      (let* ((default-directory (vip-project-source ,workspace ,project))
             (projectile-project-root default-directory)
             (projectile-require-project-root t))
        (when (file-exists-p default-directory)
          ,@body)))))

(defun vip-project-djinni-platform-files (workspace project platform)
  "Return a list of files djinni generated files for WORKSPACE PROJECT PLATFORM."
  (let ((djinni-out (vip-project-build-file workspace project "djinni.out" platform)))
    (when (file-exists-p djinni-out)
      (with-temp-buffer
        (insert-file-contents djinni-out)
        (goto-char (point-max))
        (-unfold (lambda (x) (let ((f (s-chomp (thing-at-point 'line t)))
                                   (l (forward-line -1)))
                               (if (equal -1 l) nil (cons f t)))) t)))))

(defun vip-project-djinni-files (workspace project)
  "Return a list of files djinni generated files for WORKSPACE PROJECT."
  (-mapcat (lambda (platform) (vip-project-djinni-platform-files workspace project platform))
           (vip-platforms workspace)))

(defun vip-project-source-files (workspace project)
  "Fetch available source files in WORKSPACE PROJECT."
  (-map (lambda (f) (concat (vip-project-source workspace project) f))
        (vip-with-project workspace project
          (projectile-current-project-files))))

(defun vip-project-files (workspace project)
  "Fetch source and djinni generated files in WORKSPACE PROJECT."
  (-concat (vip-project-source-files workspace project)
           (vip-project-djinni-files workspace project)))

(defun vip-all-projects-files (workspace)
  "Fetch all available files in all of WORKSPACE projects."
  (-mapcat (lambda (project) (vip-project-files workspace project))
           (vip-project-names-manifest workspace)))

(defun vip-own-projects-files (workspace)
  "Fetch all available files in all of WORKSPACE projects."
  (-mapcat (lambda (project) (vip-project-files workspace project))
           (vip-own-projects workspace)))

(defun vip-replace-path-for-display (old-path replacement s)
  "Replace OLD-PATH with REPLACEMENT in S and use it as a display property for S."
  (if (s-matches? old-path s)
      (propertize s 'display (replace-regexp-in-string old-path replacement s))
    nil))

(defun vip-prepare-path-for-display (workspace project path)
  "Cleanup WORKSPACE and PROJECT in PATH."
  (let ((djinni-path (format "%sbuild/debug/[^/]+/projects/%s/djinni" workspace project))
        (project-path (concat workspace project)))
    (or (vip-replace-path-for-display djinni-path "ⓓ" path)
        (vip-replace-path-for-display project-path "ⓟ" path))))

(defun vip-prepare-paths-for-display (workspace project paths)
  "Cleanup WORKSPACE and PROJECT path in PATHS for display."
  (-map (lambda (e)
          (vip-prepare-path-for-display workspace project e))
        paths))

(defvar vip-project-file-history-hash (make-hash-table :test #'equal
                                                       :size 20)
  "Last file visited per project.")

(defun vip-project-file-history (workspace project)
  "Fetch file history for WORKSPACE PROJECT."
  (gethash (concat workspace project) vip-project-file-history-hash))

(defun vip-project-file-add-to-history  (workspace project newelt)
  "Add WORKSPACE PROJECT NEWELT to project history."
  (let* ((history (vip-project-file-history workspace project))
         (new (add-to-history 'history newelt)))
    (puthash (concat workspace project) new
             vip-project-file-history-hash)))

(defun vip-read-project-file-fallback (arg)
  "Fallback on `find-file', forwarding ARG."
  (interactive "P")
  (let ((ido-cur-item 'file))
    (ido-magic-forward-char arg)))

(defun vip-read-project-file-ido ()
  "Setup ido when reading a project file."
  (define-key ido-completion-map (kbd "C-f") #'vip-read-project-file-fallback))

(defun vip-read-project-file (workspace project &optional default)
  "Prompt for a file in WORKSPACE PROJECT.

Prompt with project DEFAULT if not nil."
  (let* ((default-directory (concat workspace project))
         (files (vip-prepare-paths-for-display
                workspace project (vip-project-files workspace project)))
         (history (vip-project-file-history workspace project))
         (history-add-new-input nil)
         (def (or default (car history)))
         (ido-setup-hook #'vip-read-project-file-ido)
         (file (ido-completing-read "Find file: " files nil t nil 'history def)))
    (if (eq ido-exit 'fallback)
        (ido-find-file)
      (vip-project-file-add-to-history workspace project file)
      file)))

(defun vip-find-file (workspace project file)
  "Visit WORKSPACE PROJECT FILE."
  (interactive
   (let* ((workspace (vip-current-workspace))
          (project (vip-fetch-project workspace (vip-current-project)))
          (file (vip-read-project-file workspace project)))
     (list workspace project file)))
  (find-file file))

(defun vip-find-other-project-file (workspace project file)
  "Visit WORKSPACE PROJECT FILE."
  (interactive
   (let* ((workspace (vip-current-workspace))
          (current (vip-current-project))
          (last (vip-project-history-last-other current))
          (project (vip-fetch-project workspace last t))
          (file (vip-read-project-file workspace project)))
     (list workspace project file)))
  (find-file file))

(defun vip-read-own-file (workspace)
  "Prompt for a file in WORKSPACE PROJECT."
  (ido-completing-read "File: " (vip-own-projects-files workspace)))


(defun vip-find-own-file (workspace file)
  "Visit WORKSPACE FILE."
  (interactive
   (let* ((workspace (vip-fetch-workspace))
          (file (vip-read-own-file workspace)))
     (list workspace file)))
  (find-file file))

(defun vip-maybe-find-file (&optional ask)
  "Open a file in project or workspace.  Ask for project if ASK is t."
  (interactive "P")
  (cond (ask
         (call-interactively #'vip-find-other-project-file))
        ((vip-current-project)
         (call-interactively #'vip-find-file))
        ((vip-current-workspace)
         (call-interactively #'vip-find-own-file))
        ((projectile-project-p)
         (call-interactively #'projectile-find-file))
        (t (call-interactively #'find-file))))

(defun vip-maybe-find-own-file ()
  "Try to find file in vip project or workspace or git."
  (interactive)
  (cond ((vip-current-workspace)
         (call-interactively 'vip-find-own-file))
        ((projectile-project-p)
         (call-interactively 'projectile-find-file))
        (t (call-interactively 'find-file))))

(defun vip-touch-component (workspace project)
  "Make sure WORKSPACE PROJECT is rebuild on next build."
  (interactive (let* ((workspace (vip-current-workspace))
                      (project (vip-read-project (vip-current-workspace))))
                 (list workspace project)))
  (let ((file (format "%sbuild/.%s.modified" workspace
                      (replace-regexp-in-string "/" "!" project))))
    (write-region "" nil file nil nil)))

(defun vip-save-hook ()
  "Mark current project as modified."
  (let ((workspace (vip-current-workspace))
        (project (vip-current-project)))
    (when project
      (vip-touch-component workspace project))))

(defun vip-maybe-turn-on-vip-build-mode ()
  "Enable `vip-build-minor-mode' if the visited file is in a vip workspace."
  (when (vip-toplevel)
    (vip-build-minor-mode t)))

(defvar vip-build-minor-mode-map nil "Keymap for vip-build-mode.")
(when (not vip-build-minor-mode-map)
  (setq vip-build-minor-mode-map (make-sparse-keymap))
  (define-key vip-build-minor-mode-map (kbd "<f10>") #'vip-build-modified)
  (define-key vip-build-minor-mode-map (kbd "H-<f10>") #'vip-build)
  (define-key vip-build-minor-mode-map (kbd "H-t") #'vip-build-test-dwim))

(defun vip-build-setup-compilation ()
  "Setup the compilation buffer if it is a vip buffer."
  (interactive)
  (when (vip-toplevel)
    (vip-build-minor-mode t)
    (setq-local compilation-error-regexp-alist '(vip bandit xcpretty))))

(define-minor-mode vip-build-minor-mode
  "Toggle vip build mode.

Interactively with no argument, this command toggles the mode.
A positive prefix argument enables the mode, any other prefix
argument disables it.  From Lisp, argument omitted or nil enables
the mode, `toggle' toggles the state."
  :init-value nil
  :lighter "ⓥ"
  :keymap vip-build-minor-mode-map
  :group 'vip-build
  (let ((workspace (vip-current-workspace)))
    (setq rtags-socket-file (vip-staging-file workspace "tools/rdm/.rdm.file"))
    (vip-rdm-maybe-start workspace)
    (add-hook 'after-save-hook 'vip-save-hook)))

(define-minor-mode vip-build-global-mode
  "Toggle vip build mode for files belonging to a vip workspace."
  :init-value nil
  :lighter nil
  :group 'vip-build
  :global t
  (add-hook 'find-file-hook 'vip-maybe-turn-on-vip-build-mode)
  (add-hook 'compilation-mode-hook 'vip-build-setup-compilation))

(defmacro vip-with-manifests (workspace &rest body)
  "Go into WORKSPACE manifests directory and evaluate BODY like nprog."
  (declare (indent 1) (debug t))
  `(let ((default-directory (concat ,workspace ".repo/manifests/")))
     ,@body))

(defun vip-build-last-release (workspace extension)
  "Fetch the last release file version for WORKSPACE with file EXTENSION."
  (let* ((project (vip-feature workspace 'config-vip-project))
         (pattern (format "%s-\\([.0-9]+\\)\\.%s$" project extension))
         (files (vip-with-manifests workspace (magit-revision-files "HEAD")))
         (kconfigs (-map (lambda (f) (-last-item (s-match pattern f))) files)))
    (-last-item (-sort 'version< (--filter it kconfigs)))))

(defvar vip-ediff-release-last-window-configuration nil
  "Save window configuration while ediffing.")

(defun vip-ediff-release-before-setup ()
  "Save window configuration before ediff messes with it."
  (setq vip-ediff-release-last-window-configuration
        (current-window-configuration)))

(defun vip-ediff-release-cleanup ()
  "Save release buffer and refresh magit."
  (with-current-buffer ediff-buffer-B
    (save-current-buffer)
    (magit-refresh))
  (ediff-janitor nil nil))

(defun vip-ediff-release-quit ()
  "Restore windows configuration."
  (set-window-configuration vip-ediff-release-last-window-configuration))

(defun vip-ediff-release-startup ()
  "Setup release buffer."
  (add-hook 'ediff-cleanup-hook #'vip-ediff-release-cleanup t t)
  (add-hook 'ediff-quit-hook #'vip-ediff-release-quit t t)
  (add-hook 'ediff-suspend-hook #'vip-ediff-release-quit t t)
  (with-current-buffer ediff-buffer-A
    (read-only-mode t))
  (with-current-buffer ediff-buffer-B
    (setq-local buffer-save-without-query t)))

(defun vip-ediff-release (file)
  "Diff the current FILE against previous release."
  (interactive (list (magit-file-at-point)))
  (let* ((extension (file-name-extension file))
         (workspace (vip-current-workspace))
         (project (vip-feature workspace 'config-vip-project))
         (old-release (vip-build-last-release workspace extension))
         (old-file (format "%s.repo/manifests/%s-%s.%s"
                           workspace project old-release extension))
         (ediff-before-setup-hook #'vip-ediff-release-before-setup)
         (ediff-startup-hook #'vip-ediff-release-startup))
    (ediff-files old-file file)))

(defun vip-magit-ediff-dwim ()
  "Run `vip-ediff-release' on release file."
  (interactive)
  (let* ((file (magit-file-at-point))
         (workspace (vip-current-workspace))
         (project (and workspace (vip-feature workspace 'config-vip-project)))
         (pattern (format "^%s-\\([.0-9]+\\)\\.\\(kconfig\\|xml\\)$" project)))

    (if (and project (s-matches? pattern file))
        (vip-ediff-release file)
      (call-interactively 'magit-ediff-dwim))))

(defun vip-project-compile-commands-file (workspace project)
  "Fetch a build file for WORKSPACE PROJECT."
  (vip-project-build-find-file workspace project "compile_commands.json"))

(defvar vip-bandit-last-test nil "The last executed test.")

(defun vip-bandit-buffer-p (buffer)
  "Return t if BUFFER contain is a bandit test case."
  (save-excursion
    (with-current-buffer buffer
      (goto-char (point-min))
      (re-search-forward "^go_bandit(" nil t))))

(defun vip-bandit-previous-description (indent)
  "Find the previous bandit description with inferior INDENT."
  (when (re-search-backward
         "^\\([[:space:]]+\\)\\(describe\\|it\\)(\"\\(.*?\\)\"," nil 't)
    (let ((i (length (match-string 1)))
          (descr (substring-no-properties (match-string 3))))
      (if (< i indent)
          (cons descr i)
        (vip-bandit-previous-description indent)))))

(defun vip-bandit-test-at-point ()
  "Return a list where the car is the test file, and the cdr is the spec hierarchy."
  (when (vip-bandit-buffer-p (current-buffer))
    (save-excursion
      (end-of-line)
      (let ((test (reverse (-unfold #'vip-bandit-previous-description 1000))))
        (prog1 test
          (setq vip-bandit-last-test test))))))

(defun vip-build-test-dwim (workspace project)
  "Run current test at point or whole test suite for WORKSPACE PROJECT."
  (interactive
   (let* ((workspace (vip-fetch-workspace))
          (project (vip-fetch-project workspace (vip-current-project))))
     (list workspace project)))
  (vip-build-test workspace project
                  (or (vip-bandit-test-at-point) vip-bandit-last-test)))

(with-eval-after-load 'magit-mode
  (define-key magit-mode-map "e" #'vip-magit-ediff-dwim))

(with-eval-after-load "compile"
  (add-to-list 'compilation-error-regexp-alist-alist
               '(vip "^\\s-*\\(\\([[:alnum:]/_.-]+\\):\\([0-9]+\\):\\([0-9]+\\)\\): \\(\\(fatal \\)?error\\|\\(warning\\)\\|\\(note\\)\\):" 2 3 4 (9 . 10) 1))
  (add-to-list 'compilation-error-regexp-alist-alist
               '(bandit "^\\s-*\\(\\([[:alnum:]/_.-]+\\):\\([0-9]+\\)\\): Expected" 2 3 nil nil 1))
  (add-to-list 'compilation-error-regexp-alist-alist
               '(xcpretty "^ *\\[x\\] \\(\\([[:alnum:]/_.-]+\\):\\([0-9]+\\):\\([0-9]+\\)\\):" 2 3 4 nil 1)))

;(setq compilation-error-regexp-alist-alist (-remove (lambda (e) (or (equal (car e) 'bandit) (equal (car e) 'vip) (equal (car e) 'xcpretty))) compilation-error-regexp-alist-alist))

(provide 'vip-build)

;;; vip-build.el ends here
