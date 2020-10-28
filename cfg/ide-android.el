(defconst conan-path (format "%s/.conan/data/" (getenv "HOME")))

(use-package-local pbuf)

(use-package android
  :after (pbuf)
  :custom ;; fmt
  (android-sdk-home
   (concat conan-path "android-sdk/26.1.1/bloomlife/stable/package/8872e4c7fdd7a5876645d1735ac6e7efaac3e0e3/"))
  (android-ndk-home
   (concat conan-path
           "android_ndk_installer/r20/bloomlife/stable/package/743cf0321be3152777da4d05247a66d1552e70a2/")))
