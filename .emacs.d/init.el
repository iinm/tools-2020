;;; UI
(setq inhibit-startup-screen t)
(column-number-mode 1)
;;(global-linum-mode 1)
(show-paren-mode t)
(setq show-paren-style 'mixed)
(setq completion-ignore-case t)
(menu-bar-mode 0)
;;(load-theme 'misterioso t)  ; env TERM=xterm-256color
;; dired
(put 'dired-find-alternate-file 'disabled nil)
(add-hook 'dired-load-hook '(lambda () (require 'dired-x)))
(setq dired-omit-mode t)

(when window-system
  (menu-bar-mode 1)
  (tool-bar-mode 0)
  (set-scroll-bar-mode nil)
  (blink-cursor-mode 0)
  ;; font
  (set-frame-font "Ubuntu Mono 12")
  (when (eq system-type 'darwin)  ; retina
    (set-frame-font "Ubuntu Mono 16"))
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
;;(when window-system
;;  (setq x-select-enable-clipboard t)
;;  (setq mouse-drag-copy-region t))

;; indent
(electric-indent-mode t)  ; default in 24.4
(setq-default indent-tabs-mode nil tab-width 8)
(setq c-default-style "k&r" c-basic-offset 4)
(setq js-indent-level 2)
;; css-mode
(add-hook 'css-mode-hook (lambda() (setq css-indent-offset 2)))

;; org-mode
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))


;;; Package Management
(setq package-list
      '(evil
        helm
        neotree
        projectile
        helm-projectile
        auto-complete
        ;;company
        yasnippet
        flycheck
        jedi
        ;;anaconda-mode
        ;;ac-anaconda
        jdee
        emmet-mode
        web-mode
        scss-mode
        rainbow-mode
        markdown-mode
        yaml-mode
        auctex
        xclip
        zenburn-theme
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
(load-theme 'zenburn t)

;; helm
(require 'helm-config)
;;(helm-mode 1)
(global-set-key (kbd "M-x")'helm-M-x)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;; neotree
(global-set-key [f8] 'neotree-toggle)
(add-hook 'neotree-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;; projectile
(projectile-global-mode)
(require 'helm-projectile)
(helm-projectile-on)

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
          (lambda ()
            (progn
              (add-to-list 'ac-sources 'ac-source-filename)
              (add-to-list 'ac-sources 'ac-source-yasnippet))))

;; company
;;(add-hook 'after-init-hook 'global-company-mode)

;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; jdee
(setq jdee-server-dir "~/.emacs.d/jdee/jdee-server/target")

;; web-mode
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-hook 'css-mode-hook 'web-mode)
;; indent
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
;; ac
(defvar ac-source-css-property-names
  '((candidates . (loop for property in ac-css-property-alist
                        collect (car property)))))
(defun my-css-mode-hook ()
  (add-to-list 'ac-sources 'ac-source-css-property)
  (add-to-list 'ac-sources 'ac-source-css-property-names))

(setq web-mode-ac-sources-alist
  '(("html" . (ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer))
    ("javascript" .
     (ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer))
    ("css" . (ac-source-css-property ac-source-css-property-names))))

(add-to-list 'ac-modes 'web-mode)

;; emmet
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
(add-hook 'nxml-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook  'emmet-mode)

;; rainbow-mode
(when window-system
  (add-hook 'css-mode-hook 'rainbow-mode)
  (add-hook 'less-mode-hook 'rainbow-mode)
  (add-hook 'web-mode-hook 'rainbow-mode)
  (add-hook 'html-mode-hook 'rainbow-mode))


;;; System-specific configuration

(when (eq system-type 'gnu/linux)
  ;; clipboard
  (xclip-mode 1)
  ;; mozc
  (require 'mozc)  ; or (load-file "/path/to/mozc.el")
  (setq default-input-method "japanese-mozc"))

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

  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))
