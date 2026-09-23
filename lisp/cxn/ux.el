;; -*- lexical-binding: t -*-

(set-face-attribute 'default nil
		    :family "Iosevka"
		    :height 135
		    :weight 'medium)

(copy-face 'default 'fixed-pitch)

(set-face-attribute 'fixed-pitch-serif nil
		    :family "Iosevka Slab"
		    :height 135
		    :weight 'medium)

(set-face-attribute 'variable-pitch nil
		    :family "Iosevka Aile"
		    :height 135
		    ;;:width 'semi-condensed
		    :weight 'regular)

(set-face-attribute 'variable-pitch-text nil
		    :family "Iosevka Etoile"
		    :height 135
		    ;;:width 'semi-condensed
		    :weight 'regular)

(use-package nerd-icons
  :straight t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font"))

(use-package doom-themes
  :straight t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  ;; Local themes (doom-nordic lives in ~/.config/emacs/themes/).
  ;; doom-nordic is a port of AlexvZyl/nordic.nvim, matching the Neovim setup.
  (add-to-list 'custom-theme-load-path
               (expand-file-name "themes/" user-emacs-directory))
  (load-theme 'doom-nordic t))

;; (use-package mixed-pitch
;;   :hook (org-mode . mixed-pitch-mode))

;; Show eldoc content in a childframe.
(use-package eldoc-box
  :straight t)
(add-hook 'elgot-managed-mode-hook #'eldoc-box-hover-mode t)

(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode))

(use-package nerd-icons-corfu
  :straight t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(provide 'cxn/ux)
