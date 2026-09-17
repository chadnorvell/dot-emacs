;; -*- lexical-binding: elisp -*-
(use-package project
  :config
  (project-remember-projects-under "~/dev")
  (setq project-kill-buffers-display-buffer-list 't)

  (setq project-vc-extra-root-markers 
        '("go.mod" "package.json" "flake.nix" "cargo.toml" "mix.exs"))

  (setq project-switch-commands
        '((project-find-file "files" "f")
          (project-find-regexp "regexp" "s")
          (project-dired "dired" "d")
          (magit-project-status "git" "g"))))

(provide 'core-projects)
