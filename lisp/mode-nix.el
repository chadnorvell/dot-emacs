;; -*- lexical-binding: elisp -*-
(use-package nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(provide 'mode-nix)
