;;; ruby-minitest.el -- Run ruby mimitests

;;; Commentary:

;;

;;; Code:
(require 'ert)
(require 'compile)

(defcustom ruby-minitest-file-match
  "Minitest::Test"
  "Regular expression to match minitest test suite buffer."
  :type 'regexp
  :group 'ruby-minitest)

(defvar ruby-minitest-last-test nil "The last executed test.")

(defvar ruby-minitest-ert-test-content "require 'test_helper'

class MyTest < Minitest::Test
  def test_first_test
    # first test
  end

  def test_second_test
    # second test
  end

  test \"first spec\" do
    # first spec
  end

  test \"second spec\" do
    # second spec
  end
end
")

(defmacro ruby-minitest-with-test-content (content &rest body)
  "Setup a buffer with CONTENT and run BODY in it."
    (declare (indent 1))
    `(save-excursion
       (with-temp-buffer
         (let ((ruby-minitest-file-match "Minitest::Test")
               (buffer-file-name "__fake__"))
           (insert ,content)
           (goto-char (point-min))
           ,@body))))

(defmacro ruby-minitest-with-test-buffer (&rest body)
  "Setup a buffer with our test data and run BODY in it."
    (declare (indent 0))
    `(ruby-minitest-with-test-content ruby-minitest-ert-test-content
       ,@body))

(defun ruby-minitest-buffer-p (buffer)
  "Return t if BUFFER is a minitest test case."
  (save-excursion
    (with-current-buffer buffer
      (goto-char (point-min))
      (re-search-forward ruby-minitest-file-match nil t))))

(ert-deftest ruby-minitest-buffer-p-test ()
  (ruby-minitest-with-test-buffer
    (should (ruby-minitest-buffer-p (current-buffer))))
  (ruby-minitest-with-test-content "require 'test_helper'
class MyTest < OtherTestCase
end
"
    (should-not (ruby-minitest-buffer-p (current-buffer)))))

(defun ruby-minitest-test-at-point ()
  "Return the test at point.

Return a cons cell containing the test name and the test file for
the current buffer point, nil if there are no test."
  (when (ruby-minitest-buffer-p (current-buffer))
    (save-excursion
      (end-of-line)
      (when (re-search-backward "\\(test\\s-+\"\\([^\"]+\\)\"\\|def\\s-+test_\\([0-9a-zA-Z_!]+\\)\\)" nil 't)
        (let ((test-name (or (match-string 2) (match-string 3))))
          (set-text-properties 0 (length test-name) nil test-name)
          (cons (buffer-file-name (current-buffer))
                (concat "test_" (replace-regexp-in-string " " "_" test-name))))))))

(ert-deftest ruby-minitest-test-at-point-test ()
  (ruby-minitest-with-test-buffer
    (search-forward "def test_first_test")
    (should (equal '("__fake__" . "test_first_test")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_first_test")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_first_test")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_first_test")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_second_test")
                   (ruby-minitest-test-at-point)))
    (search-forward "test \"first spec\"")
    (should (equal '("__fake__" . "test_first_spec")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_first_spec")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_first_spec")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_first_spec")
                   (ruby-minitest-test-at-point)))
    (forward-line)
    (should (equal '("__fake__" . "test_second_spec")
                   (ruby-minitest-test-at-point)))))

(defun ruby-minitest-executable (exec path)
  "Return bundle EXEC PATH if a Gemfile is found, EXEC PATH otherwise."
  (if (locate-dominating-file path "Gemfile")
      (format "bundle exec %s" exec)
    exec))

(defun ruby-minitest-run (test)
  "Run TEST using rake.

If TEST is a cons cell, run the test named after (cdr TEST) in
file (car TEST).

If TEST is a string, run all test in file TEST.

If TEST is nil, run all tests.


This function search for a Rakefile in the TEST file name parent directories
and executes rake test with the TEST file and name.

If it does not find a Rakefile, it search instead for a directory containing a
lib subdirectory and uses ruby -Ilib:test to run the test from that directory.

If it does not find nor a Rakefile or a lib directory, it simply
execute the TEST file name with options."
  (let ((test-file (cond ((stringp test) test)
                         ((consp test) (car test))
                         (t ".")))
        (options (cond ((stringp test) nil)
                       ((consp test) (format "--name=%s" (cdr test)))
                       (t nil))))
    (message "%s/%s" test-file options)
    (setq ruby-minitest-last-test test)
    (cond ((locate-dominating-file test-file "Rakefile")
           (compile (format "%s test%s%s"
                            (ruby-minitest-executable "rake" test-file)
                            (if (and test-file (not (string= "." test-file)))
                                (format " TEST=\"%s\"" test-file) "")
                            (if options (format " TESTOPTS=\"%s\"" options) ""))))
          ((locate-dominating-file test-file "lib")
           (let ((default-directory (locate-dominating-file test-file "lib")))
             (compile (format "%s -Ilib:test %s %s"
                              (ruby-minitest-executable "ruby" test-file)
                              test-file options))))
          (t
           (compile (format "%s %s %s"
                            (ruby-minitest-executable "ruby" test-file)
                            test-file options))))))

(defun ruby-minitest-run-test-at-point ()
  "Run the current test case.

This uses `ruby-minitest-run' to run the test at point.

It will also save the test as the last test run."
  (interactive)
  (let ((test (ruby-minitest-test-at-point)))
    (when test
      (ruby-minitest-run test))))

(defun ruby-minitest-run-dwim ()
  "Run the current test case or the last test case."
  (interactive)
  (let ((test (ruby-minitest-test-at-point)))
    (cond (test (ruby-minitest-run test))
          ((ruby-minitest-buffer-p (current-buffer))
           (ruby-minitest-run buffer-file-name))
          (t (ruby-minitest-run ruby-minitest-last-test)))))

(defun ruby-minitest-run-suite ()
  "Run the whole test suite (needs a Rakefile)."
  (interactive)
  (ruby-minitest-run nil))

(with-eval-after-load "compile"
  (add-to-list 'compilation-error-regexp-alist 'ruby-minitest)
  (add-to-list 'compilation-error-regexp-alist-alist
                 '(ruby-minitest "^[a-zA-Z0-9:?#_!]+\\s-+\\[\\([/a-zA-Z0-9_-]+\\.rb\\):\\([0-9]+\\)\\]:$" 1 2)))

(provide 'ruby-minitest)

;;; ruby-minitest.el ends here
