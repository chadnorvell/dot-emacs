;; -*- lexical-binding: elisp -*-
(use-package which-key
  :straight t
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-separator " "
        which-key-prefix-prefix "+"
        which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.01
        which-key-max-description-length 32
        which-key-allow-evil-operators t))

(use-package general
  ;; We want this to load after evil, but evil also needs to be loaded eagerly,
  ;; otherwise these macros won't exist when subsequent scripts are loaded, and
  ;; using definers outside of this file won't work.
  :straight t
  :after evil
  :config
  (require 'core-functions)

  (general-define-key
   "C-'"       'embark-act
   "C-;"       'embark-dwim
   "M-<up>"    'scroll-other-window-down
   "M-<down>"  'scroll-other-window
   "M-<left>"  'winner-undo
   "M-<right>" 'winner-redo)

  (general-create-definer cxn/ctrl-x-def :prefix "C-x")
  (cxn/ctrl-x-def
    "b" 'consult-buffer
    "/" 'consult-ripgrep
    ">" 'vterm)

  (general-define-key
   :states '(normal insert motion visual emacs)
   :keymaps 'override
   :prefix-map 'cxn/leader-map
   :prefix "SPC"
   :non-normal-prefix "M-SPC")

  (general-create-definer cxn/leader-def :keymaps 'cxn/leader-map)
  (cxn/leader-def "" nil)

  (general-create-definer cxn/major-def
    :states '(normal insert motion visual emacs)
    :keymaps 'override
    :major-modes t
    :prefix "SPC m"
    :non-normal-prefix "M-SPC m")

  (cxn/major-def "" nil)

  (cxn/leader-def
    ";"     '("eval"        . eval-expression)
    "!"     '("shell"       . shell-command)
    ">"     '("term"        . vterm)
    ;; "."     '("find"        . consult-fzf)
    "/"     '("search"      . consult-ripgrep)
    "?"     '("replace"     . query-replace)

    "m"     (cons "major" (make-sparse-keymap))

    "b"   (cons "buffers" (make-sparse-keymap))
    "bb"    '("switch"            . consult-buffer)
    ;; "bp"    '("switch in project" . consult-projectile-switch-to-buffer)
    "br"    '("reload"            . revert-buffer-no-confirm)
    "bd"    '("kill"              . kill-current-buffer)
    "bx"    '("kill with window"  . kill-buffer-and-window)

    "e"   (cons "frames" (make-sparse-keymap))
    "ee"    '("new"         . make-frame)
    "ed"    '("kill"        . delete-frame)
    "eD"    '("kill others" . delete-other-frames)
    "en"    '("next"        . other-frame)

    "f"   (cons "files" (make-sparse-keymap))
    "fb"    '("dired"           . dired-jump)
    "ff"    '("find"            . affe-find)
    "fg"    '("search"          . rg)
    "fs"    '("save"            . save-buffer)
    "fd"    '("dirvish"         . dirvish)

    "p"   (cons "project" (make-sparse-keymap))
    "pp"    '("switch"  . project-switch-project)
    "pb"    '("buffers" . consult-project-buffer)
    "pd"    '("dired"   . project-dired)
    "pf"    '("files"   . project-find-file)
    "pg"    '("search"  . consult-ripgrep)
    "pG"    '("git"     . magit-project-status)
    "pk"    '("kill"    . project-kill-buffers)
    "pr"    '("regexp"  . project-find-regexp)
    "ps"    '("search"  . consult-ripgrep)

    "q"   (cons "quit" (make-sparse-keymap))
    "qq"    '("quit"    . save-buffers-kill-emacs)
    "qQ"    '("kill"    . kill-emacs)
    "qr"    '("restart" . restart-emacs)

    "w"   (cons "window" (make-sparse-keymap))
    "wd"    '("kill"        . delete-window)
    "wD"    '("kill others" . delete-other-windows)
    "w<"    '("shrink fit"  . shrink-window-if-larger-than-buffer)
    "w="    '("balance"     . balance-windows)
    "wm"  (cons "switch" (make-sparse-keymap))
    "wmh"   '("←"          . evil-window-left)
    "wmj"   '("↓"          . evil-window-down)
    "wmk"   '("↑"          . evil-window-up)
    "wml"   '("→"          . evil-window-right)
    "ws"  (cons "split" (make-sparse-keymap))
    "wsh"   '("←"          . split-window-right)
    "wsj"   '("↓"          . split-window-below-and-focus)
    "wsk"   '("↑"          . split-window-below)
    "wsl"   '("→"          . split-window-right-and-focus)
    )
  )

(use-package evil
  :straight t
  ;; Load evil eagerly so that general is loaded eagerly.
  :demand t
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)     ; Required for evil-collection
  (setq evil-undo-system 'undo-redo))  ; Use the standard Emacs 29+ undo

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :straight t
  :after evil
  :hook ((text-mode prog-mode conf-mode) . evil-surround-mode))

;; (use-package dired
;;   :config
;;   (with-eval-after-load 'evil
;;     (evil-set-initial-state 'vterm-mode 'emacs)))

(provide 'core-keybindings)
