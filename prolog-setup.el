;;; prolog-setup.el ---                              -*- lexical-binding: t; -*-

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

;;; prolog-setup.el --- Configuration Prolog

;;; Commentary:
;; Configuration simple pour Prolog dans Prelude

;;; Code:

;; Association des fichiers .pl avec prolog-mode
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
(add-to-list 'auto-mode-alist '("\\.pro\\'" . prolog-mode))
(add-to-list 'auto-mode-alist '("\\.prolog\\'" . prolog-mode))

;; Configuration après chargement de prolog-mode
(with-eval-after-load 'prolog
  (setq prolog-system 'swi)
  (setq prolog-program-name "swipl"))

;; Keybindings
(add-hook 'prolog-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-l") 'prolog-consult-file)
            (local-set-key (kbd "C-c C-b") 'prolog-consult-buffer)
            (local-set-key (kbd "C-c C-z") 'run-prolog)))

(provide 'prolog-setup)
;;; prolog-setup.el ends here

(provide 'prolog-setup)
;;; prolog-setup.el ends here
