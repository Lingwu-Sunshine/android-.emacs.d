;; Early initialization.

;;(push '(scroll-bar-mode . nil) default-frame-alist)
;;(push '(tool-bar-mode . nil) default-frame-alist)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)


;; Defines environments
(defconst ANDROID-P (string-equal system-type "android"))

(defconst WORKDESKTOP-P (string-equal (system-name) "WorkLaptop"))
(defconst HOMEDESKTOP-P (string-equal (system-name) "marek-linux"))

(defconst DESKTOP-P (or WORKDESKTOP-P HOMEDESKTOP-P))

;; Defines conditions at which to initialize which modules.
(defconst LSP-JAVA-P WORKDESKTOP-P)
(defconst LSP-RUST-P HOMEDESKTOP-P)
(defconst LSP-P (or LSP-JAVA-P LSP-RUST-P))




;;Defer garbage collection further back in the startup process
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))


;; Package initialize occurs automatically
;; loaded, but after 'early-init-file'. We handle package
;; initialization, so we must prevent Emacs from doing it early!
(setq package-enable-at-startup nil)

(when (string-equal system-type "android")
  ;; Add Termux binaries to Path environment
  (let ((termuxpath "/data/data/com.termux/files/usr/bin"))
    (setenv "PATH" (concat (getenv "PATH") ":" termuxpath))
    (setq exec-path (append exec-path (list termuxpath)))
    )
  )
