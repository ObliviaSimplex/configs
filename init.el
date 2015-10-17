
;; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; populate the load path:
(add-to-list 'load-path "~/.emacs.d/elpa")
(add-to-list 'load-path "/usr/lib/chicken/7/") ; where Eggs are stored?
(add-to-list 'load-path "~/.emacs.d/emacs-bash-completion")
(add-to-list 'load-path "~/.emacs.d/slime-master")
;;(add-to-list 'load-path "~/.emacs.d/other-packages/nand2tetris")
(add-to-list 'load-path "~/.emacs.d/other-packages/vhdl-mode-3.38.1")
(add-to-list 'load-path "~/.emacs.d/hoon-mode.el")
;; Only use the next three lines when porting this to FreeBSD:
;; (normal-erase-is-backspace-mode 0)
;; (global-set-key (kbd "C-h") 'delete-backward-char)
;; (global-set-key (kbd "M-[ e") 'delete-forward'char)



;; Get rid of some of the extra GUI clutter, when in X mode.

;;; code

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; load up the packages:

;; set up unicode fonts. This will add quite a bit of time to the initial
;; startup in the GUI, but shouldn't be a big problem, since the daemon
;; will be taking care of it.

(setq inferior-lisp-program "/usr/bin/sbcl")

;; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
(require 'hoon-mode)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; Setup load-path, autoloads and your lisp system
;; Not needed if you install SLIME via MELPA
(require 'slime-autoloads)
(require 'slime)
(slime-setup '(slime-fancy slime-banner))
(autoload 'chicken-slime "chicken-slime" "SWANK backend for Chicken" t)
;; we also want to enable SLIME minor mode in Scheme files:
(add-hook 'scheme-mode-hook
          (lambda ()            (slime-mode t)))
(setq slime-csi-path "/usr/bin/csi")

;;bash completion
(require 'bash-completion)

;;(require 'nand2tetris.el)
;; for syntax hilighting
(require 'vhdl-mode)
;;(require 'mu)

;;activate the handy ido mode, to tab through buffers and files
(require 'ido)
(ido-mode t)
;;; let's use lusty instead. ido's autocomplete can be a pain in the ass
;;; sometimes. 

(require 'undo-tree)
(undo-tree-mode t)

;; tramp will hang if the prompt of the remote shell contains ansi
;; escape sequences, etc., unless we do this:
(require 'tramp)
(setq tramp-debug-buffer t)
(setq shell-prompt-pattern ".*[\#\$].*")

;; set eww to be the default browser
(setq browse-url-browser-function 'eww-browse-url)


(autoload 'cobol-mode "cobol-mode" "A major mode for editing ANSI Cobol/Scobol files." t nil)

;; (require 'lusty-explorer)

;; learn vim keybindings!

(require 'evil)
;(evil-mode 1)


;; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;; Some behaviour preferences


(setq global-hl-line-mode nil)
(setq-default indent-tabs-mode nil)
(setq sentence-end-double-space nil) ;; let single spaces end sentences


(setq next-line-add-newlines t)
;; make C-n add a new line if point is already at end of line

(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)

;; let me type y instead of yes, n instead of no
(defalias 'yes-or-no-p 'y-or-n-p)



;; Ignore case when using completion for file names:
(setq read-file-name-completion-ignore-case t)

(line-number-mode 1)
(column-number-mode 1)


(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time


;; shell settings

(setenv "PAGER" "cat")

;; Custom functions, modes, and keybindings

(defun screenshot ()
  "Prompt for a filename, then call up scrot to create an interactive screenshot"
  (interactive)
  (let ((imgfile (read-string "Filename? " "scr.jpg" 'my-history)))
    (insert "\nfile://" imgfile "\n" )
    (start-process "scrot" nil "/usr/bin/scrot" "-s" imgfile)
    ))


(define-derived-mode text-img-mode text-mode "Image display mode"
  (auto-fill-mode)
  (turn-on-iimage-mode)
  (iimage-mode-buffer t)
  (local-set-key (kbd "C-c i")
                 (lambda () (interactive) (iimage-mode-buffer t)))
  (local-set-key (kbd "C-c s")
                 'screenshot)
  )


(defun img ()
  "Prompt for a filename, then call up mypaint to create an image"
  (interactive)
  (let ((imgfile (read-string "Filename? " "xxx.jpg" 'my-history)))
    (insert "\nfile://" imgfile "\n" )
    (start-process "mypaint" nil "/usr/bin/mypaint" imgfile)
    ))


;; (defun my/iimage-mode-refresh--eshell/cat (orig-fun &rest args)
;;   "Display image when using cat on it."
;;   (let ((image-path (cons default-directory iimage-mode-image-search-path)))
;;     (dolist (arg args)
;;       (let ((imagep nil)
;;             file)
;;         (with-silent-modifications
;;           (save-excursion
;;             (dolist (pair iimage-mode-image-regex-alist)
;;               (when (and (not imagep)
;;                          (string-match (car pair) arg)
;;                          (setq file (match-string (cdr pair) arg))
;;                          (setq file (locate-file file image-path)))
;;                 (setq imagep t)
;;                 (add-text-properties 0 (length arg)
;;                                      `(display ,(create-image file)
;;                                                modification-hooks
;;                                                (iimage-modification-hook))
;;                                      arg)
;;                 (eshell-buffered-print arg)
;;                 (eshell-flush)))))
;;         (when (not imagep)
;;           (apply orig-fun (list arg)))))
;;     (eshell-flush)))

;; (advice-add 'eshell/cat :around #'my/iimage-mode-refresh--eshell/cat4

(defun split-windows-and-open-shell ()
  (interactive)
  (delete-other-windows)
  (split-window-right)
  ;(run-python)
  (other-window 1)
  (ielm)
  (split-window-below)
  (other-window 1)
  (shell)
  (insert "cal && todo read"))

(defun doc-view-page-down-next-window ()
  (interactive)
  (other-window)
  (doc-view-next-page)
  (other-window -1)
  )

(defun doc-view-page-up-next-window ()
  (interactive)
  (other-window 1)
  (doc-view-previous-page)
  (other-window -1)
  )

(defun make-border ()
  (interactive)
  (border-chain 34))

(defun border-chain (reps)
  (interactive)
  (insert "=-")
  (if (> reps 0)
      (border-chain (- reps 1))
    (insert "=")))

(defun shrug ()
  (interactive)
  (insert "¯\\_(ツ)_/¯")
  )

(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-filename)))

(defun simple-shellcode ()
  (interactive)
  (insert "\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x50\\x53\\x89\\xe1\\x89\\xc2\\xb0\\x0b\\xcd\\x80"))

(defun shellcode-64 ()
  (interactive)
  (insert "\\x48\\x31\\xd2\\x48\\xbb\\xff\\x2f\\x62\\x69\\x6e\\x2f\\x73\\x68\\x48\\xc1\\xeb\\x08\\x53\\x48\\x89\\xe7\\x48\\x31\\xc0\\x50\\x57\\x48\\x89\\xe6\\xb0\\x3b\\x0f\\x05\\x6a\\x01\\x5f\\x6a\\x3c\\x58\\x0f\\x05"))


(defcustom smart-to-ascii '(("\x201C" . "\"")
                            ("\x201D" . "\"")
                            ("\x2018" . "'")
                            ("\x2019" . "'")
                            ;; en-dash
                            ("\x2013" . "-")
                            ;; em-dash
                            ("\x2014" . "-"))
  "Map of smart quotes to their replacements"
  :type '(repeat (cons (string :tag "Smart Character  ")
                       (s412ing :tag "Ascii Replacement"))))

(defun smart-to-ascii (beg end)
  "Replace smart quotes and dashes with their ASCII equivalents"
  (interactive "r")
  (format-replace-strings smart-to-ascii
                          nil beg end))


;; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-412
(global-set-key (kbd "C-x C-g") 'sudo-find-file)
(global-set-key (kbd "C-c h") 'shrug)
(global-set-key "\M-k" '(lambda () (interactive) (kill-line 0)) )
;; M-k kills to the left
(global-set-key (kbd "C-M-<next>") 'doc-view-page-down-next-window)
(global-set-key (kbd "C-M-<prior>") 'doc-view-page-up-next-window)
(global-set-key (kbd "<f2>") 'eshell)
(global-set-key (kbd "<f412>") 'menu-bar-mode)
(global-set-key (kbd "<f11>") '(lambda () (interactive)
                                 (find-file
                                  "~/.emacs.d/init.el")))
;;(global-set-key (kbd "C-<f11>") '(lambda () interactive)
;;                (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f10>") 'evil-mode)
(global-set-key (kbd "<f9>") 'linum-mode)
(global-set-key (kbd "<f12>") 'eval-buffer)
(global-set-key (kbd "C-x C-u") 'undo)
(global-set-key (kbd "C-c p") 'run-python)
(global-set-key (kbd "<f8>") 'enlarge-window)
(global-set-key (kbd "<f7>") 'shrink-window)
(global-set-key (kbd "<f6>") 'enlarge-window-horizontally)
(global-set-key (kbd "<f5>") 'shrink-window-horizontally)
(global-set-key (kbd "C-q") 'shell)
(global-set-key (kbd "M-j") 'join-line)
(global-set-key (kbd "C-c b") 'make-border)
(global-set-key (kbd "C-x u") 'upcase-region)
(global-set-key (kbd "M-/") 'comment-region)
(global-set-key (kbd "M-?") 'uncomment-region)
(global-set-key (kbd "M-s M-s") 'simple-shellcode)
(global-set-key (kbd "M-s M-x") 'shellcode-64)
(global-set-key (kbd "C-c f") 'figlet)
(global-set-key (kbd "C-c C-f") 'figlet-figletify-region)
(global-set-key (kbd "<menu>") 'undo) ;; ;;
(global-set-key (kbd "C-c k") 'browse-kill-ring)
;; set search and replace to use regexes
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-%") 'query-replace-regexp)
;;(global-set-key (kbd "C-x C-f") 'lusty-file-explorer)



;;; esc quits

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)


;; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;;; prettification
(setq linum-format "%4d \u2551 ")

(when (boundp 'global-prettify-symbols-mode)
  (add-hook 'text-mode-hook


            (lambda ()
              (progn
                (auto-fill-mode)
                (push '("inf" . ?∞) prettify-symbols-alist)
                (push '("Sum" . ?∑) prettify-symbols-alist)
                (push '("aleph" . ?ℵ) prettify-symbols-alist)
                (push '("phi" . ?φ) prettify-symbols-alist)
                (push '("Theta" . ?ϴ) prettify-symbols-alist)
                (push '("Omega" . ?Ω) prettify-symbols-alist)
                (push '("omega" . ?ω) prettify-symbols-alist)
                (push '("forall" . ?∀) prettify-symbols-alist)
                (push '("exists" . ?∃) prettify-symbols-alist)
                (push '(">=" . ?≥) prettify-symbols-alist)
                (push '("<=" . ?≤) prettify-symbols-alist)
                (push '("\\in". ?∊) prettify-symbols-alist))))
  (global-prettify-symbols-mode 1))



;; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-text-browser "eww")
 '(custom-safe-themes
   (quote
    ("90e4b4a339776e635a78d398118cb782c87810cb384f1d1223da82b612338046" "5d1434865473463d79ee0523c1ae60ecb731ab8d134a2e6f25c17a2b497dd459" "05c3bc4eb1219953a4f182e10de1f7466d28987f48d647c01f1f0037ff35ab9a" "3ff96689086ebc06f5f813a804f7114195b7c703ed2f19b51e10026723711e33" "cd032f7f4d0a6219bc9decab7fe557944449cb2252696acb69d013db8d3c697" default)))
 '(inhibit-startup-screen t)
 '(send-mail-function nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(autoload 'mu-open "mu" "Play on MUSHes and MUDs" t)
;;(add-hook 'mu-connection-mode-hook 'ansi-color-for-comint-mode-on)



;; highlight the active buffer
;; make this contingent on terminal mode
(set-face-attribute  'mode-line
                 nil
                 :foreground "cyan"
                 :background "black"
                 :box '(:line-width 1 :style released-button))
(set-face-attribute  'mode-line-inactive
                 nil
                 :foreground "white"
                 :background "black"
                 :box '(:line-width 1 :style released-button))

;(load-theme 'gruvbox)


(put 'scroll-left 'disabled nil)



;;(unicode-fonts-setup)


;; end

