;;; -*- lexical-binding:  t -*-
(prelude-require-packages '(
                            auto-dictionary
                            autoinsert
                            bbdb
                            citeproc
                            ediprolog
                            flyspell
                            org
                            org-bullets
                            org-context
                            org-mime
                            org-ref
                            outorg
                            ox-pandoc
                            ox-tufte
                            page-break-lines
                            tangotango-theme
                            vlf
                            w3m
                            yasnippet
                            yasnippet-snippets
                            )
                          )

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(add-to-list 'package-archives '("nongnu-devel" . "https://elpa.nongnu.org/nongnu-devel/"))
