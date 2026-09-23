;; -*- lexical-binding: t -*-
;; Settings for code-related functionality.

(use-package treesit-auto
  :straight t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

;; Use eglot for code intelligence.
(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode) . ("clangd" "--header-insertion=never")))
  (add-to-list 'eglot-server-programs
               '((fish-mode) . ("fish-lsp" "start")))
  (add-to-list 'eglot-server-programs
               '((js-mode typescript-ts-mode) . ("rass" "typescript-language-server" "--stdio" "--" "vscode-eslint-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("rass" "gopls" "--" "golangci-lint-langserver")))
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nil")))
  :hook
  ((c-mode
   c-ts-mode
   c++-mode
   c++-ts-mode
   fish-mode
   js-mode
   typescript-ts-mode
   go-mode
   go-ts-mode
   nix-mode) . eglot-ensure))

(use-package consult-eglot
  :straight t
  :after (consult eglot))

(use-package consult-eglot-embark
  :straight t
  :after (consult-eglot embark)
  :config (consult-eglot-embark-mode 1))

;; Use apheleia for async formatting.
;; eglot also provides formatting via eglot-format-buffer, but that
;; relies on the language's LSP to do the formatting. That's fine for
;; some languages, but in other cases we might want or need to use an
;; external formatting program, which apheleia enables for us.
(use-package apheleia
  :straight t)

(use-package elisp-mode
  :config
  :general
  (cxn/major-def (emacs-lisp-mode-map lisp-interaction-mode-map)
    "r"  '("repl"          . ielm)
    "b"  '("eval buffer"   . eval-buffer)
    "r"  '("eval region"   . eval-region)
    "f"  '("eval defun"    . eval-defun)
    "s"  '("eval sexp"     . eval-last-sexp)
    "l"  '("load file"     . load-file)))

(use-package fish-mode
  :straight t)

(use-package nix-mode
  :straight t)

(use-package agent-shell
  :straight t
  :config
  (setq agent-shell-hermes-acp-command '("eng" "acp"))
  ;; Auto-approve ACP permission requests rather than prompting for every
  ;; tool call, matching the behaviour of the Hermes CLI/TUI.
  ;;
  ;; This only waives *agent-shell's* dialog.  Hermes keeps its own guards:
  ;; its hardline blocklist still refuses things like `rm -rf /' outright,
  ;; and `approvals.mode' in ~/.hermes/config.yaml still governs its
  ;; dangerous-command prompts independently of this setting.
  (setq agent-shell-permission-responder-function
        #'agent-shell-permission-allow-always))

(provide 'cxn/code)
