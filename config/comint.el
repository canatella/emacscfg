(use-package comint
  :custom
  (comint-buffer-maximum-size 10000 "Increase make comint buffer size.")
  (comint-prompt-read-only t "The prompt is read only.")
  (comint-scroll-to-bottom-on-input t "Scroll all buffer window.")
  (comint-scroll-show-maximum-output t "Point to end after insertion.")
  (comint-move-point-for-output t "Move point after output."))
