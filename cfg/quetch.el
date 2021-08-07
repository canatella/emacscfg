;;; quetch.el --  -*- lexical-binding: t; -*-

;; Copyright (C) 2021 Damien Merenne <dam@cosinux.org>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defvar kaleidoscope-focus-timer nil "kaleidoscope focus command timer")

(defvar kaleidoscope-focus-process nil "kaleidoscope focus serial process")

(defvar kaleidoscope-focus-reply "" "kaleidoscope focus reply data")

(defvar kaleidoscope-focus-cursor-color (face-background 'cursor nil t))

(set-cursor-color "#8d9fa1")
(defun kaleidoscope-focus-handle-reply (reply)
  "Handle a focus REPLY."
  (when reply
    (if (not (string-match "^1.*1" reply))
        (set-cursor-color "#8d9fa1")
      (set-cursor-color "#ff0000"))))

(defun kaleidoscope-focus-filter (proc string)
  "Convert replies to events."
  (setq kaleidoscope-focus-reply (concat kaleidoscope-focus-reply string))
  (while (and kaleidoscope-focus-reply
              (string-match "^ *# \\([^\n]*\\)\n\\(.*\\)" kaleidoscope-focus-reply))
    (kaleidoscope-focus-handle-reply (match-string 1 kaleidoscope-focus-reply))
    (setq kaleidoscope-focus-reply (match-string 2 kaleidoscope-focus-reply))))

(defun kaleidoscope-focus-poll ()
  "Ask for current layer."
  (process-send-string kaleidoscope-focus-process "layer.state\n"))

(defun kaleidoscope-focus-start ()
  "Poll keyboard for events"
  (let ((port "/dev/serial/by-id/usb-DM_Quetch_quetchD-if00"))
    (setq
     kaleidoscope-focus-process
     (make-serial-process :port port :speed 9600 :name "kaleidoscope-focus" :filter #'kaleidoscope-focus-filter))))

(defun kaleidoscope-focus-stop ()
  "Stop polling keyboard."
  (delete-process kaleidoscope-focus-process)
  (kill-buffer (process-buffer kaleidoscope-focus-process)))

(set-face-background 'pulse-highlight-face
		     (if face
			 (face-background face nil t)
		       (face-background 'pulse-highlight-start-face)))

(custom-reevaluate-setting 'cursor)
(kaleidoscope-focus-start)
(kaleidoscope-focus-stop)
(provide 'quetch)

;;; quetch.el ends here
