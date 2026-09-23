;; -*- lexical-binding: t -*-

(use-package evil
  :straight t
  ;; Load evil eagerly so that general is loaded eagerly.
  :demand t
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)      ; Required for evil-collection
  (setq evil-undo-system 'undo-redo)   ; Use the standard Emacs 29+ undo
  :config
  (evil-define-key '(normal visual) 'global "gc" 'comment-line))

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :straight t
  :after evil
  :hook ((text-mode prog-mode conf-mode) . evil-surround-mode))

(use-package general
  ;; We want this to load after evil, but evil also needs to be loaded eagerly,
  ;; otherwise these macros won't exist when subsequent scripts are loaded, and
  ;; using definers outside of this file won't work.
  :straight t
  :after evil
  :config
  (require 'cxn/funcs)

  (general-define-key
   "C-'"        'embark-act
   "C-\""       'embark-dwim
   "C-<tab>"    'embark-bindings
   "C-<return>" 'completion-at-point
   "C-/"        'eldoc-box-help-at-point
   "C-;"        'apheleia-format-buffer
   "C-="        'make-frame
   "C-`"        'other-frame

   "M-h"        'evil-window-left
   "M-j"        'evil-window-down
   "M-k"        'evil-window-up
   "M-l"        'evil-window-right

   "C-<down>"   'split-window-below-and-focus
   "C-<up>"     'split-window-below
   "C-<left>"   'split-window-right
   "C-<right>"  'split-window-right-and-focus

   "M-<up>"     'scroll-other-window-down
   "M-<down>"   'scroll-other-window
   "M-<left>"   'winner-undo
   "M-<right>"  'winner-redo)

  (general-define-key
   :states '(normal emacs)
   :keymaps 'dired-mode-map
   "a" 'dirvish-quick-access
   "b" 'find-file)

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
    ;; "."     '("find"        . consult-fzf)  ;; repeat search
    "/"     '("search"      . consult-ripgrep)
    "?"     '("replace"     . query-replace)
    ">"     '("term"        . vterm)

    "m"   (cons "major" (make-sparse-keymap))

    "a"   (cons "actions" (make-sparse-keymap))
    "aa"    '("default"     . embark-dwim)
    "ac"    '("collect"     . embark-collect)
    "al"    '("select"      . embark-act)

    "b"   (cons "buffers" (make-sparse-keymap))
    "bb"    '("switch"           . consult-buffer)
    "bf"    '("format"           . apheleia-format-buffer)
    "bl"    '("format via lsp"   . eglot-format-buffer)
    "bp"    '("project"          . consult-project-buffer)
    "br"    '("reload"           . revert-buffer-no-confirm)
    "bd"    '("kill"             . kill-current-buffer)
    "bx"    '("kill with window" . kill-buffer-and-window)

    "c"   (cons "code" (make-sparse-keymap))
    "ca"    '("actions"         . eglot-code-actions)
    "cc"    '("completion"      . completion-at-point)
    "cf"    '("definition"      . xref-find-definitions)
    "ci"    '("declaration"     . eglot-find-declaration)
    "ch"    '("docs"            . eldoc-box-help-at-point)
    "cH"    '("docs buffer"     . eldoc)
    "cm"    '("implementations" . eglot-find-implementations)
    "cn"    '("rename"          . eglot-rename)
    "cr"    '("references"      . xref-find-references)
    "ct"    '("type definition" . eglot-find-typeDefinition)

    "d"    (cons "describe" (make-sparse-keymap))
    "db"     '("bindings"       . embark-bindings)
    "dc"     '("command"        . helpful-command)
    "dd"     '("at point"       . helpful-at-point)
    "df"     '("function"       . helpful-function)
    "dl"     '("callable"       . helpful-callable)
    "dm"     '("macro"          . helpful-macro)
    "do"     '("mode"           . describe-mode)
    "ds"     '("symbol"         . describe-symbol)
    "dv"     '("variable"       . helpful-variable)
    "dk"     (cons "key" (make-sparse-keymap))
    "dkk"      '("briefly"      . describe-key-briefly)
    "dkm"      '("map"          . describe-keymap)
    "dkv"      '("verbosely"    . helpful-key)

    "e"   (cons "frames" (make-sparse-keymap))
    "ec"    '("kill"        . delete-frame)
    "ee"    '("new"         . make-frame)
    "eo"    '("kill others" . delete-other-frames)
    "en"    '("next"        . other-frame)

    "f"   (cons "files" (make-sparse-keymap))
    "fb"    '("browse"  . dirvish-dwim)
    "ff"    '("find"    . affe-find)
    "fg"    '("search"  . rg)
    "fm"    '("manager" . dirvish)
    "fs"    '("save"    . save-buffer)

    "g"   (cons "git" (make-sparse-keymap))
    "ga"    '("cherry-pick" . magit-cherry-pick)
    "gb"    '("branch"      . magit-branch)
    "gc"    '("bisect"      . magit-bisect)
    "gd"    '("diff"        . magit-diff)
    "ge"    '("blame"       . magit-blame)
    "gf"    '("fetch"       . magit-fetch)
    "gg"    '("status"      . magit-status)
    "gm"    '("remote"      . magit-remote)
    "gp"    '("push"        . magit-push)
    "gr"    '("rebase"      . magit-rebase)
    "gt"    '("tag"         . magit-tag)
    "gu"    '("pull"        . magit-pull)
    "gz"    '("worktree"    . magit-worktree)

    "n"   (cons "nav" (make-sparse-keymap))
    "nl"   '("line"   . avy-goto-line)
    "nc"   '("char 1" . avy-goto-char)
    "nd"   '("char 2" . avy-goto-char-2)
    "ne"   '("char N" . avy-goto-char-timer)
    "nw"   '("word 1" . avy-goto-word-1)
    "nx"   '("word 2" . avy-goto-char-2)
    "ny"   '("word 0" . avy-goto-word-0)

    "o"   (cons "org" (make-sparse-keymap))
    "oa"    '("agenda"  . org-agenda)
    "oc"    '("capture" . org-capture)

    "p"   (cons "project" (make-sparse-keymap))
    "pd"    '("dired"     . project-dired)
    "pf"    '("files"     . project-find-file)
    "pg"    '("search"    . consult-ripgrep)
    "pg"    '("git"       . magit-project-status)
    "pp"    '("switch"    . project-switch-project)
    "p/"    '("search"    . consult-ripgrep)
    "pb"    (cons "buffers" (make-sparse-keymap))
    "pbl"     '("list"    . consult-project-buffer)
    "pbk"     '("kill"    . project-kill-buffers)

    "q"   (cons "quit" (make-sparse-keymap))
    "qq"    '("quit"    . save-buffers-kill-emacs)
    "qr"    '("restart" . restart-emacs)
    "qx"    '("kill"    . kill-emacs)

    "t"   (cons "text" (make-sparse-keymap))
    "td"    '("downcase"      . downcase-dwim)
    "ts"    '("sedit"         . hydra-sedit/body)
    "tu"    '("upcase"        . upcase-dwim)
    "tk"    (cons "kill" (make-sparse-keymap))
    "tkc"     '("comment"     . kill-comment)
    "tkp"     '("paragraph"   . kill-paragraph)
    "tkr"     '("region"      . kill-region)
    "tks"     '("sentence"    . kill-sentence)
    "tkw"     '("word"        . kill-word)
    "tkx"     '("sexp"        . kill-sexp)
    "tkb"     (cons "backward" (make-sparse-keymap))
    "tkbp"      '("paragraph" . backward-kill-paragraph)
    "tkbs"      '("sentence"  . backward-kill-sentence)
    "tkbw"      '("word"      . backward-kill-word)
    "tkbx"      '("sexp"      . backward-kill-sexp)

    "w"   (cons "window" (make-sparse-keymap))
    "wc"    '("kill"        . delete-window)
    "wo"    '("kill others" . delete-other-windows)
    "wr"    '("resize"      . hydra-window/body)
    "w<"    '("shrink fit"  . shrink-window-if-larger-than-buffer)
    "w="    '("balance"     . balance-windows)
    "wm"    (cons "switch" (make-sparse-keymap))
    "wmh"     '("←"        . evil-window-left)
    "wmj"     '("↓"        . evil-window-down)
    "wmk"     '("↑"        . evil-window-up)
    "wml"     '("→"        . evil-window-right)
    "ws"    (cons "split" (make-sparse-keymap))
    "wsh"     '("←"        . split-window-right)
    "wsj"     '("↓"        . split-window-below-and-focus)
    "wsk"     '("↑"        . split-window-below)
    "wsl"     '("→"        . split-window-right-and-focus)

    "-"   '("toggle" . hydra-toggle/body)
    )
  )

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

(use-package hydra
  :straight t)

(defhydra hydra-evil-structured-text (:color pink)
  "evil structured text"
  ("x" puni-forward-delete-char)
  ("X" puni-backward-delete-char)
  ("dw" puni-forward-kill-word)
  ("db" puni-backward-kill-word)
  ("D" puni-kill-line)
  ("d0" puni-backward-kill-line)
  ("d^" puni-backward-kill-line)
  ("<escape>" nil :color blue)
  ("q" nil :color blue))

(defhydra hydra-sedit (:color pink :hint nil)
  "
_j_ ↤ mv prev/next ↦ _k_
_h_ ⇤ mv begin/end ⇥ _l_

_,_ ↚   del char   ↛ _._
_<_ ↚   del word   ↛ _>_
_[_ ↚   del line   ↛ _]_

_H_  (x  y)  ←   x (y)
_J_   x (y)  ←  (x  y)
_K_  (x  y)  →  (x) y
_L_  (x) y   →  (x  y)

⭦ _r_aise        _s_plit
↕ _c_onvolute    s_p_lice
↔ _t_ranspose"
  ("<escape>" nil :color blue)
  ("q"        nil :color blue)
  ("h" puni-beginning-of-sexp)
  ("j" puni-backward-sexp)
  ("k" puni-forward-sexp)
  ("l" puni-end-of-sexp)
  ("," puni-backward-delete-char)
  ("<" puni-backward-kill-word)
  ("." puni-forward-delete-char)
  (">" puni-forward-kill-word)
  ("]" puni-kill-line)
  ("[" puni-backward-kill-line)
  ("H" puni-slurp-backward)
  ("J" puni-barf-backward)
  ("K" puni-barf-forward)
  ("L" puni-slurp-forward)
  ("r" puni-raise)
  ("c" puni-convolute)
  ("t" puni-transpose)
  ("s" puni-split)
  ("p" puni-splice))

(defhydra hydra-window (:color red :hint nil)
  "
text scale: _+_ / _-_ / _0_
theme: ligh_t_ / _d_ark

     focus    resize
←     _h_      _<left>_
↓     _j_      _<down>_
↑     _k_       _<up>_
→     _l_      _<right>_
"
  ("="         text-scale-increase)
  ("+"         text-scale-increase)
  ("-"         text-scale-decrease)
  ("t"         (load-theme 'doom-gruvbox-light))
  ("d"         (load-theme 'doom-material))
  ("0"         (text-scale-adjust 0))
  ("h"         evil-window-left)
  ("j"         evil-window-down)
  ("k"         evil-window-up)
  ("l"         evil-window-right)
  ("<left>"    (window-move-splitter-left 16))
  ("<down>"    (window-move-splitter-down 16))
  ("<up>"      (window-move-splitter-up 16))
  ("<right>"   (window-move-splitter-right 16))
  ("S-<left>"  window-move-splitter-left)
  ("S-<down>"  window-move-splitter-down)
  ("S-<up>"    window-move-splitter-up)
  ("S-<right>" window-move-splitter-right))

(use-package pretty-hydra
  :straight t
  :demand t
  :config
  (pretty-hydra-define
    hydra-toggle
    (:color red :quit-key "q")
    ("Toggle"
     (("a" apheleia-mode                      "apheleia"         :toggle t)
      ("g" git-gutter-mode                    "git gutter"       :toggle t)
      ("n" display-line-numbers-mode          "line numbers"     :toggle t)
      ("f" display-fill-column-indicator-mode "fill column"      :toggle t)
      ("w" whitespace-mode                    "whitespace"       :toggle t)
      ("v" visual-line-mode                   "visual line mode" :toggle t)
      ("r" toggle-truncate-lines              "truncate lines")
      ("p" spacious-padding-mode              "spacious padding"  :toggle t)))))

(use-package hydra-posframe
  :straight (hydra-posframe :type git :host github :repo "Ladicle/hydra-posframe")
  :config
  (setq hydra-posframe-poshandler 'posframe-poshandler-frame-bottom-right-corner
	hydra-posframe-parameters '((left-fringe . 5)
				    (right-fringe . 5)))
  :hook (after-init . hydra-posframe-mode))

(provide 'cxn/keys)
