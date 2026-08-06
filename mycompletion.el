;;; mycompletion.el ---                              -*- lexical-binding: t; -*-

;; Copyright (C) 2026  

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


;;; Complétion du minibuffer : Vertico + Orderless
;;; Les deux paquets sont déjà installés (voir package-selected-packages) ;
;;; le module prelude-vertico reste désactivé, on configure directement.

(require 'vertico)
(vertico-mode 1)
(setq vertico-count 15)          ; nombre de candidats affichés

(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles partial-completion))))


(provide 'mycompletion)
;;; mycompletion.el ends here
