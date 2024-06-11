# treesit-ispell.el

[![MELPA](https://melpa.org/packages/treesit-ispell-badge.svg)](https://melpa.org/#/treesit-ispell)

Run ispell on text nodes, this works using `treesit` built-in package.

## Installation

### Cloning the repo

Clone this repo somewhere, and add this to your config:

```elisp
(add-to-list 'load-path "path where the repo was cloned")

(require 'treesit-ispell)
```

### Using straight.el

```emacs-lisp
(use-package treesit-ispell
  :straight (treesit-ispell
             :type git
             :host github
             :repo "erickgnavar/treesit-ispell.el"))
```

### Using use-package

```emacs-lisp
(use-package treesit-ispell
  :ensure t)
```

## Usage

`M-x treesit-ispell-run-at-point` to use the node at the current position

It can also be attached to a keybinding, for example:

```emacs-lisp
(global-set-key (kbd "C-x C-s") 'treesit-ispell-run-at-point)
```
