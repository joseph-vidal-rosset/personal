;;; myemail.el ---                                   -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author:  <joseph@vidal-rosset.net>
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

;;; Commentary:



;;; Code:


;; Utiliser imagemagick au lieu de latex+dvipng


(setq org-preview-latex-process-alist
      '((imagemagick
         :programs ("pdflatex" "convert")
         :description "pdf > png"
         :message "you need to install pdflatex and imagemagick."
         :image-input-type "pdf"
         :image-output-type "png"
         :image-size-adjust (1.0 . 1.0)
         :latex-compiler ("pdflatex -interaction nonstopmode -output-directory %o %f")
         :image-converter ("convert -density 150 %f -quality 90 %O"))))

(setq org-preview-latex-default-process 'imagemagick)

(provide 'myemail)
;;; myemail.el ends here
