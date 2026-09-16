;; -*- lexical-binding: elisp -*-
;; Settings for code-related functionality.

(use-package treesit-auto
  :ensure nil
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
               '((js-mode typescript-ts-mode) . ("rass" "typescript-language-server" "--stdio" "--" "vscode-eslint-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("rass" "gopls" "--" "golangci-lint-langserver")))
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nil"))))

:general
(general-define-key
 "s-?" 'eldoc
 "s-/" 'eldoc-box-help-at-point
 "s-:" 'eglot-format-buffer
 "s-c" 'completion-at-point
 "s-f" 'xref-find-definitions
 "s-i" 'eglot-find-declaration
 "s-m" 'eglot-find-implementations
 "s-n" 'eglot-rename
 "s-r" 'xref-find-references
 "s-y" 'eglot-find-typeDefinition)

(cxn/leader-def
  "c"  (cons "code" (make-sparse-keymap))
  "c:" '("format buffer"   . eglot-format-buffer)
  "cc" '("completion"      . completion-at-point)
  "cE" '("start eglot"     . eglot)
  "cf" '("definition"      . xref-find-definitions)
  "ci" '("declaration"     . eglot-find-declaration)
  "ch" '("docs"            . eldoc-box-help-at-point)
  "cH" '("docs buffer"     . eldoc)
  "cm" '("implementations" . eglot-find-implementations)
  "cn" '("rename"          . eglot-rename)
  "cr" '("references"      . xref-find-references)
  "ct" '("type definition" . eglot-find-typeDefinition))

(use-package eglot-booster
  :ensure nil
  :after eglot
  :config (eglot-booster-mode 1))

(use-package consult-eglot
  :ensure nil
  :after (consult eglot))

(use-package consult-eglot-embark
  :ensure nil
  :after (consult-eglot embark)
  :config (consult-eglot-embark-mode 1))

;; Use apheleia for async formatting.
;; eglot also provides formatting via eglot-format-buffer, but that
;; relies on the language's LSP to do the formatting. That's fine for
;; some languages, but in other cases we might want or need to use an
;; external formatting program, which apheleia enables for us.
(use-package apheleia
  :general
  (general-define-key
   "s-;" 'apheleia-format-buffer)

  (cxn/leader-def
    "c;" '("format buffer with apheleia" . apheleia-format-buffer)
    "cA" 'apheleia-mode))

(provide 'core-code)
