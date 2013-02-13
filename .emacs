(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(backup-by-copying t)
 '(backup-directory-alist (quote (("." . "/Users/eleddy/buildouts/.emacs_backups"))))
 '(word-wrap t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color) (background dark)) (:underline "Red"))))
 '(flymake-infoline ((t (:background "Black"))))
 '(flymake-warnline ((((class color) (background dark)) (:underline "orange")))))


;;;
;;; This will turn on the parenthesis highlighting
;;;
(cond (window-system
       (require 'paren)
       (setq paren-mismatch-face 'modeline)
;;;       (set-face-background 'default "white")
       (require 'font-lock) ;;; Syntax Highlighting required
))


;;;
;;; line numbers.
;;;
(line-number-mode t)
(global-linum-mode 1)

;;; osx
(add-to-list 'exec-path "/usr/local/bin")


;;; theme setup
(add-to-list 'load-path "~/.emacs.d/themes/")
;;;(let ((default-directory  "~/.emacs.d/themes/"))
;;;      (normal-top-level-add-subdirs-to-load-path))

;;; hmm - apparenlty this theme library is DANGEROUS
(setq load-dangerous-libraries t)
(require 'color-theme)
(color-theme-initialize)
;;; (color-theme-andreas)
(require 'color-theme-molokai)
(require 'color-theme-tomorrow)
(require 'color-theme-solarized)
(color-theme-molokai)

;;; some more python setup
;;; A quick & ugly PATH solution to Emacs on Mac OSX
;;; need this to make pylint work
(if (string-equal "darwin" (symbol-name system-type))
   (setenv "PATH" (concat "/usr/local/bin:/usr/local/sbin:" (getenv "PATH"))))
;;; I think this is actually being ignored...
(setq py-python-command "/usr/local/bin/python")

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete)
(global-auto-complete-mode t)


(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(require 'python-mode)
(add-hook 'python-mode-hook
     (lambda ()
	(set-variable 'py-indent-offset 4)
	;(set-variable 'py-smart-indentation nil)
	(set-variable 'indent-tabs-mode nil)
	;(define-key py-mode-map (kbd "RET") 'newline-and-indent)
	;(define-key py-mode-map [tab] 'yas/expand)
	;(setq yas/after-exit-snippet-hook 'indent-according-to-mode)
	;(smart-operator-mode-on)
	))

;;;
;;; make outline mode work the way I want
(setq outline-regexp "[[ ^L]+" )
(outline-minor-mode t)


(put 'upcase-region 'disabled nil)

;;;
;;; Setup larger line number thingy
;;;
(setq line-number-display-limit 1000000)

;;;
;;; Wire the F6 key to advance to the next error.
;;;
(global-set-key [f6]    'next-error)
(global-set-key [f5]    'undo)
(global-set-key [f7]    'goto-line)
;;;(global-set-key [C-f8]  'repeat-regexp-fwd)
(global-set-key [f8]    're-search-forward)
(global-set-key [f9]    'compile)
;;;(global-set-key [C-f9]  'remote-compile)
(global-set-key [f10]   'mark-whole-buffer)
(global-set-key [f11]   'revert-buffer)
(global-set-key [f12]   'ediff-buffers)
(global-set-key "\C-o"  'dabbrev-expand)


;;;paren match command a la vi.
;;;(global-set-key "%" 'match-paren)
;;;(defun match-paren (arg)
;;;  "Go to the matching parenthesis if on parenthesis otherwise insert %."
;;;(interactive "p")
;;;(cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
;;;      ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
;;;      (t (self-insert-command (or arg 1)))))

;;; Electric Pairs
(add-hook 'python-mode-hook
     (lambda ()
;;;      (define-key python-mode-map "\"" 'electric-pair)
;;;      (define-key python-mode-map "\'" 'electric-pair)
;;;      (define-key python-mode-map "(" 'electric-pair)
      (define-key python-mode-map "[" 'electric-pair)
      (define-key python-mode-map "{" 'electric-pair)))
(defun electric-pair ()
  "Insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

;;; bind RET to py-newline-and-indent
(add-hook 'python-mode-hook '(lambda () 
     (define-key python-mode-map "\C-m" 'newline-and-indent)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "~/.emacs.d/pyflymake.py" (list local-file))))
      ;;     check path
  
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

(add-hook 'find-file-hook 'flymake-find-file-hook)

