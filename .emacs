(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(Buffer-menu-use-frame-buffer-list t)
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(display-time-24hr-format t)
 '(display-time-mode t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(fancy-splash-image "~/tmp/empty")
 '(global-font-lock-mode t nil (font-lock))
 '(save-place t nil (saveplace))
 '(show-paren-mode t t)
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
 '(setq indent-tabs-mode nil) 
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 )

';; check for linux
( if ( eq system-type 'gnu/linux )
    (add-to-list 'load-path "/usr/share/emacs/site-lisp/tramp")
)
(require 'tramp)
(setq tramp-default-method "ssh")

;; ISO Latin 1 support
(set-language-environment "Latin-1")
(standard-display-8bit 160 255)
(set-input-mode (car (current-input-mode)) (nth 1 (current-input-mode)) 0)

;; set up unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; This from a japanese individual.  I hope it works.
(setq default-buffer-file-coding-system 'utf-8)
;; From Emacs wiki
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; MS Windows clipboard is UTF-16LE 
;;(set-clipboard-coding-system 'utf-16le-dos)
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

;; Make Emacs "see" the elisp packages installed
(setq load-path
      (append (list nil
		    "/home/mickevi/emacs"
		    )
	      load-path))
;;(require 'php-mode)
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))


;;;; Make Emacs load JDE
;;(require 'jde)

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
