;;; doom-nordic-theme.el --- port of nordic.nvim -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: ported for Chad
;; Source: https://github.com/AlexvZyl/nordic.nvim
;;         Palette: https://www.nordtheme.com/ plus nordic's own additions
;;
;;; Commentary:
;;
;; A port of AlexvZyl/nordic.nvim -- the colorscheme Chad actually uses in
;; Neovim -- to Emacs, built on doom-themes for broad package coverage.
;;
;; Every color and mapping here was captured from a LIVE nvim session running
;; `nordic.load()' with default options (matching Chad's config, which passes
;; no options), by dumping `nvim_get_hl' for each group.  Nothing is guessed
;; from reading the Lua source.
;;
;; Nordic is *not* plain Nord.  Relative to Nord / doom-nord it:
;;   - uses gray0 #242933 as bg (Nord's website dark), not Nord0 #2E3440
;;   - adds blacks (#191D24/#1E222A/#222630) below the Nord ramp
;;   - defaults `reduced_blue', so fg is #C0C8D8 not #D8DEE9
;;   - adds bright/dim variants of every Aurora color
;;
;; Semantic mappings that differ from doom-nord (which maps keywords/operators
;; /constants all to blue):
;;
;;   category     doom-nord        nordic.nvim
;;   ----------   --------------   --------------------------------------
;;   keywords     blue #81A1C1     orange #D08770   <- the signature trait
;;   operators    blue             fg #C0C8D8       (deliberately uncolored)
;;   constants    blue             magenta.bright #BE9DB8
;;   numbers      magenta          magenta.bright #BE9DB8
;;   type         teal #8FBCBB     yellow #EBCB8B
;;   functions    cyan #88C0D0     blue2 #88C0D0    (same)
;;   builtin      blue             blue0 #5E81AC    (self/this)
;;   variables    base7            fg #C0C8D8
;;   macro/preproc -                red #BF616A
;;   fields/props  -                cyan #8FBCBB
;;   delimiters    -                gray5 #60728A, ITALIC
;;   comments      lightened base5  gray4 #4C566A, ITALIC
;;
;; Two places where a faithful port would be actively worse in Emacs, both
;; handled explicitly (see the defcustoms below):
;;
;; 1. nordic sets CursorLine and Visual to the SAME color (#1B1F26).  Vim is
;;    modal so they never really coexist; in Emacs `hl-line' and `region'
;;    overlap constantly and would be indistinguishable.  `region' therefore
;;    uses nordic's own `bg_selected' (#3B4252, its PmenuSel color).
;;
;; 2. nordic's raw StatusLine fg is gray2 on black0 -- 1.68:1 -- because
;;    lualine paints over it and is what you actually see.  The modeline here
;;    follows nordic's *lualine* theme instead.
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-nordic-theme nil
  "Options for the `doom-nordic' theme."
  :group 'doom-themes)

(defcustom doom-nordic-brighter-comments nil
  "If non-nil, lift comments above nordic's literal gray4.

nordic uses gray4 #4C566A for comments, which is only 1.98:1 against the
#242933 background -- faithful, but genuinely hard to read on many
displays.  Non-nil substitutes a lifted grey at ~4.2:1."
  :group 'doom-nordic-theme
  :type 'boolean)

(defcustom doom-nordic-brighter-line-numbers t
  "If non-nil, lift line numbers above nordic's literal gray2.

nordic's LineNr is gray2 #3B4252 (1.45:1 on the background), which is
nearly invisible in Emacs where line numbers are shown far more often
than in a default nvim setup.  Non-nil uses gray4/gray5 instead."
  :group 'doom-nordic-theme
  :type 'boolean)

(defcustom doom-nordic-italic-comments t
  "If non-nil, italicize comments, as nordic does by default
\(`italic_comments = true').  Requires `doom-themes-enable-italic'."
  :group 'doom-nordic-theme
  :type 'boolean)

(defcustom doom-nordic-italic-delimiters t
  "If non-nil, italicize delimiters/punctuation, as nordic does.
nordic's `Delimiter' is `{ italic = true, fg = gray5 }'."
  :group 'doom-nordic-theme
  :type 'boolean)

(defcustom doom-nordic-bold-keywords nil
  "If non-nil, embolden keywords (nordic's `bold_keywords', default off)."
  :group 'doom-nordic-theme
  :type 'boolean)

(defcustom doom-nordic-raise-treesit-level t
  "If non-nil, raise `treesit-font-lock-level' to 4 while this theme is active.

Emacs's tree-sitter modes only fontify the `operator', `bracket',
`delimiter' and `property' features at level 4.  Nordic distinguishes
properties/fields (cyan) and delimiters (italic gray5) from ordinary
text, so level 3 loses real information.

Applied via `custom-theme-set-variables', so `disable-theme' reverts it."
  :group 'doom-nordic-theme
  :type 'boolean)

(defcustom doom-nordic-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-nordic-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-nordic
  "A dark theme ported from nordic.nvim."

  ;; name        default   256       16
  ;; Base ramp is nordic's grey scale, which is already monotonic in
  ;; luminance: black0 < black1 < black2 < gray0(bg) < gray1 .. gray5 < whites.
  ((bg         '("#242933" nil       nil            )) ; gray0
   (bg-alt     '("#1E222A" nil       nil            )) ; black1 (bg_float/popup)
   (base0      '("#191D24" "black"   "black"        )) ; black0
   (base1      '("#1E222A" "#1e1e1e" "brightblack"  )) ; black1
   (base2      '("#222630" "#2e2e2e" "brightblack"  )) ; black2
   (base3      '("#2E3440" "#262626" "brightblack"  )) ; gray1  (Nord0)
   (base4      '("#3B4252" "#3f3f3f" "brightblack"  )) ; gray2  (Nord1)
   (base5      '("#434C5E" "#525252" "brightblack"  )) ; gray3  (Nord2)
   (base6      '("#4C566A" "#6b6b6b" "brightblack"  )) ; gray4  (Nord3)
   (base7      '("#60728A" "#979797" "white"        )) ; gray5
   (base8      '("#ECEFF4" "#ffffff" "brightwhite"  )) ; white3 (Nord6)
   (fg         '("#C0C8D8" "#c6c6c6" "white"        )) ; white0_reduce_blue
   (fg-alt     '("#D8DEE9" "#dfdfdf" "brightwhite"  )) ; white1 (Nord4)

   (grey       base6)
   ;; Aurora + Frost.  `-br'/`-dm' suffixed extras are nordic additions.
   (red        '("#BF616A" "#ff6655" "red"          )) ; Nord11
   (orange     '("#D08770" "#dd8844" "brightred"    )) ; Nord12
   (green      '("#A3BE8C" "#99bb66" "green"        )) ; Nord14
   (teal       '("#8FBCBB" "#44b9b1" "brightgreen"  )) ; Nord7  cyan.base
   (yellow     '("#EBCB8B" "#ECBE7B" "yellow"       )) ; Nord13
   (blue       '("#81A1C1" "#51afef" "brightblue"   )) ; Nord9
   (dark-blue  '("#5E81AC" "#2257A0" "blue"         )) ; Nord10 (Builtin)
   (magenta    '("#B48EAD" "#c678dd" "magenta"      )) ; Nord15
   (violet     '("#BE9DB8" "#d7afd7" "brightmagenta")) ; magenta.bright
   (cyan       '("#88C0D0" "#46D9FF" "brightcyan"   )) ; Nord8  blue2
   (dark-cyan  '("#80B3B2" "#5699AF" "cyan"         )) ; cyan.dim

   ;; nordic's bright/dim variants
   (red-br     '("#C5727A" "#ff6655" "brightred"    ))
   (orange-br  '("#D79784" "#dd8844" "brightred"    ))
   (yellow-br  '("#EFD49F" "#ECBE7B" "brightyellow" ))
   (yellow-dm  '("#E7C173" "#ECBE7B" "yellow"       ))
   (green-br   '("#B1C89D" "#99bb66" "brightgreen"  ))
   (cyan-br    '("#9FC6C5" "#5699AF" "brightcyan"   ))

   ;; face categories -- required for all themes
   (highlight      yellow)          ; IncSearch/CurSearch bg
   (vertical-bar   base0)           ; VertSplit fg = black0
   ;; NOTE: nordic gives CursorLine and Visual the same #1B1F26.  In Emacs
   ;; region and hl-line coexist, so region takes nordic's `bg_selected'
   ;; (#3B4252 = gray2, its PmenuSel colour) and hl-line keeps #1B1F26.
   (selection      base4)
   (builtin        dark-blue)       ; Builtin = blue0 (self/this)
   (comments       (if doom-nordic-brighter-comments
                       '("#7C8A9E" "#6b6b6b" "brightblack")
                     base6))        ; gray4
   (doc-comments   (if doom-nordic-brighter-comments
                       '("#7C8A9E" "#6b6b6b" "brightblack")
                     base6))
   (constants      violet)          ; Constant = magenta.bright
   (functions      cyan)            ; Function = blue2
   (keywords       orange)          ; <- nordic's signature: orange keywords
   (methods        cyan)
   (operators      fg)              ; Operator = fg (deliberately uncoloured)
   (type           yellow)          ; Type = yellow
   (strings        green)
   (variables      fg)              ; Identifier/Variable = fg
   (numbers        violet)          ; Number links to Constant
   (region         base4)
   (error          red-br)          ; C.error = red.bright
   (warning        yellow)          ; C.warn
   (success        green)
   (vc-modified    blue)            ; git.change = blue1
   (vc-added       green)           ; git.add
   (vc-deleted     red)             ; git.delete

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-italic-c  (and doom-nordic-italic-comments doom-themes-enable-italic))
   (-italic-d  (and doom-nordic-italic-delimiters doom-themes-enable-italic))
   (-padding
    (when doom-nordic-padded-modeline
      (if (integerp doom-nordic-padded-modeline) doom-nordic-padded-modeline 4)))

   ;; nordic's bg_cursorline/bg_visual = blend(black0, bg, 0.85) -- DARKER
   ;; than the background, which is unusual and a nice nordic signature.
   (current-line '("#1B1F26" "#1e1e1e" "brightblack"))

   ;; Line numbers.  nordic's literal LineNr is gray2 (1.45:1) and
   ;; CursorLineNr is gray5 bold (2.97:1).  Lifted by default because Emacs
   ;; shows line numbers far more prominently than a stock nvim.
   (linenr      (if doom-nordic-brighter-line-numbers base7 base4))
   (linenr-cur  (if doom-nordic-brighter-line-numbers fg base7))

   ;; Diff/VCS.  Backgrounds are nordic's own `C.diff' blends (accent into bg
   ;; at alpha 0.2), captured live.  Foregrounds are solved to >= 4.5:1
   ;; against those tints while keeping the Nord hue -- nordic itself relies
   ;; on the plain fg there, which loses the add/delete distinction in Magit.
   (diff-add-bg     '("#3D4745" "#005f00" "green"  ))
   (diff-add-fg     '("#A3BE8C" "#afd7af" "green"  ))
   (diff-add-fg-hl  '("#B5CBA2" "#d7ffd7" "brightgreen"))
   (diff-del-bg     '("#43343E" "#5f0000" "red"    ))
   (diff-del-fg     '("#D28F95" "#ff8787" "red"    ))
   (diff-del-fg-hl  '("#DAA5AA" "#ffafaf" "brightred"))
   (diff-chg-bg     '("#384752" "#005f5f" "blue"   )) ; C.diff.change1
   (diff-chg-fg     '("#88C0D0" "#afd7ff" "brightcyan"))
   (diff-chg-fg-hl  '("#9FCEDB" "#d7ffff" "brightcyan"))
   (diff-base-bg    '("#292F3A" "#303030" "brightblack")) ; C.diff.change0
   (diff-base-fg    '("#81A1C1" "#afafd7" "brightblue"))

   ;; modeline.  nordic's raw StatusLine is gray2-on-black0 (1.68:1) because
   ;; lualine covers it; we follow nordic's *lualine* theme instead, which
   ;; uses bg_statusline (black0) with white0 text.  Active and inactive share
   ;; the background and differ by foreground -- nordic's own pattern.
   (modeline-fg     fg)
   (modeline-fg-alt base7)          ; gray5
   (modeline-bg     base0)          ; black0 = C.bg_statusline
   (modeline-bg-l   base0)
   (modeline-bg-inactive   base0)
   (modeline-bg-inactive-l base0))


  ;;;; Base theme face overrides
  (
   ;;;; core editor
   (cursor :background fg-alt)
   (hl-line :background current-line :extend t)
   (region :background base4 :distant-foreground 'unspecified :extend t)
   (fringe :inherit 'default :foreground base4)
   (vertical-border :foreground base0 :background base0)
   (shadow :foreground base5)
   (tooltip :background base1 :foreground fg)
   (secondary-selection :background base4 :extend t)
   (trailing-whitespace :background red)
   (link :foreground blue :underline t :weight 'bold)  ; Link = blue1 underline
   (highlight :background base4 :foreground fg :distant-foreground base8)
   (match :foreground yellow-br :background current-line :weight 'bold)

   ;;;; line numbers -- nordic: LineNr gray2, CursorLineNr gray5 bold
   ((line-number &override) :foreground linenr)
   ((line-number-current-line &override) :foreground linenr-cur :weight 'bold)

   ;;;; search -- nordic: Search is yellow.bright on cursorline bg, bold+underline;
   ;;;; IncSearch/CurSearch invert to yellow background.
   (isearch :foreground current-line :background yellow :weight 'bold)
   (isearch-fail :foreground base8 :background red :weight 'bold)
   (lazy-highlight
    :foreground yellow-br :background current-line :weight 'bold :underline t)
   (evil-ex-search :foreground current-line :background yellow :weight 'bold)
   (evil-ex-lazy-highlight :inherit 'lazy-highlight)
   ((show-paren-match &override)
    :foreground 'unspecified :background 'unspecified
    :underline t :weight 'bold)     ; MatchParen = bold underline, sp=white1
   ((show-paren-mismatch &override) :foreground base8 :background red :weight 'bold)

   ;;;; font-lock -- nordic's semantic mappings
   ((font-lock-comment-face &override)
    :slant (if -italic-c 'italic 'unspecified))
   ((font-lock-doc-face &override)
    :slant (if -italic-c 'italic 'unspecified))
   (font-lock-keyword-face :foreground orange
                           :weight (if doom-nordic-bold-keywords 'bold 'unspecified))
   ;; Operator is deliberately plain fg in nordic -- do not colour it.
   (font-lock-operator-face :foreground fg)
   (font-lock-negation-char-face :foreground fg :weight 'bold)
   ;; @punctuation.bracket links to @operator (fg); Delimiter is italic gray5.
   (font-lock-bracket-face :foreground fg)
   (font-lock-punctuation-face :foreground base7
                               :slant (if -italic-d 'italic 'unspecified))
   (font-lock-delimiter-face   :foreground base7
                               :slant (if -italic-d 'italic 'unspecified))
   (font-lock-misc-punctuation-face :foreground base7
                                    :slant (if -italic-d 'italic 'unspecified))
   (font-lock-constant-face :foreground violet)
   (font-lock-number-face   :foreground violet)
   (font-lock-type-face     :foreground yellow)
   (font-lock-builtin-face  :foreground dark-blue)
   (font-lock-function-name-face :foreground cyan)
   (font-lock-function-call-face :foreground cyan :slant 'unspecified)
   (font-lock-variable-name-face :foreground fg)
   (font-lock-variable-use-face  :foreground fg)
   ;; Field/@property/@variable.member = cyan.base (teal)
   (font-lock-property-name-face :foreground teal :weight 'unspecified)
   (font-lock-property-use-face  :foreground teal :weight 'unspecified)
   ;; Macro/PreProc/Include/Define/Exception = red
   (font-lock-preprocessor-face      :foreground red :weight 'unspecified)
   (font-lock-preprocessor-char-face :foreground red :weight 'unspecified)
   (font-lock-escape-face :foreground violet)   ; @string.escape = magenta.bright
   (font-lock-regexp-face :foreground violet)
   (font-lock-regexp-grouping-backslash :foreground violet :weight 'bold)
   (font-lock-regexp-grouping-construct :foreground violet :weight 'bold)
   (font-lock-warning-face :foreground yellow :weight 'bold)
   ;; Todo = black0 on yellow.dim -- a real highlighted badge in nordic.
   (hl-todo :foreground base0 :background yellow-dm :weight 'bold)

   ;;;; mode-line / header-line
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :distant-foreground modeline-bg
    :box (if -padding `(:line-width ,-padding :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -padding `(:line-width ,-padding :color ,modeline-bg-inactive)))
   (mode-line-emphasis  :foreground yellow :weight 'bold)
   (mode-line-highlight :background base4 :foreground fg-alt)
   (mode-line-buffer-id :foreground fg-alt :weight 'bold)
   (header-line :background base1 :foreground fg
                :box (if -padding `(:line-width ,-padding :color ,base1)))

   ;;;; doom-modeline -- colours follow nordic's lualine theme, where each
   ;;;; mode gets a `bright' Aurora accent.  All >= 4.8:1 on black0.
   (doom-modeline-bar :background orange-br)
   (doom-modeline-bar-inactive :background modeline-bg-inactive)
   (doom-modeline-buffer-file :foreground fg-alt :weight 'bold)
   (doom-modeline-buffer-path :foreground blue :weight 'bold)
   (doom-modeline-buffer-modified :foreground orange-br :weight 'bold)
   (doom-modeline-buffer-major-mode :foreground violet :weight 'bold)
   (doom-modeline-buffer-minor-mode :foreground base7)
   (doom-modeline-project-dir  :foreground green :weight 'bold)
   (doom-modeline-project-root-dir :foreground base7)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)
   (doom-modeline-info    :foreground green :weight 'bold)
   (doom-modeline-warning :foreground yellow :weight 'bold)
   (doom-modeline-urgent  :foreground red-br :weight 'bold)
   (doom-modeline-debug   :foreground base7)
   (doom-modeline-lsp-success :foreground green)
   (doom-modeline-lsp-warning :foreground yellow)
   (doom-modeline-lsp-error   :foreground red-br)
   (doom-modeline-panel :background base4 :foreground fg-alt)
   ;; lualine: normal=orange.bright insert=green.bright visual=red.bright
   ;;          replace=magenta.bright command=cyan.bright terminal=blue2
   (doom-modeline-evil-normal-state   :foreground orange-br :weight 'bold)
   (doom-modeline-evil-insert-state   :foreground green-br  :weight 'bold)
   (doom-modeline-evil-visual-state   :foreground red-br    :weight 'bold)
   (doom-modeline-evil-replace-state  :foreground violet    :weight 'bold)
   (doom-modeline-evil-operator-state :foreground cyan-br   :weight 'bold)
   (doom-modeline-evil-motion-state   :foreground base7     :weight 'bold)
   (doom-modeline-evil-emacs-state    :foreground cyan      :weight 'bold)

   ;;;; diff <built-in> / ediff
   (diff-added        :foreground diff-add-fg :background diff-add-bg :extend t)
   (diff-removed      :foreground diff-del-fg :background diff-del-bg :extend t)
   (diff-changed      :foreground diff-chg-fg :background diff-chg-bg :extend t)
   (diff-indicator-added   :foreground diff-add-fg-hl :background diff-add-bg :weight 'bold)
   (diff-indicator-removed :foreground diff-del-fg-hl :background diff-del-bg :weight 'bold)
   (diff-indicator-changed :foreground diff-chg-fg-hl :background diff-chg-bg :weight 'bold)
   (diff-refine-added   :foreground diff-add-fg-hl :background diff-add-bg :weight 'bold)
   (diff-refine-removed :foreground diff-del-fg-hl :background diff-del-bg :weight 'bold)
   (diff-refine-changed :foreground diff-chg-fg-hl :background diff-chg-bg :weight 'bold)
   (diff-header      :foreground cyan :weight 'bold)
   (diff-file-header :foreground fg :weight 'bold)     ; diffFile = fg
   (diff-hunk-header :foreground blue :background diff-base-bg :extend t)
   (diff-function    :foreground blue :background diff-base-bg :extend t)
   (diff-context     :foreground base6)
   (diff-nonexistent :foreground base5)

   (ediff-current-diff-A :foreground diff-del-fg :background diff-del-bg :extend t)
   (ediff-current-diff-B :foreground diff-add-fg :background diff-add-bg :extend t)
   (ediff-current-diff-C :foreground diff-chg-fg :background diff-chg-bg :extend t)
   (ediff-current-diff-Ancestor :foreground teal :background diff-base-bg :extend t)
   (ediff-fine-diff-A :foreground diff-del-fg-hl :background diff-del-bg :weight 'bold :extend t)
   (ediff-fine-diff-B :foreground diff-add-fg-hl :background diff-add-bg :weight 'bold :extend t)
   (ediff-fine-diff-C :foreground diff-chg-fg-hl :background diff-chg-bg :weight 'bold :extend t)
   (ediff-even-diff-A :background base2 :extend t)
   (ediff-even-diff-B :background base2 :extend t)
   (ediff-odd-diff-A  :background base1 :extend t)
   (ediff-odd-diff-B  :background base1 :extend t)

   ;;;; magit -- full coverage using nordic's diff tints
   (magit-diff-added             :foreground diff-add-fg :background diff-add-bg :extend t)
   (magit-diff-added-highlight   :foreground diff-add-fg-hl :background diff-add-bg :weight 'bold :extend t)
   (magit-diff-removed           :foreground diff-del-fg :background diff-del-bg :extend t)
   (magit-diff-removed-highlight :foreground diff-del-fg-hl :background diff-del-bg :weight 'bold :extend t)
   (magit-diff-base              :foreground diff-base-fg :background diff-base-bg :extend t)
   (magit-diff-base-highlight    :foreground diff-chg-fg-hl :background diff-chg-bg :weight 'bold :extend t)
   (magit-diff-context           :foreground base6 :background bg :extend t)
   (magit-diff-context-highlight :foreground fg :background base2 :extend t)
   (magit-diff-file-heading      :foreground fg :weight 'bold :extend t)
   (magit-diff-file-heading-highlight :foreground fg-alt :background base4 :weight 'bold :extend t)
   (magit-diff-file-heading-selection :foreground yellow :background base4 :weight 'bold :extend t)
   (magit-diff-hunk-heading           :foreground blue :background diff-base-bg :extend t)
   (magit-diff-hunk-heading-highlight :foreground base0 :background blue :weight 'bold :extend t)
   (magit-diff-hunk-heading-selection :foreground base0 :background cyan :weight 'bold :extend t)
   (magit-diff-hunk-region :weight 'bold)
   (magit-diff-lines-heading   :foreground base0 :background blue :weight 'bold :extend t)
   (magit-diff-lines-boundary  :background blue)
   (magit-diff-conflict-heading :foreground red-br :weight 'bold :extend t)
   (magit-diff-revision-summary :foreground fg :weight 'bold)
   (magit-diff-revision-summary-highlight :foreground fg-alt :background base4 :weight 'bold)
   (magit-diffstat-added   :foreground green)
   (magit-diffstat-removed :foreground red)

   (magit-section-heading           :foreground cyan :weight 'bold :extend t)
   (magit-section-heading-selection :foreground yellow :weight 'bold :extend t)
   (magit-section-highlight         :background base2 :extend t)
   (magit-section-secondary-heading :foreground magenta :weight 'bold :extend t)
   (magit-section-child-count :foreground base7)
   (magit-header-line :background base4 :foreground fg-alt :weight 'bold
                      :box `(:line-width 3 :color ,base4))
   (magit-header-line-log-select :background base4 :foreground fg-alt :weight 'bold)

   (magit-branch-current :foreground cyan :weight 'bold :box '(:line-width -1))
   (magit-branch-local   :foreground blue :weight 'bold)
   (magit-branch-remote  :foreground green :weight 'bold)
   (magit-branch-remote-head :foreground green :weight 'bold :box '(:line-width -1))
   (magit-branch-upstream :slant 'italic)
   (magit-head :inherit 'magit-branch-local)
   (magit-tag  :foreground yellow)
   (magit-hash :foreground base6)
   (magit-refname :foreground base6)
   (magit-refname-stash :foreground base6)
   (magit-refname-wip   :foreground base6)
   (magit-filename   :foreground fg)
   (magit-log-author :foreground orange)
   (magit-log-date   :foreground blue)
   (magit-log-graph  :foreground base6)
   (magit-dimmed     :foreground base6)
   (magit-keyword    :foreground orange)
   (magit-keyword-squash :foreground yellow :weight 'bold)

   (magit-blame-hash    :foreground cyan)
   (magit-blame-name    :foreground orange)
   (magit-blame-date    :foreground blue)
   (magit-blame-summary :foreground fg)
   (magit-blame-heading :foreground orange :background base4 :extend t)
   (magit-blame-highlight :foreground fg-alt :background base4 :extend t)

   (magit-bisect-bad  :foreground red)
   (magit-bisect-good :foreground green)
   (magit-bisect-skip :foreground yellow)
   (magit-cherry-equivalent :foreground magenta)
   (magit-cherry-unmatched  :foreground cyan)
   (magit-process-ng :foreground red-br :weight 'bold)
   (magit-process-ok :foreground green :weight 'bold)
   (magit-reflog-amend       :foreground magenta)
   (magit-reflog-checkout    :foreground blue)
   (magit-reflog-cherry-pick :foreground green)
   (magit-reflog-commit      :foreground green)
   (magit-reflog-merge       :foreground green)
   (magit-reflog-other       :foreground cyan)
   (magit-reflog-rebase      :foreground magenta)
   (magit-reflog-remote      :foreground cyan)
   (magit-reflog-reset       :foreground red-br :weight 'bold)
   (magit-sequence-drop :foreground red)
   (magit-sequence-head :foreground blue)
   (magit-sequence-part :foreground yellow)
   (magit-sequence-stop :foreground green)
   (magit-sequence-done :foreground base6)
   (magit-sequence-onto :foreground base6)
   (magit-sequence-pick :foreground fg)
   (magit-sequence-exec :foreground cyan)
   (magit-signature-bad       :foreground red-br :weight 'bold)
   (magit-signature-error     :foreground red-br)
   (magit-signature-expired   :foreground orange)
   (magit-signature-expired-key :foreground orange)
   (magit-signature-good      :foreground green)
   (magit-signature-revoked   :foreground magenta)
   (magit-signature-untrusted :foreground yellow)

   ;;;; transient
   (transient-heading  :foreground cyan   :weight 'bold)
   (transient-key      :foreground yellow :weight 'bold)
   (transient-key-exit :foreground red)
   (transient-key-noop :foreground base5)
   (transient-key-return :foreground yellow-dm)
   (transient-key-stay :foreground green)
   (transient-argument :foreground orange :weight 'bold)
   (transient-value    :foreground violet :weight 'bold)
   (transient-inactive-argument :foreground base5)
   (transient-inactive-value    :foreground base5)
   (transient-enabled-suffix  :foreground green  :weight 'bold)
   (transient-disabled-suffix :foreground red    :weight 'bold)
   (transient-unreachable     :foreground base5)
   (transient-unreachable-key :foreground base5)
   (transient-mismatched-key  :foreground yellow)
   (transient-nonstandard-key :foreground yellow)

   ;;;; git-gutter / diff-hl -- nordic GitSigns colours
   (git-gutter:added     :inherit 'fringe :foreground green)
   (git-gutter:deleted   :inherit 'fringe :foreground red)
   (git-gutter:modified  :inherit 'fringe :foreground blue)
   (git-gutter:unchanged :inherit 'fringe)
   (diff-hl-insert :foreground green :background green)
   (diff-hl-delete :foreground red   :background red)
   (diff-hl-change :foreground blue  :background blue)

   ;;;; smerge <built-in>
   (smerge-lower   :background diff-add-bg :extend t)
   (smerge-upper   :background diff-del-bg :extend t)
   (smerge-base    :background diff-base-bg :extend t)
   (smerge-markers :background base4 :foreground fg-alt :weight 'bold :extend t)
   (smerge-refined-added   :background diff-add-bg :foreground diff-add-fg-hl)
   (smerge-refined-removed :background diff-del-bg :foreground diff-del-fg-hl)

   ;;;; vc <built-in>
   (vc-up-to-date-state :foreground green)
   (vc-edited-state     :foreground blue)
   (vc-missing-state    :foreground red)
   (vc-conflict-state   :foreground red-br :weight 'bold)
   (vc-locally-added-state :foreground cyan)
   (vc-removed-state    :foreground red)
   (vc-needs-update-state :foreground magenta)

   ;;;; completion: corfu / vertico / consult / marginalia / orderless
   ;; nordic: Pmenu bg = bg_float (black1); PmenuSel bg = bg_selected (gray2)
   (corfu-default :background base1 :foreground fg)
   (corfu-current :background base4 :foreground fg-alt :weight 'bold)
   (corfu-bar     :background base6)
   (corfu-border  :background base0)
   (corfu-annotations :foreground base7)
   (corfu-deprecated  :foreground base5 :strike-through t)
   (vertico-current :background base4 :extend t)
   (vertico-group-title :foreground cyan :weight 'bold)
   (vertico-group-separator :foreground base5 :strike-through t)
   (orderless-match-face-0 :foreground yellow :weight 'bold)
   (orderless-match-face-1 :foreground magenta :weight 'bold)
   (orderless-match-face-2 :foreground cyan :weight 'bold)
   (orderless-match-face-3 :foreground green :weight 'bold)
   (marginalia-documentation :foreground base7 :slant 'italic)
   (marginalia-key       :foreground yellow)
   (marginalia-file-name :foreground base7)
   (marginalia-value     :foreground fg)
   (marginalia-number    :foreground violet)
   (marginalia-string    :foreground green)
   (marginalia-modified  :foreground blue)
   (marginalia-size      :foreground violet)
   (marginalia-type      :foreground yellow)
   (marginalia-function  :foreground cyan)
   (marginalia-date      :foreground blue)
   (consult-file        :foreground fg)
   (consult-line-number :foreground base7)
   (consult-line-number-prefix :foreground base7)
   (consult-preview-line :background current-line :extend t)
   (consult-async-split :foreground yellow)
   (consult-bookmark    :foreground magenta)
   (consult-separator   :foreground base5)

   ;;;; embark / avy / which-key / wgrep
   (embark-keybinding :foreground yellow :weight 'bold)
   (embark-verbose-indicator-title :foreground cyan :weight 'bold)
   (avy-lead-face   :background red      :foreground base0 :weight 'bold)
   (avy-lead-face-0 :background yellow   :foreground base0 :weight 'bold)
   (avy-lead-face-1 :background cyan     :foreground base0 :weight 'bold)
   (avy-lead-face-2 :background magenta  :foreground base0 :weight 'bold)
   (avy-background-face :foreground base5)
   (which-key-key-face                   :foreground yellow :weight 'bold)
   (which-key-group-description-face     :foreground magenta)
   (which-key-command-description-face   :foreground cyan)
   (which-key-local-map-description-face :foreground green)
   (which-key-separator-face :foreground base5)
   (wgrep-face :background base4 :weight 'bold)
   (wgrep-file-face :foreground base7)
   (wgrep-done-face :foreground green)
   (wgrep-delete-face :foreground red :background diff-del-bg)
   (wgrep-reject-face :foreground red-br :weight 'bold)

   ;;;; eglot / flymake / eldoc-box / xref / compilation
   (eglot-highlight-symbol-face :background base4 :weight 'bold)
   (eglot-diagnostic-tag-unnecessary-face :foreground base6 :slant 'italic)
   (eglot-diagnostic-tag-deprecated-face  :foreground base6 :strike-through t)
   (eglot-inlay-hint-face :foreground base6 :background base1 :height 0.9)
   (eglot-parameter-hint-face :inherit 'eglot-inlay-hint-face)
   (eglot-type-hint-face      :inherit 'eglot-inlay-hint-face)
   (eglot-mode-line :foreground cyan :weight 'bold)
   (flymake-error   :underline `(:style wave :color ,red-br))
   (flymake-warning :underline `(:style wave :color ,yellow))
   (flymake-note    :underline `(:style wave :color ,green-br))
   (flymake-error-echo   :foreground red-br)
   (flymake-warning-echo :foreground yellow)
   (flymake-note-echo    :foreground cyan)
   ;; nordic DiagnosticVirtualText* use a gray1 background
   (flymake-error-echo-at-eol   :foreground red-br :background base3)
   (flymake-warning-echo-at-eol :foreground yellow :background base3)
   (flymake-note-echo-at-eol    :foreground cyan   :background base3)
   (compilation-error   :foreground red-br :weight 'bold)
   (compilation-warning :foreground yellow :slant 'italic)
   (compilation-info    :foreground green)
   (compilation-line-number   :foreground base7)
   (compilation-column-number :foreground base6)
   (compilation-mode-line-exit :foreground green  :weight 'bold)
   (compilation-mode-line-fail :foreground red-br :weight 'bold)
   (xref-file-header :foreground cyan :weight 'bold)
   (xref-line-number :foreground base7)
   (xref-match :inherit 'match)

   ;;;; dirvish / dired
   (dirvish-hl-line :background base4 :extend t)
   (dirvish-git-commit-message-face :foreground base7 :slant 'italic)
   (dired-directory :foreground blue :weight 'bold)   ; Directory = blue1
   (dired-symlink   :foreground teal :slant 'italic)
   (dired-broken-symlink :foreground red :strike-through t)
   (dired-header    :foreground cyan :weight 'bold)
   (dired-mark      :foreground yellow :weight 'bold)
   (dired-marked    :foreground yellow :weight 'bold)
   (dired-flagged   :foreground red :weight 'bold)
   (dired-perm-write :foreground orange)
   (dired-ignored   :foreground base5)
   (dired-warning   :foreground yellow)

   ;;;; vterm / ansi-color -- nordic's terminal palette
   (vterm-color-black   :background base4 :foreground base4)
   (vterm-color-red     :background red     :foreground red)
   (vterm-color-green   :background green   :foreground green)
   (vterm-color-yellow  :background yellow  :foreground yellow)
   (vterm-color-blue    :background blue    :foreground blue)
   (vterm-color-magenta :background magenta :foreground magenta)
   (vterm-color-cyan    :background teal    :foreground teal)
   (vterm-color-white   :background fg      :foreground fg)
   (ansi-color-black   :foreground base0 :background base0)
   (ansi-color-red     :foreground red     :background red)
   (ansi-color-green   :foreground green   :background green)
   (ansi-color-yellow  :foreground yellow  :background yellow)
   (ansi-color-blue    :foreground blue    :background blue)
   (ansi-color-magenta :foreground magenta :background magenta)
   (ansi-color-cyan    :foreground teal    :background teal)
   (ansi-color-white   :foreground fg      :background fg)
   (ansi-color-bright-black   :foreground base6    :background base6)
   (ansi-color-bright-red     :foreground red-br   :background red-br)
   (ansi-color-bright-green   :foreground green-br :background green-br)
   (ansi-color-bright-yellow  :foreground yellow-br :background yellow-br)
   (ansi-color-bright-blue    :foreground cyan     :background cyan)
   (ansi-color-bright-magenta :foreground violet   :background violet)
   (ansi-color-bright-cyan    :foreground cyan-br  :background cyan-br)
   (ansi-color-bright-white   :foreground base8    :background base8)

   ;;;; css-mode / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground teal)   ; properties are cyan in nordic
   (css-selector             :foreground yellow)

   ;;;; markdown-mode -- nordic @markup.heading.N
   (markdown-markup-face :foreground base7)
   (markdown-header-delimiter-face :foreground yellow :weight 'bold)
   (markdown-header-face   :inherit 'bold :foreground fg-alt)
   (markdown-header-face-1 :inherit 'bold :foreground yellow)
   (markdown-header-face-2 :inherit 'bold :foreground orange)
   (markdown-header-face-3 :inherit 'bold :foreground magenta)
   (markdown-header-face-4 :foreground green)
   (markdown-header-face-5 :foreground cyan :slant 'italic)
   (markdown-header-face-6 :foreground teal :slant 'italic)
   (markdown-url-face      :foreground blue :underline t)
   (markdown-link-face     :foreground teal)     ; @markup.link = cyan.base
   (markdown-list-face     :foreground yellow :weight 'bold)
   (markdown-hr-face       :foreground base5)
   (markdown-blockquote-face :foreground base7 :slant 'italic)
   ;; CodeBlock = { bg = bg_float, fg = fg }
   (markdown-code-face        :background base1 :extend t)
   (markdown-inline-code-face :background base2 :foreground green)
   (markdown-pre-face         :background base1 :foreground green)
   (markdown-italic-face      :slant 'italic)
   (markdown-bold-face        :weight 'bold)

   ;;;; org <built-in>
   ((org-block &override)            :background base1)
   ((org-block-begin-line &override) :background base1 :foreground base6 :slant 'italic)
   ((org-block-end-line &override)   :background base1 :foreground base6 :slant 'italic)
   ((org-code &override)     :foreground green)
   ((org-verbatim &override) :foreground green)
   (org-hide :foreground hidden)
   (org-todo :foreground base0 :background yellow-dm :weight 'bold)
   (org-done :foreground green :weight 'bold)
   (org-headline-done :foreground base6)
   (org-link :foreground teal :underline t)
   (org-tag  :foreground yellow)
   (org-date :foreground blue :underline t)
   (org-table :foreground teal)
   (org-document-title :foreground fg-alt :weight 'bold)  ; Title = white1 bold
   (org-level-1 :foreground yellow  :weight 'bold :height 1.1)
   (org-level-2 :foreground orange  :weight 'bold)
   (org-level-3 :foreground magenta :weight 'bold)
   (org-level-4 :foreground green)
   (org-level-5 :foreground cyan :slant 'italic)
   (org-level-6 :foreground teal :slant 'italic)
   (org-level-7 :foreground blue)
   (org-level-8 :foreground violet)

   ;;;; nix-mode / sh
   (nix-attribute-face :foreground cyan)
   (nix-builtin-face   :foreground dark-blue)
   (sh-heredoc     :foreground green)
   (sh-quoted-exec :foreground violet)

   ;;;; solaire-mode
   (solaire-default-face :inherit 'default :background base2)
   (solaire-hl-line-face :inherit 'hl-line :background base4)
   (solaire-mode-line-face :inherit 'mode-line :background modeline-bg-l
                           :box (if -padding `(:line-width ,-padding :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive :background modeline-bg-inactive-l
    :box (if -padding `(:line-width ,-padding :color ,modeline-bg-inactive-l)))

   ;;;; misc UI
   ;; nordic: TabLine fg=white0 bg=black0; TabLineSel fg=white1 bg=bg
   (tab-bar        :background base0 :foreground fg)
   (tab-bar-tab    :background bg    :foreground fg-alt :weight 'bold)
   (tab-bar-tab-inactive :background base0 :foreground fg)
   (tab-line        :background base0 :foreground fg)
   (tab-line-tab    :background bg    :foreground fg-alt)
   (tab-line-tab-current :background bg :foreground fg-alt :weight 'bold)
   (tab-line-tab-inactive :background base0 :foreground fg)
   (widget-field :background base4 :foreground fg :extend nil)
   (custom-group-tag    :foreground cyan :weight 'bold)
   (custom-variable-tag :foreground yellow :weight 'bold)
   (custom-state        :foreground green)
   (help-key-binding :foreground yellow :background base1 :weight 'bold)
   (info-menu-star :foreground yellow)
   (whitespace-tab        :foreground base4 :background 'unspecified)
   (whitespace-space      :foreground base4 :background 'unspecified)
   (whitespace-newline    :foreground base4 :background 'unspecified)
   (whitespace-indentation :foreground base4 :background 'unspecified)
   (whitespace-trailing   :background red)
   (highlight-indentation-face :background base2)
   (highlight-indentation-current-column-face :background base4)
   (fill-column-indicator :foreground base3)
   (completions-common-part :foreground yellow :weight 'bold)
   (completions-first-difference :foreground magenta)
   (minibuffer-prompt :foreground cyan :weight 'bold)
   (window-divider :foreground base0)
   (window-divider-first-pixel :foreground base0)
   (window-divider-last-pixel  :foreground base0)
   (separator-line :foreground base0)
   (child-frame-border :background base0)
   (posframe-border :background base0)
   (hydra-face-red      :foreground red     :weight 'bold)
   (hydra-face-blue     :foreground blue    :weight 'bold)
   (hydra-face-amaranth :foreground magenta :weight 'bold)
   (hydra-face-pink     :foreground violet  :weight 'bold)
   (hydra-face-teal     :foreground teal    :weight 'bold)
   (puni-blink-region-face :background base4)
   (eldoc-box-border :background base0)
   (eldoc-highlight-function-argument :foreground yellow :weight 'bold))

  ;;;; Base theme variable overrides
  ((treesit-font-lock-level
    (if doom-nordic-raise-treesit-level 4 treesit-font-lock-level))
   (vc-annotate-background bg)
   (vc-annotate-color-map
    `((20  . ,green)
      (40  . ,(doom-blend green teal 0.6))
      (60  . ,(doom-blend green teal 0.3))
      (80  . ,teal)
      (100 . ,(doom-blend teal cyan 0.5))
      (120 . ,cyan)
      (140 . ,(doom-blend cyan yellow 0.5))
      (160 . ,yellow)
      (180 . ,(doom-blend yellow orange 0.5))
      (200 . ,orange)
      (220 . ,(doom-blend orange red 0.5))
      (240 . ,red)
      (260 . ,red-br)
      (280 . ,(doom-blend red magenta 0.5))
      (300 . ,magenta)
      (320 . ,violet)
      (340 . ,base7)
      (360 . ,base7)))
   (vc-annotate-very-old-color base7)))

;;; doom-nordic-theme.el ends here
