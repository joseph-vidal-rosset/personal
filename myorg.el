;;; org.el ---                    -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2020  Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph.vidal.rosset@gmail.com>
;; Keywords:

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

;;;
(require 'org)
(require 'org-capture)
(setq org-use-speed-commands t)
;; resize images
(setq org-image-actual-width nil)
;;LaTeX export for Org-Mode
(require 'ox-latex)
(setq org-src-fontify-natively t)
(setq org-highlight-latex-and-related '(latex))
(setq org-highlight-latex-and-related '(latex script entities))
;(setq org-latex-listings 'minted)
(require 'ob-latex)
(require 'org-auctex-keys)
(require 'org-mime)
(setq org-mime-library 'mml)
;; from Kitchin
;;(require 'org-install)
;; fontify code in code blocks
(require 'ob-latex)
(setq org-src-fontify-natively t)
(require 'ox-html)
(require 'ox-ascii)
(setq org-src-fontify-natively t)
(require 'org-protocol)
(require 'ox-beamer)
;(beacon-mode 1)
(require 'org-context)
(org-context-mode)
(setq org-ref-show-broken-links nil)
(require 'outorg)
(require 'ox-word)
(require 'org-mouse)



;; ======================================================================
;; Restaurer les processus LaTeX pour Org 9.7+
;; ======================================================================

(with-eval-after-load 'org
  (setq org-preview-latex-process-alist
        '((dvipng
           :programs ("latex" "dvipng")
           :description "dvi > png"
           :message "you need to install latex and dvipng."
           :image-input-type "dvi"
           :image-output-type "png"
           :image-size-adjust (1.0 . 1.0)
           :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
           :image-converter ("dvipng -D %D -T tight -o %O %f")
           :transparent-image-converter ("dvipng -D %D -T tight -bg Transparent -o %O %f"))
          (imagemagick
           :programs ("pdflatex" "convert")
           :description "pdf > png"
           :message "you need to install pdflatex and imagemagick."
           :image-input-type "pdf"
           :image-output-type "png"
           :image-size-adjust (1.0 . 1.0)
           :latex-compiler ("pdflatex -interaction nonstopmode -output-directory %o %f")
           :image-converter ("convert -density 150 %f -quality 90 %O"))))

  ;; Maintenant sélectionner dvipng
  (setq org-preview-latex-default-process 'dvipng)
  (setq org-html-with-latex 'dvipng))


;; Préambule LaTeX personnalisé pour les snippets
(with-eval-after-load 'org
  (add-to-list 'org-latex-packages-alist '("" "fitch" t))
  (add-to-list 'org-latex-packages-alist '("" "bussproofs" t))
  ;; Ajouter bussproofs pour les arbres de preuve
  (with-eval-after-load 'org
    (add-to-list 'org-latex-packages-alist '("" "bussproofs" t))

    (setq org-latex-packages-alist
          '(("" "amsmath" t)
            ("" "amssymb" t)
            ("" "fitch" t)
            ("" "bussproofs" t))))

  ;; Ou essayer logicproof à la place
  ;; (add-to-list 'org-latex-packages-alist '("" "logicproof" t))

  (setq org-latex-default-packages-alist
        (cons '("" "fitch" t) org-latex-default-packages-alist)))


;; Préambule LaTeX complet pour snippets avec numérotation Fitch
(with-eval-after-load 'org
  (setq org-latex-packages-alist
        '(("" "amsmath" t)
          ("" "amssymb" t)
          ("" "fitch" t)))

  ;; Préambule spécifique pour les fragments LaTeX
  (setq org-format-latex-header
        "\\documentclass{article}
\\usepackage[usenames]{color}
\\usepackage{amsmath}
\\usepackage{amssymb}
\\usepackage{fitch}
\\usepackage{bussproofs}
\\pagestyle{empty}
[PACKAGES]
[DEFAULT-PACKAGES]
\\begin{document}"))

; (with-eval-after-load 'ox
					; (require ' ox-pandoc))
 ;
;
;
  ;; Add minted to the defaults packages to include when exporting.
 ;; (add-to-list 'org-latex-packages-alist '("" "minted"))
;; Tell the latex export to use the minted package for source
;; code coloration.
					;(setq org-latex-listings 'minted)

;; Add minted to the defaults packages to include when exporting.
					;	(add-to-list 'org-latex-packages-alist '("" "minted"))
;; Tell the latex export to use the minted package for source
;; code coloration.
					;	(setq org-latex-listings 'minted)
;; Let the exporter use the -shell-escape option to let latex
;; execute external programs.
;; This obviously and can be dangerous to activate!
					; (setq org-latex-pdf-process
;;     '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")


(setq
 org-ref-formatted-citation-formats
 '(("text"
    ("org"
     ("misc" . "${author}, /${title}/ *${howpublished}* ${url} (${year}).")))))

;(citeproc-org-setup)

;(require 'org-mime)
;(setq org-mime-library 'mml)

; (setq org-export-before-parsing-hook '(org-ref-csl-preprocess-buffer))

;; ======================================================================
;; Configuration LaTeX pour Org 9.7+ (CORRIGÉ - sans require)
;; ======================================================================

(with-eval-after-load 'org
  ;; Sélectionner dvipng comme processus par défaut
  (setq org-latex-preview-process-default 'dvipng)

  ;; Pour l'export HTML
  (setq org-html-with-latex 'dvipng)

  ;; Configuration du processus dvipng
  (plist-put org-format-latex-options :scale 1.5))




(provide 'org)
;;; org.el ends here
