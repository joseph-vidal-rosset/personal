;;; saut-de-lignes-intempestif.el --- pour éviter les sauts de lignes intempestifs  -*- lexical-binding: t; -*-

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

;;

;;; Code:

;; 1. Désactiver définitivement auto-fill-mode en org-mode
(add-hook 'org-mode-hook (lambda () (auto-fill-mode -1)))

;; 2. Empêcher le repliement intempestif par TAB
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "TAB")
              (lambda ()
                (interactive)
                (if (and (bolp) (looking-at org-outline-regexp))
                    (org-cycle)
                  (self-insert-command 1)))))


(provide 'saut-de-lignes-intempestif)
;;; saut-de-lignes-intempestif.el ends here
