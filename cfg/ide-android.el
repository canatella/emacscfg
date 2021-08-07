(defconst conan-path (format "%s/.conan/data/" (getenv "HOME")))

(use-package pbuf :straight (pbuf :type git :host github :repo "canatella/pbuf-el"))

(use-package android
  :straight (android :type git :host github :repo "canatella/android-el")
  :after (pbuf)
  :custom ;; fmt
  (android-sdk-home
   (concat conan-path "android-sdk/26.1.1/bloomlife/stable/package/3592045486c60d1bd77c3351abdd2379d1980716/"))
  (android-ndk-home
   (concat conan-path
           "android_ndk_installer/r20/bloomlife/stable/package/44fcf6b9a7fb86b2586303e3db40189d3b511830/"))
  (android-adb-path
   (concat conan-path "android-sdk/26.1.1/bloomlife/stable/package/3592045486c60d1bd77c3351abdd2379d1980716/platform-tools/adb")))
