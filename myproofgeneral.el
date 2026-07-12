;;; myproofgeneral.el --- Proof General configuration -*- lexical-binding: t; -*-

(load "~/.emacs.d/lisp/PG/generic/proof-site")

(require 'htmlize)
(setq org-html-htmlize-output-type 'css)

;; Coq classique (pas Rocq 9)
(setq coq-prog-name "coqtop")

;; PhoX
(add-to-list 'auto-mode-alist '("\\.phx\\'" . phox-mode))
(setq phox-prog-name "./phox -I /usr/local/lib/phox")


(provide 'myproofgeneral)
