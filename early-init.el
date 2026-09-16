;; -*- lexical-binding: elisp -*-
;; Defer garbage collection further back in the startup process.
(setq gc-cons-threshold most-positive-fixnum gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (defun reset-gc-cons-threshold ()
            (setq gc-cons-threshold (* 100 1024 1024) ; 100MB during init
                  read-process-output-max (* 1024 1024)))) ; 1MB for LSP performance

;; Native compilation settings.
(when (featurep 'native-compile)
  ;; Silence compiler warnings, as they can be pretty disruptive.
  (setq native-comp-async-report-warnings-errors nil)

  ;; Set the right directory to store the native compilation cache.
  (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory)))

;; Inhibit package initialize.
(setq package-enable-at-startup nil)

;; Inhibit resizing frame.
(setq frame-inhibit-implied-resize t)

;; Inhibit byte-compiler warnings.
(setq byte-compile-warnings nil)

;; Remove some unneeded UI elements.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(internal-border-width . 0) default-frame-alist)
(push '(undecorated-round . t) default-frame-alist)
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode    -1)
(window-divider-mode t)
(setq frame-inhibit-implied-resize t)
(setq window-divider-default-places t
      frame-resize-pixelwise t)
