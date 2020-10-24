(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (deeper-blue)))
 '(grep-find-ignored-directories
   (quote
    ("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "plugins")))
 '(package-selected-packages
   (quote
    (js2-mode rjsx-mode rust-mode typescript-mode glsl-mode pug-mode web-beautify vlf use-package company-jedi neotree markdown-mode dockerfile-mode json-mode yaml-mode flycheck magit-gitflow company exec-path-from-shell vue-mode less-css-mode iedit zencoding-mode ranger magit js2-refactor indium editorconfig auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;; Melpa packages
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))

(global-set-key (kbd "C-x t") 'rename-buffer) ; C-x t to rename buffer

;; Font size and style
(set-face-attribute 'default nil
		    :family "Monaco" :height 110 :weight 'normal)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; magit-gitflow
(require 'magit-gitflow)
(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)

;; Zencoding mode
(setq mac-option-key-is-meta t)
(setq mac-right-option-modifier nil)

;; editorconfig mode
(require 'editorconfig)
(editorconfig-mode 1)

;; C-n creates newline at buffer end
(setq next-line-add-newlines t)

;; setup files ending in “.js” to open in rjsx-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(defadvice js-jsx-indent-line (after js-jsx-indent-line-after-hack activate)
  "Workaround sgml-mode and follow airbnb component style."
  (save-excursion
    (beginning-of-line)
    (if (looking-at-p "^ +\/?> *$")
        (delete-char sgml-basic-offset))))

;; use system path
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; company-mode enabled globally
(add-hook 'after-init-hook 'global-company-mode)

;; line number in margin
(setq global-linum-mode t)

;; windmove to change current buffer selected
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; load flycheck on launch
(add-hook 'after-init-hook #'global-flycheck-mode)

;; remove bell sound
(setq visible-bell 1)

(setq ring-bell-function 'ignore)

(setq js-indent-level 2)
(setq typescript-indent-level 2)

;; company-jedi mode for python
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

(use-package company-jedi             ;;; company-mode completion back-end for Python JEDI
  :config
  (setq jedi:environment-virtualenv (list (expand-file-name "~/.emacs.d/.python-environments/")))
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)
  (setq jedi:use-shortcuts t)
  (defun config/enable-company-jedi ()
    (add-to-list 'company-backends 'company-jedi))
  (add-hook 'python-mode-hook 'config/enable-company-jedi))

;; enable ido mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
