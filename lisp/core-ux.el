;; -*- lexical-binding: elisp -*-
(setq fixed-family "Iosevka")
(set-face-font 'default (concat fixed-family "-13"))
(copy-face 'default 'fixed-pitch)

;; (setq variable-family "Linux Biolinum")
;; (set-face-font 'variable-pitch (concat variable-family  "-16"))

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font"))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-gruvbox t))

;; (use-package mixed-pitch
;;   :hook (org-mode . mixed-pitch-mode))

;; Ensures eldoc can render markdown.
(use-package markdown-ts-mode)

;; Show eldoc content in a childframe.
(use-package eldoc-box)
 (add-hook 'elgot-managed-mode-hook #'eldoc-box-hover-mode t)

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package vertico
  :ensure nil
  :config
  (vertico-mode 1))

(use-package orderless
  :ensure nil
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure nil
  :config
  (marginalia-mode 1))

(use-package consult
  :ensure nil
  :after general
  :config
  (setq consult-preview-key 'any))

(use-package affe
  :ensure nil
  :after consult)

(use-package embark
  :ensure nil
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure nil
  :after (embark consult)
  :demand t)

(use-package corfu
  :ensure nil
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator)
  :config
  (global-corfu-mode))

(use-package cape
  :ensure nil
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(use-package nerd-icons-corfu
  :ensure nil
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package avy
  :demand t
  :ensure nil)

(use-package puni
  :ensure nil
  :config
  (puni-global-mode 1))

(provide 'core-ux)
