;;; fitch-preview.el --- voir les preuves fitch      -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2025

;; Author:  <joseph@vidal-rosset.net>
;; Keywords: convenience

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

;;

;;; Code:


;;; fitch-preview.el --- Fitch LaTeX preview config -*- lexical-binding: t; -*-

(with-eval-after-load 'org
  ;; Ajouter fitch. sty au préambule
  (add-to-list 'org-latex-packages-alist '("" "fitch" t))
  (add-to-list 'org-latex-packages-alist '("" "bussproofs" t))

  ;; Augmenter la taille des images
  (plist-put org-format-latex-options :scale 1.5)

  ;; Forcer dvipng
  (setq org-preview-latex-default-process 'dvipng))

;; Raccourci F3
(global-set-key (kbd "<f3>") 'org-latex-preview)

(provide 'fitch-preview)
;;; fitch-preview.el ends here
