(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; disable vc-git
(setq vc-handled-backends ())

;; :weight bold

;; Turn off annoying splash screen
(setq inhibit-splash-screen t)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;;; cperl-mode is perfered to perl-mode
(defalias 'perl-mode 'cperl-mode)

(fset 'back-one-window "\C-u-1\C-xo")
(global-set-key "\C-xn" 'other-window)
(global-set-key "\C-xp" 'back-one-window)
;(global-set-key [f29] 'scroll-down)
;(global-set-key [f35] 'scroll-up)
;(global-set-key [f31] 'recenter)
(global-set-key "\M- " 'set-mark-command)
(global-set-key "\C-x\C-e" 'shell)

(fset 'control-zee "\C-n\C-u\C-l")
(fset 'meta-zee "\C-p\C-u\C-l")
(global-set-key "\C-z" 'control-zee)
(global-set-key "\M-z" 'meta-zee)
(global-set-key "\M-q" 'fill-paragraph)
(global-set-key "\M-s" 'center-line)
(global-set-key [delete] 'delete-char)  ; the DEL key is called delete, not DEL
;(global-set-key [C-?] 'delete-char)  ; But it is called DEL when DISPLAY not set

; Fix up Help to be on F1, so that ^H can be backspace
(global-set-key "\C-x?" 'help-command)
(global-set-key "\C-h" 'backward-delete-char)

(global-set-key [f1] 'help-command)
(global-set-key [f2] 'call-last-kbd-macro)
(global-set-key [f3] 'revert-buffer)
(global-set-key [f4] 'blink-matching-open)
(fset 'untab-line "\C-a\C-d\C-n")
(global-set-key [f5] 'untab-line)
(fset 'tab-line "\C-a\C-i\C-e\M-\\\C-a\C-n")
(global-set-key [f6] 'tab-line)
(global-set-key [f7] 'save-buffer)
(global-set-key [f8] 'save-buffers-kill-emacs)
; (define 'set-tabs-of-4 (set-variable 'tab-width 4))
(defun set-tabs-of-4 () (interactive) (set-variable 'tab-width 4))
(global-set-key [f9] 'set-tabs-of-4)
; (global-set-key [f9] 'cperl-mode)
(global-set-key [f10] 'fundamental-mode)
(global-set-key [f11] 'text-mode)
; (global-set-key [SunF36] 'enlarge-window)
(global-set-key [f12] 'gdb)
; (global-set-key [SunF37] 'gdb)

(global-set-key [f1] 'next-error)
(global-set-key [f4] 'compile)
(global-set-key [f3] 'recompile)

(fset 'copy-all "\M->\M- \M-<\M-w")
(global-set-key [?\C-x f4] 'copy-all)

(global-set-key [insertchar] 'overwrite-mode)

(set-variable 'next-line-add-newlines ())
(line-number-mode "1")
;; (tool-bar-mode)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(add-hook 'c-mode-hook 'remove-dos-eol)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(backup-by-copying-when-linked t)
 '(c-basic-offset 8)
 '(c-offsets-alist (quote ((substatement-open . 0))))
 '(cperl-brace-offset -4)
 '(cperl-continued-statement-offset 4)
 '(cperl-extra-newline-before-brace t)
 '(cperl-indent-level 4)
 '(ediff-diff-options "-w")
 '(ediff-make-buffers-readonly-at-startup t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(inhibit-default-init t)
 '(require-final-newline nil)
 '(haskell-mode-hook '(turn-on-haskell-indentation))
;; '(haskell-mode-hook '(turn-on-haskell-indent))
;; haskell-mode-hook is a variable defined in `haskell-mode.el'.  Set it to Nil
;; '(haskell-mode-hook '(turn-on-haskell-simple-indent))
 '(tool-bar-mode nil))
