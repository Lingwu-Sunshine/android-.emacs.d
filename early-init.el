;; Early initialization.

;; Defines environments
(defconst ANDROID-P (string-equal system-type "android"))

(defconst WORKDESKTOP-P (string-equal (system-name) "WorkLaptop"))
(defconst HOMEDESKTOP-P (string-equal (system-name) "marek-linux"))

(defconst DESKTOP-P (or WORKDESKTOP-P HOMEDESKTOP-P))

;; Defines conditions at which to initialize which modules.
(defconst LSP-JAVA-P WORKDESKTOP-P)
(defconst LSP-RUST-P HOMEDESKTOP-P)
(defconst LSP-P (or LSP-JAVA-P LSP-RUST-P))

(when (string-equal system-type "android")
  ;; Add Termux binaries to Path environment
  (let ((termuxpath "/data/data/com.termux/files/usr/bin"))
    (setenv "PATH" (concat (getenv "PATH") ":" termuxpath))
    (setq exec-path (append exec-path (list termuxpath)))
    )
  )
