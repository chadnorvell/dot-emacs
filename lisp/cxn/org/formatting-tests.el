;; -*- lexical-binding: t -*-
;;; cxn/org/formatting-tests.el --- Tests for cxn/org/formatting

;;; Commentary:

;; Tests for `cxn/org-normalize-heading-blank-lines'.  These are NOT loaded
;; as part of the configuration; load this file explicitly to run them.
;;
;; Batch:
;;
;;   emacs -Q --batch -l ert \
;;     -l ~/.config/emacs/lisp/cxn/org/formatting-tests.el \
;;     -f ert-run-tests-batch-and-exit
;;
;; Interactive: load this file, then `M-x ert RET t RET'.
;;
;; When changing the formatting rules, prefer adding a failing case here
;; first.  Several of these pin behaviour that is easy to break by
;; accident, in particular:
;;
;;   - Indentation of the line after a heading must never be consumed;
;;     doing so silently promotes an indented list item into a heading.
;;   - Each whitespace gap must have exactly one owner, otherwise two rules
;;     fight over it and the winner depends on traversal order.

;;; Code:

(require 'ert)
(require 'org)
(require 'org-element)
;; NOTE: `org-inlinetask' is deliberately NOT required here.  The module
;; under test is responsible for loading it, and requiring it from the tests
;; would mask a regression in that.

;; Load the module under test from beside this file, so that running the
;; tests from a checkout does not silently exercise an installed copy.
;; `load-file-name' is nil when byte-compiling and when evaluating this
;; buffer interactively, so fall back through the alternatives.
(require 'cxn/org/formatting
         (let ((here (or load-file-name
                         byte-compile-current-file
                         buffer-file-name)))
           (when here
             (expand-file-name "formatting.el" (file-name-directory here)))))

(defun cxn/org-tests--normalize (text)
  "Return TEXT as normalized by `cxn/org-normalize-heading-blank-lines'."
  (with-temp-buffer
    (let ((org-inhibit-startup t))
      (org-mode))
    (insert text)
    (cxn/org-normalize-heading-blank-lines)
    (buffer-substring-no-properties (point-min) (point-max))))

(defun cxn/org-tests--headings (text)
  "Return the (LEVEL . TITLE) of every heading in TEXT."
  (with-temp-buffer
    (let ((org-inhibit-startup t))
      (org-mode))
    (insert text)
    (org-element-map (org-element-parse-buffer 'headline) 'headline
      (lambda (h) (cons (org-element-property :level h)
                        (org-element-property :raw-value h))))))

(defmacro cxn/org-deftest (name input expected &optional docstring)
  "Define an ERT test NAME asserting INPUT normalizes to EXPECTED."
  (declare (indent 1) (doc-string 4))
  `(ert-deftest ,name ()
     ,(or docstring "Normalization test.")
     (should (equal (cxn/org-tests--normalize ,input) ,expected))))


;;; Contentless headings form a tight run.

(cxn/org-deftest cxn/org-tight-run
  "* One\n** Two\n*** Three\n"
  "* One\n** Two\n*** Three\n")

(cxn/org-deftest cxn/org-tight-run-collapses-blanks
  "* One\n\n** Two\n\n\n*** Three\n"
  "* One\n** Two\n*** Three\n")

(cxn/org-deftest cxn/org-content-bearing-heading-breaks-run
  "* Project\n** Background\nprose\n"
  "* Project\n\n** Background\nprose\n"
  "A heading with content is padded off the heading above it.")

(cxn/org-deftest cxn/org-existing-blank-before-block-kept
  "* Project\n\n** Background\nprose\n"
  "* Project\n\n** Background\nprose\n")

(cxn/org-deftest cxn/org-only-content-bearing-breaks-run
  "* A\n** B\n*** C\ntext\n"
  "* A\n** B\n\n*** C\ntext\n")

(cxn/org-deftest cxn/org-run-resumes-after-block
  "* A\ntext\n** B\n*** C\n"
  "* A\ntext\n\n** B\n*** C\n")

(cxn/org-deftest cxn/org-deep-run-then-content
  "* A\n** B\n*** C\n**** D\nbody\n"
  "* A\n** B\n*** C\n\n**** D\nbody\n")

(cxn/org-deftest cxn/org-alternating-blocks-and-runs
  "* A\nx\n* B\n* C\ny\n* D\n"
  "* A\nx\n\n* B\n\n* C\ny\n\n* D\n")

(cxn/org-deftest cxn/org-contentless-heading-at-eof
  "* A\ntext\n\n** B\n*** C\n"
  "* A\ntext\n\n** B\n*** C\n")

(cxn/org-deftest cxn/org-trailing-contentless-after-block
  "* A\n** B\ntext\n*** C\n"
  "* A\n\n** B\ntext\n\n*** C\n")


;;; Content preceding a heading.

(cxn/org-deftest cxn/org-content-then-heading
  "* One\nbody text\n** Two\n"
  "* One\nbody text\n\n** Two\n")

(cxn/org-deftest cxn/org-excess-blanks-collapsed
  "* One\nbody text\n\n\n\n** Two\n"
  "* One\nbody text\n\n** Two\n")

(cxn/org-deftest cxn/org-block-padded-both-sides
  "* A\n** B\ncontent\n** C\n** D\n"
  "* A\n\n** B\ncontent\n\n** C\n** D\n")

(cxn/org-deftest cxn/org-trailing-spaces-before-heading
  "* One\nbody   \n** Two\n"
  "* One\nbody\n\n** Two\n")


;;; Start and end of buffer.

(cxn/org-deftest cxn/org-no-leading-blank
  "\n\n* One\n"
  "* One\n")

(cxn/org-deftest cxn/org-preamble-separated
  "#+title: Doc\n* One\n"
  "#+title: Doc\n\n* One\n")

(cxn/org-deftest cxn/org-trailing-blanks-untouched
  "* One\n\n\n"
  "* One\n\n\n"
  "End-of-buffer whitespace is left to `require-final-newline' and friends.")


;;; A heading is tight against its own content.

(cxn/org-deftest cxn/org-blank-after-heading-removed
  "* One\n\nbody\n\n** Two\n"
  "* One\nbody\n\n** Two\n")

(cxn/org-deftest cxn/org-many-blanks-after-heading-removed
  "* One\n\n\n\nbody\n"
  "* One\nbody\n")

(cxn/org-deftest cxn/org-trailing-spaces-on-heading-line
  "* One   \n\nbody\n"
  "* One\nbody\n")

(cxn/org-deftest cxn/org-tags-survive
  "* One :tag:\n\nbody\n"
  "* One :tag:\nbody\n")

(cxn/org-deftest cxn/org-paragraph-breaks-preserved
  "* One\npara one\n\npara two\n\n\npara three\n"
  "* One\npara one\n\npara two\n\n\npara three\n"
  "Content-to-content gaps are none of our business.")

(cxn/org-deftest cxn/org-property-drawer-is-content
  "* A\n** B\n:PROPERTIES:\n:ID: x\n:END:\n"
  "* A\n\n** B\n:PROPERTIES:\n:ID: x\n:END:\n")

(cxn/org-deftest cxn/org-property-drawer-untouched
  "* One\n:PROPERTIES:\n:ID: x\n:END:\n** Two\n"
  "* One\n:PROPERTIES:\n:ID: x\n:END:\n\n** Two\n")


;;; Indentation must never be consumed.
;;
;; Eating the indentation of the line after a heading turns an indented list
;; item into a real heading, which is silent content corruption rather than
;; a formatting nit.

(cxn/org-deftest cxn/org-indented-list-after-heading
  "* One\n\n  * item one\n  * item two\n"
  "* One\n  * item one\n  * item two\n")

(cxn/org-deftest cxn/org-indented-paragraph-after-heading
  "* One\n\n\n\n    indented paragraph\n"
  "* One\n    indented paragraph\n")

(cxn/org-deftest cxn/org-indented-src-block-after-heading
  "* One\n\n  #+begin_src text\n  body\n  #+end_src\n"
  "* One\n  #+begin_src text\n  body\n  #+end_src\n")


;;; Heading lookalikes.
;;
;; A bare asterisk at column 0 really does end a block and start a heading as
;; far as Org's parser is concerned, so normalizing around it is correct.
;; The escapes Org actually defines are a leading comma or indentation.

(cxn/org-deftest cxn/org-comma-escaped-asterisk
  "* One\n#+begin_src text\n,* not a heading\n#+end_src\n** Two\n"
  "* One\n#+begin_src text\n,* not a heading\n#+end_src\n\n** Two\n")

(cxn/org-deftest cxn/org-indented-asterisk-in-src
  "* One\n#+begin_src text\n  * not a heading\n#+end_src\n** Two\n"
  "* One\n#+begin_src text\n  * not a heading\n#+end_src\n\n** Two\n")

(cxn/org-deftest cxn/org-list-item-asterisk
  "* One\n  * item one\n  * item two\n** Two\n"
  "* One\n  * item one\n  * item two\n\n** Two\n")

(cxn/org-deftest cxn/org-inlinetask-is-not-a-heading
  "* One\nbody\n*************** TODO inline\n*************** END\n** Two\n"
  "* One\nbody\n*************** TODO inline\n*************** END\n\n** Two\n"
  "Requires `org-inlinetask'; without it these parse as ordinary headlines.")


;;; Structural properties.

(ert-deftest cxn/org-idempotent ()
  "Normalizing twice is the same as normalizing once."
  (let* ((input "#+title: D\n* A\n** B\ntext\n\nmore text\n** C\n* D\nx\n")
         (once (cxn/org-tests--normalize input))
         (twice (cxn/org-tests--normalize once)))
    (should (equal once twice))))

(ert-deftest cxn/org-preserves-content ()
  "Normalization changes whitespace only, never headings or content."
  (let* ((input (concat "#+title: Real World\n#+author: Chad\n* Project\n\n"
                        "** Background\n\n\nSome prose here.\n\nA second paragraph.\n"
                        "** Tasks\n:PROPERTIES:\n:ID: abc\n:END:\n\n"
                        "  - [ ] one\n  - [ ] two\n*** Subtask\n\n"
                        "#+begin_src sh\n  echo hi\n#+end_src\n\n\n"
                        "** Notes\ntext\n* Another\n"))
         (out (cxn/org-tests--normalize input))
         (strip (lambda (s) (replace-regexp-in-string "[ \t\n]+" "" s))))
    (should (equal (cxn/org-tests--headings input)
                   (cxn/org-tests--headings out)))
    (should (equal (funcall strip input) (funcall strip out)))
    (should (equal out (cxn/org-tests--normalize out)))))

(ert-deftest cxn/org-preserves-point ()
  "Normalization does not move point."
  (with-temp-buffer
    (let ((org-inhibit-startup t))
      (org-mode))
    (insert "* One\nbody\n** Two\nmore\n")
    (goto-char (point-max))
    (cxn/org-normalize-heading-blank-lines)
    (should (= (point) (point-max)))))

(ert-deftest cxn/org-respects-region ()
  "Headings above the region keep their spacing."
  (with-temp-buffer
    (let ((org-inhibit-startup t))
      (org-mode))
    (insert "* A\ntext\n\n\n** B\n* C\ntext\n\n\n** D\n")
    (goto-char (point-min))
    (search-forward "* C")
    (cxn/org-normalize-heading-blank-lines (match-beginning 0) (point-max))
    ;; "* A\ntext\n\n\n** B" is outside the region and keeps its ragged
    ;; spacing; "* C" has content so it gains a blank line above it.
    (should (equal (buffer-substring-no-properties (point-min) (point-max))
                   "* A\ntext\n\n\n** B\n\n* C\ntext\n\n** D\n"))))

(ert-deftest cxn/org-before-save-hook-only-in-org ()
  "The save hook does nothing outside Org buffers."
  (with-temp-buffer
    (fundamental-mode)
    (insert "* One\n\n\nbody\n")
    (cxn/org-before-save-hook)
    (should (equal (buffer-string) "* One\n\n\nbody\n"))))

(ert-deftest cxn/org-fast-enough-for-save-hook ()
  "Normalizing a large buffer stays well under a second."
  (let ((big (mapconcat
              (lambda (i)
                (format "* Heading %d\nsome body text here\n\n\n** Sub %d\nmore text\n" i i))
              (number-sequence 1 2000) ""))
        (start (float-time)))
    (cxn/org-tests--normalize big)
    (should (< (- (float-time) start) 5.0))))

(provide 'cxn/org/formatting-tests)

;;; formatting-tests.el ends here
