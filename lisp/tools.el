;; -*- lexical-binding: t -*-

(use-package project
  :straight t
  :config
  (project-remember-projects-under "~/dev")
  (setq project-kill-buffers-display-buffer-list 't)

  (setq project-vc-extra-root-markers 
        '("go.mod" "package.json" "flake.nix" "cargo.toml" "mix.exs"))

  (setq project-switch-commands
        '((project-find-file "files" "f")
          (project-find-regexp "regexp" "s")
          (project-dired "dired" "d")
          (magit-project-status "git" "g"))))

;; completion
(use-package consult
  :straight t
  :after general
  :config
  (setq consult-preview-key 'any))

;; vertical completion mini-buffer
(use-package vertico
  :straight t
  :init
  (vertico-mode))

;; in-buffer completion
(use-package corfu
  :straight t
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator)
  :config
  (global-corfu-mode))

;; more completion functions
(use-package cape
  :straight t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; annotations in completion mini-buffer
(use-package marginalia
  :straight t
  :config
  (marginalia-mode 1))

;; space-separated component completion matching
(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))
;; (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; context-triggered actions
(use-package embark
  :straight t
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :straight t
  :after (embark consult)
  :demand t)

;; jump to text
(use-package avy
  :straight t
  :demand t)

;; async fuzzy finding
(use-package affe
  :straight t
  :after consult)

;; ripgrep-based grep buffer
(use-package rg
  :straight t
  :config
  (rg-enable-default-bindings))

;; editable grep buffer for replacements
(use-package wgrep
  :straight t
  :config
  (setq wgrep-auto-save-buffer t))

;; structured editing
(use-package puni
  :straight t)

;; terminal
(use-package vterm
  :straight t
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'vterm-mode 'emacs)))

(use-package dired
  :config
  ;; (with-eval-after-load 'evil
  ;;   (evil-set-initial-state 'dired-mode 'emacs))
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  ;; this command is useful when you want to close the window of `dirvish-side'
  ;; automatically when opening a file
  (put 'dired-find-alternate-file 'disabled nil))

;; file browser
(use-package dirvish
  :straight t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries
   '(("c" "~/calcbase/calcbase/"            "calcbase")
     ("d" "~/dev/"                          "dev")
     ("e" "~/nix/modules/users/chad/emacs/" "emacs")
     ("n" "~/nix/"                          "nix")))
  :config
  ;; (setq dirvish-attributes '(vc-face version-control icons collapse file-size))
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size)))

;; git
(use-package magit
  :straight t
  :config
  (require 'magit-extras))

(use-package git-gutter
  :straight t
  :init
  (global-git-gutter-mode +1))

;; buffer-local direnv resolution
(use-package envrc
  :straight t
  :hook (after-init . envrc-global-mode))

;; buffer-local direnv resolution for temp buffers
(use-package inheritenv
  :straight t
  :demand t)

(use-package savehist
  :init
  (savehist-mode))

(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(provide 'tools)
