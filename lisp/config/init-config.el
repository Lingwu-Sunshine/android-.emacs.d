(require 'package)
;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("ustc-melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/") t)
(package-initialize)


;;(add-to-list 'load-path "~/.emacs.d/lisp/")


;;font config
(require 'init-font)
(+evan/set-fonts)
;;(require 'init-font)



(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file) ;;
  (write-region "" nil custom-file));;
(load-file custom-file)



;;三件套配置
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

(use-package vertico-dirctory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
	      ("DEL" . vertico-directory-delete-char)
	      ("RET" . vertico-directory-enter)
	      ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
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
(use-package marginalia
  :ensure t
  :after (vertico consult)
  :config
  (marginalia-mode))

;;prog-mode config
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package company
  :ensure t
  :hook ((prog-mode . company-mode)
	 (shell-mode . company-mode)
	 (org-mode . company-mode)))



(use-package ace-window
  :ensure t
  :custom-face
  (aw-leading-char-face ((t (:inherit font-lock-keyword-face :foreground unspecified :bold t :height 3.0))))
;;  (aw-minibuffer-leading-char-face ((t (:inherit font-lock-keyword-face :bold t :height 1.0))))
;;  (aw-mode-line-face ((t (:inherit mode-line-emphasis :bold t))))
  :bind ("C-x o" . ace-window))



;;input-method candidates windows
(use-package posframe
  :ensure t)

;; input-method
(use-package pyim
  :ensure t
;;  :bind
;;  ("C-\\" . toggle-input-method)
  :config
  (setq default-input-method "pyim")

  (use-package pyim-wbdict
  :ensure t
  :after pyim
  :init
  (pyim-default-scheme 'wubi)
  (pyim-wbdict-v86-enable))
;;  (pyim-isearch-mode 1)
  )


;;undo tree
(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo))

;;dired config
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


;;(eval-when-compile
;;  (require 'init-custom))

;;emacs启动面板
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-banner-logo-title "Welcome to Emacs!") ;; 个性签名，随读者喜好设置
  ;; (setq dashboard-projects-backend 'projectile) ;; 读者可以暂时注释掉这一行，等安装了 projectile 后再使用
  (setq dashboard-projects-backend 'project-el) ;; 读者可以暂时注释掉这一行，等安装了 projectile 后再使用
  (setq dashboard-center-content t)		;;显示位置居中
  (setq dashboard-set-init-info t)		;;显示包加载时间
  ;; (setq dashboard-startup-banner 'official)	;; 也可以自定义图片
  (setq dashboard-startup-banner 'official)	;; 也可以自定义图片
  (setq dashboard-items '((recents  . 7)	;; 显示多少个最近文件
                          (bookmarks . 7)	;; 显示多少个最近书签
			  (projects . 10)))	;;显示多少个最近项目
  ;;   )
  ;; )
  ;; (setq dashboard-icon-type 'all-the-icons)
  ;; (setq dashboard-icon-type 'all-the-icons)
  ;;(setq dashboard-display-icons-p #'icons-displayable-p
;;	dashboard-set-file-icons emacs-icon
;;	dashboard-set-heading-icons emacs-icon
;;	dashboard-heading-icons '((recents . "nf-oct-history")
;;				  (bookmarks . "nf-oct-bookmark")
;;				  (projects . "nf-oct-briefcase")
;;				  (registers . "nf-oct-database")))
  (dashboard-setup-startup-hook)
  :custom
  ;; (dashboard-startup-banner 'logo)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  )

;;(provide 'init-dashboard)





;;参考链接：https://www.5axxw.com/wiki/content/spum7l
(use-package centaur-tabs
  :ensure t
  :demand
  :hook (dashboard-mode . centaur-tabs-local-mode) ;;在 dashboard 模式下隐藏tabs显示
  :config
					;  (centaur-tabs-mode t) ;;启动centaur-tabs-mode模式
  (setq centaur-tabs-style "rounded") ;;设置图标类型为圆角
;;  (setq centaur-tabs-set-icons t) ;;显示所有图标中的主题图标
  (centaur-tabs-headline-match) ;;使标题面与centaur-tabs-mode匹配，使选项卡具有统一的外面
  (setq centaur-tabs-gray-out-icons 'buffer) ;;灰显示所有未选中选项卡的图标
  (setq centaur-tabs-set-bar 'over)
  (setq centaur-tabs-height 65)

  ;;  (centaur-tabs-group-by-projectile-project)

  ;;缓冲区重新排序
  (centaur-tabs-enable-buffer-reordering)

  (setq centaur-tabs-adjust-buffer-order t)
  (setq centaur-tabs-adjust-buffer-order 'left)
  (setq centaur-tabs-adjust-buffer-order 'right)

  ;;将所有终端tabs归为一个 groups
  ;;https://github.com/jixiuf/vterm-toggle
  ;; (setq centaur-tabs-buffer-groups-function 'vmacs-awesome-tab-buffer-groups)
  ;;进行 groups划分，以下不显示tabs
  ;; (defun vmacs-awesome-tab-buffer-groups ()
  ;;   "`vmacs-awesome-tab-buffer-groups' control buffers' group rules. "
  ;;   (list
  ;;    (cond
  ;;     ((derived-mode-p 'eshell-mode 'term-mode 'shell-mode 'vterm-mode)
  ;;      "Term")
  ;;     ((derived-mode-p 'magit-mode)
  ;;      "Magit")
  ;;     ((string-match-p (rx (or
  ;;                           "\*Helm"
  ;;                           "\*Ibuffer\*"
  ;;                           "\*helm"
  ;;                           "\*tramp"
  ;;                           "\*Completions\*"
  ;;                           "\*sdcv\*"
  ;;                           "\*Messages\*"
  ;;                           "\*dashboard\*"
  ;;                           "\*scratch\*"
  ;;                           "\*Ido Completions\*"
  ;;                           ))
  ;;                      (buffer-name))
  ;;      "Emacs")
  ;;     (t "Common"))))

  ;; (setq vterm-toggle--vterm-buffer-p-function 'vmacs-term-mode-p)
  ;; (defun vmacs-term-mode-p(&optional args)
    ;; (derived-mode-p 'eshell-mode 'term-mode 'shell-mode 'vterm-mode))


  (centaur-tabs-mode t) ;;启动centaur-tabs-mode模式
  :bind
    (("C-{" . centaur-tabs-backward)
    ("C-}" . centaur-tabs-forward))

  )
;;  :bind
;;  ("C-h" . centaur-tabs-backward)
;;  ("C-l" . centaur-tabs-forward))
;;(provide 'init-centaur-tabs)


(require 'auto-save)
(auto-save-enable)

(setq auto-save-silent t)   ; quietly save
(setq auto-save-delete-trailing-whitespace t)  ; automatically delete spaces at the end of the line when saving

;;; custom predicates if you don't want auto save.
;;; disable auto save mode when current filetype is an gpg file.
(setq auto-save-disable-predicates
      '((lambda ()
      (string-suffix-p
      "gpg"
      (file-name-extension (buffer-name)) t))))
;;```


(provide 'init-config)
