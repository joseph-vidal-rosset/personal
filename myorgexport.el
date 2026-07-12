;; org-export.el --- org-export settings            -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2020  Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph.vidal.rosset@gmail.com>
;; Keywords: files

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; in this file org-export settings
(require 'org)
(require 'ox-latex)
(require 'bibtex)
(require 'org-ref)
(require 'org-ref-ivy)


(require 'oc)
(require 'oc-csl)
(require 'citeproc)

;; Configuration org-cite
(setq org-cite-global-bibliography '("~/Dropbox/org/blog/blog.bib"))
(setq org-cite-csl-styles-dir "/home/joseph/.emacs.d/personal/csl/")

;; Export processor
(setq org-cite-export-processors
      '((html csl "oil-shale.csl")
        (latex biblatex)
        (t basic)))
;;; Code:
;; bibliography - notes - etc.
;; (setq reftex-default-bibliography '("~/Dropbox/Orgzly/reforg.bib"))
;; see org-ref for use of these variables

(setq bibtex-completion-bibliography '("~/Dropbox/org/blog/blog.bib")
      bibtex-completion-library-path '("~/MEGA/Documents/")
      bibtex-completion-notes-path "~/Dropbox/Orgzly/notes.org"
      bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"
      bibtex-completion-additional-search-fields '(keywords)
      bibtex-completion-display-formats
      '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
       (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
       (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
       (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
       (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
       bibtex-completion-pdf-open-function
       (lambda (fpath)
         (call-process "open" nil 0 nil fpath)))

(setq org-ref-csl-styles-directory "/home/joseph/.emacs.d/personal/csl/")
(setq org-ref-csl-default-style "oil-shale.csl")

(require 'bibtex)

(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "-"
      bibtex-autokey-year-title-separator "-"
      bibtex-autokey-titleword-separator "-"
      bibtex-autokey-titlewords 2
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5
      org-ref-bibtex-hydra-key-binding (kbd "H-b"))

(define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-hydra/body)

(define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)


(defun cite-with-pages (key page)
  (interactive
   (list
    (car (reftex-citation t))
    (read-from-minibuffer "page: ")))
  (insert (format "[[cite:%s][page %s]]" key page)))

;; make sure `org-auctex-key-bindings.el' is in your `load-path'
(add-to-list 'load-path "~/.emacs.d/core/org-auctex-keys")


(setq   org-export-with-broken-links t
        org-latex-pdf-process
        '("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
	"bibtex %b"
	"pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
	"pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"))

;(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

;(setq bibtex-autokey-year-length 4
;      bibtex-autokey-name-year-separator "-"
;      bibtex-autokey-year-title-separator "-"
;      bibtex-autokey-titleword-separator "-"
;      bibtex-autokey-titlewords 2
;      bibtex-autokey-titlewords-stretch 1
;      bibtex-autokey-titleword-length 5)

;(let  ((org-export-with-broken-links t)
;     (org-latex-pdf-process
;       '("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
;	 "bibtex %b"
;	 "makeindex %b"
;	 "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
;	 "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f")))
;  (org-open-file (org-latex-export-to-pdf)))
