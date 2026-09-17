;; -*- lexical-binding: elisp -*-
(use-package magit
  :straight t
  :config
  (require 'magit-extras)

  :general
  (cxn/leader-def
    "g"   (cons "git" (make-sparse-keymap))
    "gg"    '("status"       . magit-status)
    "gb"    '("blame"        . magit-blame)
    "gd"    '("diff"         . magit-diff)
    "g+"    '("stage file"   . magit-stage-file)
    "g-"    '("unstage file" . magit-unstage-file)))

(use-package dirvish
  :straight t
  :config
  (dirvish-override-dired-mode)
  (setq dirvish-attributes '(vc-face version-control icons collapse file-size)))

(use-package rg
  :straight t
  :config
  (rg-enable-default-bindings))

(use-package wgrep
  :straight t
  :config
  (setq wgrep-auto-save-buffer t))

(use-package vterm
  :straight t
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'vterm-mode 'emacs)))

(use-package inheritenv
  :straight t
  :demand t)

(use-package envrc
  :straight t
  :hook (after-init . envrc-global-mode))

(provide 'core-tools)
