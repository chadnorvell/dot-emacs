;; -*- lexical-binding: t -*-
;;; cxn/org/formatting.el --- Blank-line normalization for Org buffers

;;; Commentary:

;; Format-on-save for Org files.  A heading together with the content
;; belonging to it forms a block; blocks are separated by exactly one blank
;; line, while contentless headings pack together into a tight run.  See
;; `cxn/org-normalize-heading-blank-lines' for the exact rules.
;;
;; Tests live in `formatting-tests.el' beside this file.  They are not
;; loaded as part of the configuration; run them with:
;;
;;   emacs -Q --batch -l ert \
;;     -l ~/.config/emacs/lisp/cxn/org/formatting-tests.el \
;;     -f ert-run-tests-batch-and-exit
;;
;; or interactively by loading that file and running `M-x ert'.

;;; Code:

(require 'org)
;; `org-element' only reports the `inlinetask' type when this is loaded;
;; without it inline tasks parse as ordinary headlines and would be treated
;; as structural headings.
(require 'org-inlinetask)

(defun cxn/org--at-heading-p ()
  "Return non-nil if point is on a real Org heading line.
Unlike `org-at-heading-p' this rejects lines that merely look like
headings, such as inline tasks."
  (and (org-at-heading-p)
       (eq (org-element-type (org-element-at-point)) 'headline)))

(defun cxn/org--heading-positions (beg end)
  "Return, in buffer order, the start position of every heading in BEG..END."
  (let (positions)
    (save-excursion
      (goto-char beg)
      (while (re-search-forward (concat "^" org-outline-regexp) end t)
        (beginning-of-line)
        (when (cxn/org--at-heading-p)
          (push (point) positions))
        (forward-line 1)))
    (nreverse positions)))

(defun cxn/org--next-content-line (pos)
  "Return the start of the first non-blank line after the line holding POS.
Return nil when nothing but blank lines remains before end of buffer."
  (save-excursion
    (goto-char pos)
    (forward-line 1)
    (while (and (not (eobp))
                (looking-at-p "[ \t]*$"))
      (forward-line 1))
    (unless (eobp) (point))))

(defun cxn/org--heading-has-content-p (pos)
  "Return non-nil when the heading at POS is followed by its own content.
A heading whose next non-blank line is another heading, or which ends
the buffer, is contentless."
  (let ((next (cxn/org--next-content-line pos)))
    (and next
         (save-excursion
           (goto-char next)
           (not (cxn/org--at-heading-p))))))

(defun cxn/org--normalize-gap (beg end separator)
  "Replace the whitespace between BEG and END with SEPARATOR.
Does nothing when the text is already exactly SEPARATOR, so that this
function is cheap and does not dirty the buffer needlessly."
  (unless (string= separator (buffer-substring-no-properties beg end))
    (save-excursion
      (goto-char beg)
      (delete-region beg end)
      (insert separator))))

;;;###autoload
(defun cxn/org-normalize-heading-blank-lines (&optional beg end)
  "Normalize the blank lines around Org headings between BEG and END.

A heading together with the content belonging to it forms a block, and
blocks are separated by exactly one blank line:

  - A heading is tight against its own content: no blank line between a
    heading and the text that follows it.

  - A blank line separates a heading from whatever precedes it, whether
    that is content or a contentless heading, so that each
    heading-plus-content block is padded above and below.

  - Contentless headings form a tight run: no blank line between two
    headings when the second has no content of its own.

Blank lines between two pieces of content, such as paragraph breaks
inside a block, are left alone, as is any trailing whitespace at the end
of the buffer.  Leading whitespace before the first heading is removed.

Interactively, operate on the region when it is active and on the whole
buffer otherwise."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil)))
  (let ((beg (or beg (point-min)))
        (end (or end (point-max))))
    (save-excursion
      ;; Work backwards so that edits, which only ever resize whitespace,
      ;; cannot invalidate the positions we have not processed yet.
      (dolist (pos (nreverse (cxn/org--heading-positions beg end)))
        ;; Every gap has exactly one owner.  The gap between a heading and
        ;; its own content belongs to this heading and is always tight; the
        ;; gap between two headings belongs to the *second* of them and is
        ;; handled below, so it is deliberately skipped here.
        (when (cxn/org--heading-has-content-p pos)
          (let ((text-end (save-excursion
                            (goto-char pos)
                            (goto-char (line-end-position))
                            (skip-chars-backward " \t")
                            (point)))
                ;; The beginning of a line, never a position inside it:
                ;; consuming that line's indentation could promote an
                ;; indented list item into a real heading.
                (next (cxn/org--next-content-line pos)))
            (cxn/org--normalize-gap text-end next "\n")))
        ;; The gap *before* the heading.
        (let* ((prev-end (save-excursion
                           (goto-char pos)
                           (skip-chars-backward " \t\n")
                           (point)))
               (separator
                (cond
                 ;; Nothing but whitespace precedes this heading.
                 ((= prev-end (point-min)) "")
                 ;; The previous line is itself a heading, and this heading
                 ;; starts no block of its own.  A content-bearing heading is
                 ;; always followed by its content, so a heading on the
                 ;; previous line is necessarily contentless and the two
                 ;; belong to the same run.
                 ((and (not (cxn/org--heading-has-content-p pos))
                       (save-excursion
                         (goto-char prev-end)
                         (beginning-of-line)
                         (cxn/org--at-heading-p)))
                  "\n")
                 ;; Either the previous line is content, or this heading
                 ;; begins a heading-plus-content block that must be padded.
                 (t "\n\n"))))
          (cxn/org--normalize-gap prev-end pos separator))))))

(defun cxn/org-before-save-hook ()
  "Normalize Org heading spacing before saving an Org buffer."
  (when (derived-mode-p 'org-mode)
    (cxn/org-normalize-heading-blank-lines)))

(provide 'cxn/org/formatting)

;;; formatting.el ends here
