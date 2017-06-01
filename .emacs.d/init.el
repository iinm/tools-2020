;;; Package

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(let ((package-names '(evil
                       evil-mc
                       counsel
                       dired-hacks-utils
                       neotree
                       magit
                       flycheck
                       yasnippet
                       company
                       company-tern ; JS
                       company-jedi ; Python
                       company-sourcekit ; Swift
                       markdown-mode
                       web-mode
                       emmet-mode
                       js2-mode
                       swift-mode
                       go-mode
                       xclip
                       sicp
                       exec-path-from-shell
                       rainbow-delimiters
                       leuven-theme
                       zenburn-theme)))
  ;; install the missing packages
  (dolist (package package-names)
    (unless (package-installed-p package)
      (package-install package))))

;;
(require 'dired)
(require 'grep)

;;; Package Config

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(ivy-mode 1)
(evil-mode 1)
(evil-mc-mode 1)
(yas-global-mode 1)
(add-hook 'after-init-hook #'global-company-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(setq-default neo-show-hidden-files t)

;;; Appearance

(setq inhibit-startup-screen t)
(column-number-mode 1)
(global-linum-mode 1)
(unless window-system (setq linum-format "%4d \u2502 "))
(show-paren-mode t)
(setq show-paren-style 'mixed)
(setq completion-ignore-case t)
(menu-bar-mode 0)
(load-theme 'zenburn t)

(when window-system
  (menu-bar-mode 1)
  (tool-bar-mode 0)
  (set-scroll-bar-mode nil)
  (blink-cursor-mode 0)
  ;; font
  (cond
   ((eq system-type 'darwin)
    (add-to-list 'default-frame-alist '(font . "Ubuntu Mono-15")))
   (t (add-to-list 'default-frame-alist '(font . "Ubuntu Mono-12")))))
  ;;(set-fontset-font t 'japanese-jisx0208 (font-spec :family "TakaoGothic")))

;;; Control

;;(ido-mode 1)
;;(ido-everywhere 1)
;;(setq ido-enable-flex-matching t)
;;(unless window-system
;;  (xterm-mouse-mode t))

;; smooth scroll
(setq scroll-step 1)
(defun scroll-down-with-lines ()
  "" (interactive) (scroll-down 1))
(defun scroll-up-with-lines ()
  "" (interactive) (scroll-up 1))
(global-set-key [mouse-4] 'scroll-down-with-lines)
(global-set-key [mouse-5] 'scroll-up-with-lines)

;;; Editor

(setq-default indent-tabs-mode nil)
(global-auto-revert-mode t)
;;(when window-system
;;  (setq x-select-enable-clipboard t)
;;  (setq mouse-drag-copy-region t))

;;; Keymap

(define-key evil-normal-state-map " " nil)
(define-key dired-mode-map " " nil)
(define-key grep-mode-map " " nil)

(define-key evil-normal-state-map (kbd "SPC s") #'swiper)
(define-key evil-normal-state-map (kbd "SPC c") #'counsel-M-x)
(define-key evil-normal-state-map (kbd "SPC f o") #'counsel-find-file)
(define-key evil-normal-state-map (kbd "SPC f f") #'find-name-dired)
(define-key evil-normal-state-map (kbd "SPC f t") #'neotree-dir)
(define-key evil-normal-state-map (kbd "SPC g") #'grep-find)

(define-key evil-normal-state-map (kbd "SPC b b") #'switch-to-buffer)
(define-key evil-normal-state-map (kbd "SPC b k") #'kill-buffer)

(define-key evil-normal-state-map (kbd "SPC w j") #'windmove-down)
(define-key evil-normal-state-map (kbd "SPC w k") #'windmove-up)
(define-key evil-normal-state-map (kbd "SPC w h") #'windmove-left)
(define-key evil-normal-state-map (kbd "SPC w l") #'windmove-right)

;;; Mode config

;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . js2-jsx-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun my-web-mode-hook ()
  (setq
   web-mode-markup-indent-offset 2
   web-mode-css-indent-offset 2
   web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook #'my-web-mode-hook)

(defun my-js-mode-hook ()
  (setq js2-basic-offset 2)
  (setq js-indent-level 2)
  (setq js2-strict-missing-semi-warning nil)
  (setq js2-strict-trailing-comma-warning nil)
  (flycheck-select-checker 'javascript-eslint)
  (tern-mode)
  (add-to-list 'company-backends 'company-tern)
  (define-key evil-normal-state-map (kbd "SPC j") #'tern-find-definition))
(add-hook 'js2-jsx-mode-hook #'my-js-mode-hook)
(add-hook 'js-mode-hook #'my-js-mode-hook)

(defun my-css-mode-hook ()
  (setq css-indent-offset 2))
(add-hook 'css-mode-hook #'my-css-mode-hook)

(defun my-python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi)
  (define-key evil-normal-state-map (kbd "SPC j") #'jedi:goto-definition))
(add-hook 'python-mode-hook #'my-python-mode-hook)

(defun my-swift-mode-hook ()
  (add-to-list 'company-backends 'company-sourcekit))
(add-hook 'swift-mode-hook #'my-swift-mode-hook)

(defun my-go-mode-hook ()
  (setq indent-tabs-mode t)
  (setq default-tab-width 4))
(add-hook 'go-mode-hook #'my-go-mode-hook)

(defun my-neotree-mode-hook ()
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  ;;(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "r") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter))
(add-hook 'neotree-mode-hook #'my-neotree-mode-hook)

;; emmet
(add-hook 'sgml-mode-hook #'emmet-mode)
(add-hook 'css-mode-hook #'emmet-mode)
(add-hook 'web-mode-hook #'emmet-mode)

;;; System-specific configuration

(when (eq system-type 'gnu/linux)
  ;; clipboard
  (xclip-mode 1))
  ;; mozc
  ;;(require 'mozc)  ; or (load-file "/path/to/mozc.el")
  ;;(setq default-input-method "japanese-mozc"))

(when (eq system-type 'darwin)
  ;; clipboard
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))

  (setenv "LANG" "en_US.UTF-8")
  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

  (setq interprogram-cut-function #'paste-to-osx)
  (setq interprogram-paste-function #'copy-from-osx))

;;; Garbage
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (swift-mode zenburn-theme yasnippet xclip web-mode sicp rainbow-delimiters neotree markdown-mode magit leuven-theme js2-mode flycheck exec-path-from-shell evil-mc emmet-mode dired-hacks-utils counsel company-tern company-jedi))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
