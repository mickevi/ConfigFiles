(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list t)
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(display-time-24hr-format t)
 '(display-time-mode t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(fancy-splash-image "~/tmp/empty")
 '(global-font-lock-mode t nil (font-lock))
 '(save-place t nil (saveplace))
 '(set-default-font "-unknown-DejaVu LGC Sans Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
 '(show-paren-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
 '(setq indent-tabs-mode nil) 


;; Make Emacs "see" the elisp packages installed
(setq load-path
      (append (list nil
		    "/nfshome/66085217/.emacs.d"
		    )
	      load-path))

;;; check for linux
(defun set_linux() 
  (message "%s" '(Loading Linux settings) )  
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/tramp")
  ;;git-emacs
  (add-to-list 'load-path "/nfshome/66085217/.emacs.d/git-emacs/")
  (require 'git-emacs)
  ;;; Save desktop setttings. ( reload buffers after exit)
  (desktop-save-mode 1)
  (setq desktop-save t)
  (setq desktop-load-locked-desktop t)
  (setq desktop-base-lock-name
	(convert-standard-filename (format ".emacs.desktop.lock-%d" (emacs-pid))))
  (setq desktop-dirname user-emacs-directory)
  (message "%s" '(Linux settings loaded ok)) 
)

(if (string-match "linux" (symbol-name system-type))
 (  set_linux )
 ( message "%s" '(inge linux)) ;; else..
)
;;; start server
;;(setq server-use-tcp t)
;;(setq server-name "66085217")
;; (setf server-socket-dir (format "/nfshome/%s/.emacs.d/server" (user-uid)) 
;;       server-name       (format "%s" (user-uid))) 
(server-start) 

(require 'tramp)
(setq tramp-default-method "ssh")


;; set window tittle.
 (setq frame-title-format
       '("emacs " (:eval (getenv "USER")) "@" (:eval (system-name)) ))

;; ISO Latin 1 support
(set-language-environment "Latin-1")
(standard-display-8bit 160 255)
(set-input-mode (car (current-input-mode)) (nth 1 (current-input-mode)) 0)

;;;
;;; Set up a more intuitive version control system
;;;

(setq make-backup-files t)
(setq version-control t)
(setq kept-new-versions 10)
(setq kept-old-versions 0)
(setq delete-old-versions t)
(setq delete-auto-save-files t)
(setq trim-versions-without-asking t)
(global-set-key "\C-X\C-s"
                '(lambda () (interactive) (save-buffer 16)))




;; Add color to a shell running in emacs 'M-x shell'
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)



(setq-default transient-mark-mode t)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq undo-limit 100000)
(setq undo-strong-limit 200000)

;;(require 'php-mode)
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))



;; With numeric ARG, display the tool bar if and only if ARG is
;; positive.  Tool bar has icons document (read file), folder (read
;; directory), X (discard buffer), disk (save), disk+pen (save-as),
;; back arrow (undo), scissors (cut), etc.
(tool-bar-mode 0)
;; Finally, to deal with small changes in the white space I often find
;; it useful to configure ediff like this:
;;
   (setq ediff-diff-options "-w")
   (setq-default ediff-ignore-similar-regions t)


; diffa files, snott från georg
(defun diffa_files ()
    (interactive "*")
    (find-file  FILE1)
    (find-file  FILE2)
    (ediff-buffers
     (get-file-buffer FILE1)
     (get-file-buffer FILE2))
)

(put 'downcase-region 'disabled nil)
