;; -*- lexical-binding: elisp -*-
(setq fixed-family "Iosevka")
(set-face-font 'default (concat fixed-family "-13"))
(copy-face 'default 'fixed-pitch)

;; (setq variable-family "Linux Biolinum")
;; (set-face-font 'variable-pitch (concat variable-family  "-16"))

(use-package nerd-icons
  :straight t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font"))

(use-package doom-themes
  :straight t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-gruvbox t))

;; (use-package mixed-pitch
;;   :hook (org-mode . mixed-pitch-mode))

;; Ensures eldoc can render markdown.
(use-package markdown-ts-mode
  :straight t
  ;; The package is built in to 31+.
  :if (version<= "31.0" emacs-version))

;; Show eldoc content in a childframe.
(use-package eldoc-box
  :straight t)
(add-hook 'elgot-managed-mode-hook #'eldoc-box-hover-mode t)

(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode))

(use-package vertico
  :straight t
  :config
  (vertico-mode 1))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :straight t
  :config
  (marginalia-mode 1))

(use-package consult
  :straight t
  :after general
  :config
  (setq consult-preview-key 'any))

(use-package affe
  :straight t
  :after consult)

(use-package embark
  :straight t
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :straight t
  :after (embark consult)
  :demand t)

(use-package corfu
  :straight t
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator)
  :config
  (global-corfu-mode))

(use-package cape
  :straight t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(use-package nerd-icons-corfu
  :straight t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package avy
  :straight t
  :demand t)

(use-package puni
  :straight t
  :config
  (puni-global-mode 1))

(provide 'core-ux)
