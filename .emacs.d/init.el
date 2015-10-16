;;; UI
(setq inhibit-startup-screen t)
(column-number-mode 1)
;;(global-linum-mode 1)
(show-paren-mode t)
(setq show-paren-style 'mixed)
(setq completion-ignore-case t)
(menu-bar-mode 0)
;;(load-theme 'misterioso t)  ; env TERM=xterm-256color

(when window-system
  (tool-bar-mode 0)
  (set-scroll-bar-mode nil)
  (blink-cursor-mode 0)
  ;; font
  (set-frame-font "Ubuntu Mono 13")
  (set-fontset-font t 'japanese-jisx0208
                    (font-spec :family "TakaoGothic")))

;; ido
;;(require 'ido)
;;(ido-mode t)

;; smooth scroll
;;(setq scroll-step 1)
;;(defun scroll-down-with-lines ()
;;  "" (interactive) (scroll-down 1))
;;(defun scroll-up-with-lines ()
;;  "" (interactive) (scroll-up 1))
;;(global-set-key [mouse-4] 'scroll-down-with-lines)
;;(global-set-key [mouse-5] 'scroll-up-with-lines)


;;; Editor
;;
(when window-system
  (setq x-select-enable-clipboard t)
  (setq mouse-drag-copy-region t))

;; indent
(setq-default indent-tabs-mode nil tab-width 8)
(setq c-default-style "k&r" c-basic-offset 4)


;;; Package Management
(setq package-list
      '(evil
        helm
        auto-complete
        ;;company
        yasnippet
        flycheck
        jedi
        ;;anaconda-mode
        ;;ac-anaconda
        jdee
        color-theme-sanityinc-tomorrow))

(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents (package-refresh-contents))
;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;;; Package Config

;; evil
(require 'evil)
(evil-mode 1)

;; theme - env TERM=xterm-256color
;;(color-theme-sanityinc-tomorrow-eighties)
(custom-set-variables
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default))))

;; helm
(require 'helm-config)
(helm-mode 1)

;; yasnippet
;; should be loaded before auto-complete
(require 'yasnippet)
(yas-global-mode 1)

;;; anaconda, ac-anaconda
;;(add-hook 'python-mode-hook 'anaconda-mode)
;;(add-hook 'python-mode-hook 'eldoc-mode)
;;(add-hook 'python-mode-hook 'ac-anaconda-setup)

;; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(add-hook 'auto-complete-mode-hook
          (lambda () (add-to-list 'ac-sources 'ac-source-filename)))

;; company
;;(add-hook 'after-init-hook 'global-company-mode)

;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; jdee
(setq jdee-server-dir "~/.emacs.d/jdee/jdee-server/target")

;;; System-specific configuration

;; mozc
(when (string= system-type "gnu/linux")
  (require 'mozc)  ; or (load-file "/path/to/mozc.el")
  (setq default-input-method "japanese-mozc"))
