;;; treesit-ispell.el --- Run ispell on tree-sitter text nodes -*- lexical-binding: t -*-

;; Copyright © 2024 Erick Navarro
;; Author: Erick Navarro <erick@navarro.io>
;; URL: https://github.com/erickgnavar/treesit-ispell.el
;; Version: 0.1.0
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Package-Requires: ((emacs "29.1"))

;;; Commentary:

;; Run spell check against treesit text nodes.

;;; Code:

(require 'seq)
(require 'cl-lib)
(require 'treesit)

;;TODO: Add more languages, inspect their grammars and define their text elements
(defcustom treesit-ispell-grammar-text-mapping
  '((python-ts-mode . (string_content comment))
    (dockerfile-ts-mode . (comment))
    (rust-ts-mode . (line_comment))
    (elixir-ts-mode . (quoted_content comment)))
  "All the supported text elements for each grammar."
  :type '(alist :key-type symbol :value-type sexp)
  :group 'treesit-ispell)

(defun treesit-ispell--check-loaded-grammar ()
  "Check if treesit is available and if there is a grammar loaded already."
  (unless (treesit-language-at (point))
    (user-error "There is no grammar loaded for this mode")))

(defun treesit-ispell--get-text-node-at-point ()
  "Get text node at point using predefined major mode options."
  (seq-some
   (lambda (x)
     (let* ((lang (treesit-language-at (point)))
            (node (treesit-node-at (point) lang))
            (query (treesit-query-compile lang (format  "((%s) @%s)" x x)))
            (capture (treesit-query-capture node query)))
       (and capture node)))
   (alist-get major-mode treesit-ispell-grammar-text-mapping)))

(defun treesit-ispell--run-ispell-on-node (node)
  "Run ispell over the text of the received `NODE'."
  (ispell-region (treesit-node-start node) (treesit-node-end node)))

;;;###autoload
(defun treesit-ispell-run-at-point ()
  "Run ispell at current point if there is a text node."
  (interactive)
  (treesit-ispell--check-loaded-grammar)
  (when-let ((node (treesit-ispell--get-text-node-at-point)))
    (treesit-ispell--run-ispell-on-node node)))

(provide 'treesit-ispell)

;;; treesit-ispell.el ends here
