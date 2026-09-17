;; -*- lexical-binding: elisp -*-
(use-package nix-mode
  :straight t)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(provide 'mode-nix)
