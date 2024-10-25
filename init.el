(require 'package)
;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("ustc-melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/") t)
(package-initialize)


(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'init-font)
(+evan/set-fonts)
;;(require 'init-font)



(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file) ;;
  (write-region "" nil custom-file));;
(load-file custom-file)

(use-package consult
  :ensure t
  :bind ("C-s" . consult-line)
  )

(use-package vertico
  :ensure t
  :init
  (vertico-mode t)
  :config
  (setq vertico-resize nil
	vertico-count 10
	vertico-cycle t)
  )

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic partial-completion)
	completion-category-defaults nil
	completion-category-overrides
	'((file (
		 styles
		 basic
		 partial-completion
		 ))))
  )

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))


(use-package ace-window
  :ensure t
  :bind ("C-x o" . ace-window))


(use-package pyim
  :ensure t
  :config
  (setq default-input-method "pyim")

  (use-package pyim-wbdict
  :ensure t
  :after pyim
  :config
  (pyim-default-scheme 'wubi)
  (pyim-wbdict-v86-enable))
;;  (pyim-isearch-mode 1)
  )


(use-package dirvish
  :ensure t
;;  :defer 8
  :init
  (dirvish-override-dired-mode)
  :hook (dirvish-side-follow-mode . (lambda () (display-line-numbers-mode -1)))
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("m" "/mnt/"                       "Drives")
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  :config



  ;; Placement
  (setq dirvish-use-header-line nil) ; hide header line (show the classic dired header)
  (setq dirvish-use-mode-line nil)   ; hide mode line
  ;; (setq dirvish-use-header-line 'global) ; make header line span all panes

  ;; Height
;;; '(25 . 35) means
;;;   - height in single window sessions is 25
;;;   - height in full-frame sessions is 35
  ;; (setq dirvish-header-line-height '(2 . 2))
  ;; (setq dirvish-mode-line-height 2)	; shorthand for '(25 . 25)

  ;; Segments
;;; 1. the order of segments *matters* here
;;; 2. it's ok to place raw string inside
  ;; (setq dirvish-header-line-format
  ;;       '(:left (path) :right (free-space))
  ;;       dirvish-mode-line-format
  ;;       '(:left (sort file-time " " file-size symlink) :right (omit yank index)))


  (dirvish-peek-mode)			; Preview files in minibuffer

  ;; 每个entry可显示的属性
;;(setq dirvish-attributes
  ;;    '(file-time
;;	file-size))


  (setq dirvish-attributes
         ;;'(all-the-icons file-time file-size collapse subtree-state vc-state git-msg))
         '(file-time file-size collapse subtree-state vc-state git-msg))
	;;'(nerd-icons file-time file-size collapse subtree-state vc-state git-msg))
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
					;不显示续行
  (setq-default truncate-lines t)
					;preview directory using `exa` command
  (dirvish-define-preview exa (file)
    "Use `exa' to generate directory preview."
    :require ("exa") ; tell Dirvish to check if we have the executable
    (when (file-directory-p file) ; we only interest in directories here
      `(shell . ("exa" "-al" "--color=always" "--icons"
		 "--group-directories-first" ,file))))

  (add-to-list 'dirvish-preview-dispatchers 'exa)

  ;;隐藏父目录
  (setq dirvish-default-layout '(0 0.5 0.7))

  :bind	     ; Bind `dirvish|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish-fd)
   ;; ("s-d" . dirvish-side)
   :map dirvish-mode-map	   ; Dirvish inherits `dired-mode-map'
   ("a"   . dirvish-quick-access)
   ("f"   . dirvish-file-info-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dired-up-directory)
   ("."   . dirvish-history-last)
   ("h"   . dirvish-history-jump)	; remapped `describe-mode'
   ("s"   . dirvish-quicksort)	; remapped `dired-sort-toggle-or-edit'
   ("v"   . dirvish-vc-menu)	; remapped `dired-view-file'
;;   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-l" . dirvish-ls-switches-menu)
   ("M-m" . dirvish-mark-menu)
   ("M-t" . dirvish-layout-toggle)
   ("M-s" . dirvish-setup-menu)
   ("M-e" . dirvish-emerge-menu)
   ("M-j" . dirvish-fd-jump))

  )
