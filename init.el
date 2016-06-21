;;; package --- .emacs -> My Emacs config

;;; Commentary:
;;; Author: Jon Simington
;;; Last revised: Time-stamp: <2016-06-21 17:08:34 (JOSIMINGTON)>


;;; Code:

;;; Time stamp file on-save
(defvar time-stamp-active t)
(defvar time-stamp-line-limit 10)  ; only check first 10 buffer lines for Time-stamp:
(defvar time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)")
(add-hook 'before-save-hook 'time-stamp)

;; Hide welcome screen
(setq inhibit-startup-message t)

;; Default find file path
(setq default-directory "C:\\Users\\josimington\\")

(add-to-list 'load-path "~/")
(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'elisp-format)
(require 'prelude-packages)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(TeX-view-program-list (quote (("Default Viewer" "open %o"))))
 '(TeX-view-program-selection
   (quote
    (((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Default Viewer")
     (output-html "xdg-open"))))
 '(c-basic-offset 2)
 '(c-default-style
   (quote
    ((c++-mode . "linux")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "gnu"))))
 '(coffee-tab-width 4)
 '(column-number-mode t)
 '(elisp-format-column 80)
 '(flymake-coffee-coffeelint-configuration-file (expand-file-name "~/.coffeelint.json"))
 '(indent-tabs-mode nil)
 '(js-indent-level 4)
 '(org-agenda-files (directory-files "~/code/todo" t "\\.org" nil))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/")
     )))
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

(provide '.emacs)
;;; .emacs ends here
