;; Erik Westrup's GNU Emacs configuration.

;;; Environment
;;; NOTE use expand-file-name user-emacs-directory to use $XDG_CONFIG_HOME/emacs if it exist.
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory)) ;; Add lisp plugin folder to load path.
(add-to-list 'custom-theme-load-path (expand-file-name "themes/" user-emacs-directory))	;; Theme path.

;;; Keyboard shortcuts
(global-set-key [f7] 'global-hl-line-)			;; Toggle line highlight.
(global-set-key [(control h)] 'backward-delete-char)		;; ^H as expected.
(define-key isearch-mode-map [(control h)] 'isearch-delete-char) ;; ^H deletion in i-search mode.
(global-set-key (kbd "RET") 'newline-and-indent)	;; Indent to next line on return. Same as C-j.


;;; Settings
(global-font-lock-mode 1)			;; Syntax highlighting by default.
(auto-compression-mode 1)			;; Allow editing of compressed files.
;(setq make-backup-files nil)			;; Don't make ~-backup files.
(setq tramp-default-method "ssh")		;; Use ssh by default for editing remote files.
(setq inhibit-startup-message t)		;; Hide welcome screen.
(setq scroll-step 1)				;; Scroll one line at a time, not half a page.
(setq flyspell-issue-welcome-flag nil)		;; Don't show welcome flyspell message.
(setq vc-follow-symlinks 't)			;; Don't ask about following symlinks, just do it!
(put 'downcase-region 'disabled nil)		;; Enable lower case conversion of words.
(put 'upcase-region 'disabled nil)		;; Enable upper case conversion of words.
(fset 'yes-or-no-p 'y-or-n-p)			;; Changes all yes/no questions to y/n type.

;; Tabs.
(setq tab-width 4)					;; Tab width.
(setq c-backspace-function 'backward-delete-char)	;; Delete tabs -- don't convert them to spaces!

;; Linux kernel coding style.
(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (b-set-style "K&R")
  (setq c-basic-offset 8))

;; Set up UTF-8.
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; From Emacs wiki.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; MS Windows clipboard is UTF-16LE.
(set-clipboard-coding-system 'utf-16le-dos)


;; Ctags.
(setq path-to-ctags "/usr/bin/ctags")	 ;; Path to ctags binary.
;; Command for creating a TAGS-file with ctags.
  (defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "%s -f %s/TAGS -e -R %s" path-to-ctags dir-name (directory-file-name dir-name)))
  )

;; Put autosave files (i.e. #foo#) and backup files (i.e. foo~) in ~/.emacs.d/.
(custom-set-variables
   '(auto-save-file-name-transforms '((".*" "~/.local/share/emacs/autosaves/\\1" t)))
     '(backup-directory-alist '((".*" . "~/.local/share/emacs/backups/"))))
;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.local/share/emacs/autosaves/" t)

;;; UI
(menu-bar-mode -1)				;; Disable the menu bar.
(global-hl-line-mode 1)			;; Highlight cursor line.
(display-time)					;; Displays the time in the status bar.
;; GUI font to use.
(setq default-frame-alist '((font . "terminus")))

;; Line numbers.
(require 'linum)
(global-linum-mode 1)				;; Always show line numbers.
(setq linum-format "%4d ")			;; Display format for line numbers.

;; Highligt programming comment tags.
(add-hook 'c-mode-common-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(TODO\\|FIXME\\|NOTE\\|BUG\\|XXX\\):?" 1 font-lock-warning-face t)))))

;;; Solarized.
;; Theme path. Emacs 24 install assumed.
;(add-to-list 'custom-theme-load-path (expand-file-name "themes/emacs-color-theme-solarize/" user-emacs-directory))
;(load-theme 'solarized-dark t)			;; Load dark theme.
;(load-theme 'solarized-light t)		;; Load light theme.
;(setq solarized-termcolors 256)		;; Use degraded version using colors close to solarized.

;;; Plugins
;; Column marker.
(require 'column-marker)
(add-hook 'c-mode-hook (lambda () (interactive) (column-marker-1 81))) ;; Mark the 81st column in c-mode.
