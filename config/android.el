(use-package android
  :load-path "~/.emacs.d/packages/android"
  :custom
  (android-sdk-home "/Users/dam/Development/adt-bundle-mac-x86_64-20140702/sdk")
  (android-ndk-home "/Users/dam/Development/android-ndk")
  (android-ndk-addr2line-find-binary 'vip-ndk-addr2line-find-binary
                                     "Android addr2line binary path."))
