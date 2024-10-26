;;;###autoload
(defun +evan/set-cn-fonts ()
  (interactive)
  (dolist (charset '(kana symbol cjk-misc bopomofo chinese-gbk))
    (set-fontset-font
     "fontset-default"
     charset
     (font-spec ;;:name +evan/cn-font
                :slant 'normal
                :size +evan/cn-font-size))))
;;;###autoload
(defun +evan/set-fonts ()
  (interactive)
 ;; (when (window-system)
    (progn
      ;; 设置Emoji字体
      ;;(let ((fonts '("Noto Color Emoji")))
        ;;(cl-loop with script = (if (>= emacs-major-version 28)
       ;; 'emoji 'unicode)
         ;;        for font in fonts
           ;;      when (member font (font-family-list))
             ;;    return (set-fontset-font t script (font-spec
	;;					    :family font) nil 'prepend)))
      
      ;; 设置default face字体
      (set-face-attribute
       'default nil
       :font (font-spec ;;:family +evan/en-font
                        :weight 'normal
                        :size +evan/font-size))
      ;; 设置fixed-pitch-serif face字体
      (set-face-attribute
       'fixed-pitch-serif nil
       :font (font-spec ;;:family +evan/en-font
			:weight 'normal
			:slant 'italic
			:size +evan/font-size))
      (set-face-attribute
       'fixed-pitch nil
       :font (font-spec ;;:family +evan/en-font
			:weight 'normal
			:size +evan/font-size))
      (set-face-attribute
       'variable-pitch nil
       :font (font-spec ;;:family +evan/en-font
			:weight 'normal
			:size +evan/font-size))

;;(+evan/set-cn-fonts)
)
)
;;)

(setq 
      ;;+evan/en-font "JetBrains Mono NerdFont"
;;      +evan/cn-font "霞鹜文楷等宽"
      +evan/font-size 18.0
      +evan/cn-font-size 18.0)

(provide 'init-font)
