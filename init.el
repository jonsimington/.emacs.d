;;; package --- .emacs -> My Emacs config

;;; Commentary:
;;; Author: Jon Simington
;;; Last revised: Time-stamp: <2017-05-12 23:52:54 (Jon)>


;;; Code:

;;; Time stamp file on-save

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(defvar time-stamp-active t)
(defvar time-stamp-line-limit 10)  ; only check first 10 buffer lines for Time-stamp:
(setq time-stamp-pattern "@file '%f' last edited by %u on %h at %Y-%:m-%:d %02H:%02M:%02S@")
(add-hook 'before-save-hook 'time-stamp)

;; Hide welcome screen
(setq inhibit-startup-message t)

;; Default find file path
(setq default-directory "/home/jon/")

(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'elisp-format)
(require 'prelude-packages)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(TeX-view-program-list '(("Default Viewer" "open %o")))
 '(TeX-view-program-selection
   '(((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Default Viewer")
     (output-html "xdg-open")))
 '(c-basic-offset 2)
 '(c-default-style
   '((c++-mode . "linux")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "gnu")))
 '(coffee-tab-width 4)
 '(column-number-mode t)
 '(elisp-format-column 80)
 '(flymake-coffee-coffeelint-configuration-file (expand-file-name "~/.coffeelint.json"))
 '(indent-tabs-mode nil)
 '(js-indent-level 4)
 '(org-agenda-files (directory-files "~/code/todo" t "\\.org" nil))
 '(package-archives
   '(("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/")))
 '(package-selected-packages
   '(emojify web-mode zenburn-theme yaml-mode web-beautify smex scss-mode sass-mode rust-mode multi-web-mode markdown-mode less-css-mode julia-mode jade-mode haskell-mode go-mode gitignore-mode flymake-coffee flycheck-pyflakes elm-mode elixir-mode company coffee-mode auctex))
 '(require-final-newline t)
 '(scss-compile-at-save nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(install-missing-packages)

;; Set up global shortcuts for Org
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Python Flymake
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'flyspell-prog-mode)
(add-hook 'javascript-mode-hook 'flycheck-mode)
(add-hook 'javascript-mode-hook 'flyspell-prog-mode)
;; Go fmt hook
(add-hook 'before-save-hook 'gofmt-before-save)

;; Clean up whitespace on save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Coffeelint coffee files
(add-hook 'coffee-mode-hook 'flymake-coffee-load)

;; Haskell indentation
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; Spell check
(add-hook 'markdown-mode-hook
          (lambda ()
            (flyspell-mode)))
(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode)))

;; Zenburn theme
(load-theme 'zenburn t)

;; Set font size to 14 pt
(set-face-attribute 'default nil :height 140)

;; Maximize emacs window on start
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Remove that stinkin' toolbar!
(tool-bar-mode -1)

;; Show line numbers on left of window
(global-linum-mode t)
(setq linum-format "%d ")

;; Highlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#313c36")

;; Disable mouse functions in emacs window
(define-minor-mode disable-mouse-mode
  "A minor-mode that disables all mouse keybinds."
  :global t
  :lighter "  "
  :keymap (make-sparse-keymap))

(dolist (type '(mouse down-mouse drag-mouse
                      double-mouse triple-mouse))
  (dolist (prefix '("" C- M- S- M-S- C-M- C-S- C-M-S-))
    ;; Yes, I actually HAD to go up to 7 here.
    (dotimes (n 7)
      (let ((k (format "%s%s-%s" prefix type n)))
        (define-key disable-mouse-mode-map
          (vector (intern k)) #'ignore)))))

(disable-mouse-mode 1)

;; Highlight some common keywords
(defun font-lock-comment-annotations ()
  "Highlight a bunch of well known comment annotations.

This functions should be added to the hooks of major modes for programming."
  (font-lock-add-keywords
   nil '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|OPTIMIZE\\|HACK\\|REFACTOR\\|fix\\(me\\)?\\|todo\\|optimize\\|hack\\|refactor\\):"
          1 font-lock-warning-face t))))

(add-hook 'prog-mode-hook 'font-lock-comment-annotations)

;; Highlight pairs of parens, brackets, etc.
(show-paren-mode 1)

;; Create matching parens, brackets, etc.
(electric-pair-mode 1)

;; Boo, tabs, we use spaces in my house
(setq-default indent-tabs-mode nil)

;; Smex -- Ido for M-x
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                                        ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Ido-mode
(ido-mode t)

;; Syntax highlighting
(global-font-lock-mode 't)

;; Company-mode -- autocompletion
(add-hook 'after-init-hook 'global-company-mode)

;; Multi-web-mode -- change major mode depending on context in a html, js, css file
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

;; Jedi -- python autocompletion
;;(add-hook 'python-mode-hook 'jedi:setup)
;;(setq jedi:complete-on-dot t)

;; Web-beautify -- style linter for web files
(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'web-mode
  '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))
(eval-after-load 'js2-mode
  '(add-hook 'js2-mode-hook
             (lambda ()
               (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(add-hook 'js-mode-hook
             (lambda ()
               (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

(eval-after-load 'json-mode
  '(add-hook 'json-mode-hook
             (lambda ()
               (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

(eval-after-load 'sgml-mode
  '(add-hook 'html-mode-hook
             (lambda ()
               (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))

(eval-after-load 'web-mode
  '(add-hook 'web-mode-hook
             (lambda ()
               (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))

(eval-after-load 'css-mode
  '(add-hook 'css-mode-hook
             (lambda ()
               (add-hook 'before-save-hook 'web-beautify-css-buffer t t))))

;; flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)



(setq flycheck-highlighting-mode 'lines)
(set-face-background 'flycheck-error "#f18c96")
(set-face-foreground 'flycheck-error "black")
(set-face-background 'flycheck-warning "#f8f893")
(set-face-foreground 'flycheck-warning "black")

;; colors in eshell
(add-hook
 'eshell-mode-hook
 (lambda ()
   (setenv "TERM" "emacs") ; enable colors
   ))

;; handy window resize keybinds
(global-set-key (kbd "<C-up>") 'shrink-window)
(global-set-key (kbd "<C-down>") 'enlarge-window)
(global-set-key (kbd "<C-right>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-left>") 'enlarge-window-horizontally)

;; auto insert lisp header when creating a new file
(load-file "~/.emacs.d/lisp/header2.el")
(require 'header2)
(add-hook 'prog-mode-hook 'auto-make-header)


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '((""    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\."))
)


(setq web-mode-enable-current-element-highlight t)

;; Aspell for windows
(setq ispell-program-name "C:\\Users\\Jon\\.emacs.d\\Aspell\\bin\\aspell")

;; MELPA
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(provide 'init.el)
;;; init.el ends here
