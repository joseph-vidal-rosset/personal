;;; w3m.el ---                                       -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2025

;; Author:  <joseph@vidal-rosset.net>
;; Keywords: mail, mail,
(add-to-list 'load-path "/usr/share/emacs/site-lisp/w3m")

;; Deferred: w3m's own full load costs ~190ms and is rarely needed at
;; startup. These autoloads keep M-x w3m (and friends) available
;; immediately, without eagerly loading the package — the real load
;; only happens the first time one of them is actually invoked.
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)
(autoload 'w3m-find-file "w3m" "w3m interface function for local file." t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(autoload 'w3m-goto-url "w3m" "Visit URL." t)
