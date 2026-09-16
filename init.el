;; -*- lexical-binding: elisp -*-
;; Add lisp subdirectory to load path.
(dolist (dir '("lisp"))
  (push (expand-file-name dir user-emacs-directory) load-path))

;; Don't store custom-set-* here.
(setq custom-file (concat user-emacs-directory "/custom.el"))

(setq coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8
      delete-old-versions -1
      inhibit-startup-echo-area-message t
      inhibit-startup-message t
      inhibit-startup-screen t
      initial-scratch-message ""
      make-backup-files nil
      ring-bell-function 'ignore
      sentence-end-double-space nil
      use-short-answers t)

(setq-default mode-line-format nil)

(defun display-startup-echo-area-message ()
  (message ""))

(pixel-scroll-precision-mode 1)
(savehist-mode 1)
(global-auto-revert-mode t)
(electric-pair-mode 1)
(winner-mode 1)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
(add-hook 'prog-mode-hook 'toggle-truncate-lines)

(require 'core-functions)
(require 'core-keybindings)
(require 'core-code)
(require 'core-ux)
(require 'core-projects)
(require 'core-tools)
(require 'mode-elisp)
(require 'mode-fish)
(require 'mode-nix)
