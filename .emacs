(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list t)
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(column-number-mode t)
 '(display-time-24hr-format t)
 '(display-time-mode t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(fancy-splash-image "~/tmp/empty")
 '(global-font-lock-mode t nil (font-lock))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
;; ===== Turn off tab character =====

;;
;; Emacs normally uses both tabs and spaces to indent lines. If you
;; prefer, all indentation can be made from spaces only. To request this,
;; set `indent-tabs-mode' to `nil'. This is a per-buffer variable;
;; altering the variable affects only the current buffer, but it can be
;; disabled for all buffers.

;;
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally
;;
(setq-default indent-tabs-mode nil)
 ;;; Show columns
(setq column-number-mode t)
;;; M-x describe-font
;;;(set-default-font "-urw-Nimbus Sans L-normal-normal-normal-*-13-*-*-*-*-0-iso10646-1" )
(set-default-font "-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1" )
(modify-frame-parameters nil '((wait-for-wm . nil)))
;;; För att emacs-daemon ska ladda fonten.
;;;(setq default-frame-alist '((font . "-urw-Nimbus Sans L-normal-normal-normal-*-13-*-*-*-*-0-iso10646-1" )))
(setq default-frame-alist '((font . "-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1" )))

;; Make Emacs "see" the elisp packages installed
(setq load-path
      (append (list nil
		    "/nfshome/66085217/.emacs.d"
		    )
	      load-path))


;; abbreviations
;; ===== Automatically load abbreviations table =====

;; Note that emacs chooses, by default, the filename
;; "~/.abbrev_defs", so don't try to be too clever
;; by changing its name

(setq-default abbrev-mode t)
(if (file-exists-p "/nfshome/66085217/.abbrev_defs")
    (quietly-read-abbrev-file "/nfshome/66085217/.abbrev_defs"))
(setq save-abbrevs t)

;; ===== Set the highlight current line minor mode =====

;; In every buffer, the line which contains the cursor will be fully
;; highlighted
(global-hl-line-mode 1)

;;; check for linux
(defun set_linux()
  (message "%s" '(Loading Linux settings) )
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/tramp")
  ;;git-emacs
  (add-to-list 'load-path "/nfshome/66085217/.emacs.d/git-emacs/")
  (require 'git-emacs)
  ;; Cleanmode -- Start --
  (defvar mode-line-cleaner-alist
    `((auto-complete-mode . " a")
      (yas/minor-mode . " u")
      (paredit-mode . " p")
      (flyspell-mode . " fs")
      (autopair-mode ." pa")
      (outline-minor-mode . "")
      (eldoc-mode . "")
      (abbrev-mode . "")
      ;; Major modes
      (lisp-interaction-mode . "L")
      (hi-lock-mode . "")
      (python-mode . "Py")
      (emacs-lisp-mode . "EL")
      (nxhtml-mode . "nx"))
    "Alist for `clean-mode-line'.
When you add a new element to the alist, keep in mind that you
must pass the correct minor/major mode symbol and a string you
want to use in the modeline *in lieu of* the original.")


  (defun clean-mode-line ()
    (interactive)
    (loop for cleaner in mode-line-cleaner-alist
          do (let* ((mode (car cleaner))
                    (mode-str (cdr cleaner))
                    (old-mode-str (cdr (assq mode minor-mode-alist))))
               (when old-mode-str
                 (setcar old-mode-str mode-str))
               ;; major mode
               (when (eq mode major-mode)
                 (setq mode-name mode-str)))))


  (add-hook 'after-change-major-mode-hook 'clean-mode-line)


  ;; Cleanmode -- end --
  ;;; Save desktop setttings. ( reload buffers after exit)
  ;; (desktop-save-mode 1)
  ;; (setq desktop-save t)
  ;; (setq desktop-load-locked-desktop t)
  ;; (setq desktop-base-lock-name
  ;; 	(convert-standard-filename (format ".emacs.desktop.lock-%d" (emacs-pid))))
  ;; (setq desktop-dirname user-emacs-directory)
  (message "%s" '(Linux settings loaded ok))
  ;; Python settings * - * Start * - *
  ;; - python-mode
  (add-to-list 'load-path "/nfshome/66085217/.emacs.d/python-mode/")
  (setq py-install-directory "/nfshome/66085217/.emacs.d/python-mode/")
  (require 'python-mode)
  (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
  ;; - ipython
  (setq py-shell-name "/produkter/gnu/python/bin/ipython")
  (require 'ipython)
  ;; - anything, code completion
  (require 'anything) (require 'anything-ipython)
  (when (require 'anything-show-completion nil t)
    (use-anything-show-completion 'anything-ipython-complete
                                  '(length initial-pattern)))
  ;; - autoppair
  (require 'autopair)
  (autopair-global-mode 1)
  (add-hook 'lisp-mode-hook #'(lambda () (setq autopair-dont-activate t)))
  (add-hook 'python-mode-hook
	    #'(lambda () (push '(?' . ?')
			       (getf autopair-extra-pairs :code))
                (setq autopair-handle-action-fns
                      (list #'autopair-default-handle-action
                            #'autopair-python-triple-quote-action))))
  ;; - pylint
  (require 'python-pep8)
  (require 'python-pylint)
  ;; - delete trailing withiespace
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  ;; Pyton settings * - * End * - *
  ;; flymake
  (setq pycodechecker "pylint_etc_wrapper.py")
  (when (load "flymake" t)
    (load-library "flymake-cursor")
    (defun dss/flymake-pycodecheck-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list pycodechecker (list local-file))))
    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.py\\'" dss/flymake-pycodecheck-init)))
  ;; -- fly spell --
  (autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
  (setq ispell-program-name "aspell")
  (setq ispell-list-command "list")
  (setq ispell-extra-args '("--sug-mode=ultra"))

  (add-hook 'python-mode-hook
            (lambda ()
              (flyspell-prog-mode)
              (flymake-mode)

              ))
  ;; associate xml, xsd, etc with nxml-mode
  (add-to-list 'auto-mode-alist (cons (concat "\\." (regexp-opt '("xml" "xsd" "rng" "xslt" "xsl") t) "\\'") 'nxml-mode))
  (setq nxml-slash-auto-complete-flag t)

  )

(if (string-match "linux" (symbol-name system-type))
    (  set_linux )
  ( message "%s" '(inge linux)) ;; else..
  )


;;; start server
;; (setq server-use-tcp t)
;;(setq server-name "66085217")
;; (setf server-socket-dir (format "/nfshome/%s/.emacs.d/server" (user-uid))
;;       server-name       (format "%s" (user-uid)))
;;(server-start)

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

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))



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


;;; Windows sise
(add-hook 'before-make-frame-hook
          #'(lambda ()
              (add-to-list 'default-frame-alist '(left   . 0))
              (add-to-list 'default-frame-alist '(top    . 0))
              (add-to-list 'default-frame-alist '(height . 68))
              (add-to-list 'default-frame-alist '(width  . 166))))

(put 'downcase-region 'disabled nil)


(put 'upcase-region 'disabled nil)

;;; File: emacs-format-file
;;; Stan Warford
;;; 17 May 2006

(defun micke-format-function ()
   "Format the whole buffer."
;;   (c-set-style "stroustrup")
   (indent-region (point-min) (point-max) nil)
   (untabify (point-min) (point-max))
   (save-buffer)
)
