;; -*- lexical-binding: t -*-

(defun cxn/org-headers-ensure-blank-lines (&optional prefix)
  "Ensure that blank lines exist before headings.
With prefix, operate on whole buffer."
  (interactive "P")
  (org-map-entries (lambda ()
                     (org-with-wide-buffer
                      ;; `org-map-entries' narrows the buffer, which prevents us from seeing
                      ;; newlines before the current heading, so we do this part widened.
                      (while (not (looking-back "\n\n" nil))
                        ;; Insert blank lines before heading.
                        (insert "\n"))))
                   t (if prefix
                         nil
                       'tree)))

(defun cxn/org-before-save-hook ()
  (when (eq major-mode 'org-mode) (cxn/org-headers-ensure-blank-lines)))

(progn
  (defmacro +org-emphasize (fname char)
    "Make function for setting the emphasis in org-mode."
    `(defun ,fname () (interactive)
	    (org-emphasize ,char)))

  (+org-emphasize cxn/org-bold ?*)
  (+org-emphasize cxn/org-code ?~)
  (+org-emphasize cxn/org-italic ?/)
  (+org-emphasize cxn/org-clear ? )
  (+org-emphasize cxn/org-strike ?+)
  (+org-emphasize cxn/org-underline ?_)
  (+org-emphasize cxn/org-verbatim ?=))

(use-package org
  :straight t
  :config
  (setq org-agenda-files '("~/org")
	org-auto-align-tags nil
	org-fontify-done-headline t
	org-hide-emphasis-markers t
	org-insert-heading-respect-content t
	org-pretty-entities t
	org-tags-column 0)
  (setq org-capture-templates
	'(("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
	   "*  %?\n"))
	)

  ;; (set-face-attribute 'org-indent nil :inherit '(fixed-pitch))
  ;; (set-face-attribute 'org-default nil :inherit '(variable-pitch-text))

  (let* ((variable-tuple
	  (cond ((x-list-fonts "Iosevka Aile")    '(:font "Iosevka Aile"))
	        ((x-list-fonts "Noto Sans")       '(:font "Noto Sans"))
		((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
		(nil (warn "Cannot find a variable width face."))))
	 (base-font-color     (face-foreground 'default nil 'default))
	 (headline           `(:inherit default :weight bold :width semi-condensed)))

    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-6 ((t (,@headline ,@variable-tuple))))
     `(org-level-5 ((t (,@headline ,@variable-tuple))))
     `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
     `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.2))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.3))))
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.5))))
     `(org-document-title ((t (,@headline ,@variable-tuple :height 1.6 :underline nil))))))

  :hook
  (org-mode . visual-line-mode)
  (org-mode . org-margin-mode)
  (before-save . cxn/org-before-save-hook)

  :general
  (cxn/major-def (org-mode-map)
    "a"   '("attach" . org-attach)
    "g"   '("go to heading" . consult-org-heading)
    "p"   '("set property" . org-set-property)
    "x"   '("cut subtree" . org-cut-subtree)
    "f"   (cons "format" (make-sparse-keymap))
    "fb"    '("bold" . cxn/org-bold)
    "fc"    '("code" . cxn/org-code)
    "fi"    '("italic" . cxn/org-italic)
    "fs"    '("strike" . cxn/org-strike)
    "fu"    '("underline" . cxn/org-underline)
    "fv"    '("verbatim" . cxn/org-verbatim)
    "fx"    '("clear" . cxn/org-clear)))

(use-package org-modern
  :straight t
  :config
  (set-face-attribute 'org-modern-symbol nil :inherit '(shadow default))
  (setq org-modern-star 'nil)
  :hook ((org-mode . org-modern-mode)
	 (org-agenda-finalize . org-modern-agenda)))

(use-package org-margin
  :straight (org-margin :type git :host github :repo "rougier/org-margin")
  :config
  (setq org-margin-bookmark (propertize "•" 'face '(error bold))))

(use-package evil-org
  :straight t
  :after evil
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package mixed-pitch
  :straight t
  :hook (org-mode . mixed-pitch-mode)
  :config
  (setq mixed-pitch-face 'variable-pitch-text)
  (dolist (face '(org-modern-symbol
                  org-modern-label))
    (add-to-list 'mixed-pitch-fixed-pitch-faces face)))

(provide 'cxn/org)
