;;; 00-reduce-noise.el ---                           -*- lexical-binding: t; -*-

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

;;; 00-reduce-noise.el --- Reduce startup noise -*- lexical-binding: t -*-

;;; Commentary:
;; Réduit UNIQUEMENT le bruit des warnings, sans rien casser

;;; Code:

;; Supprime les warnings "lexical-binding" et "files" uniquement
(setq warning-suppress-log-types '((lexical-binding) (files)))
(setq warning-suppress-types '((lexical-binding) (files)))

;; Supprime les warnings de compilation obsolètes (when-let, if-let, etc.)
(setq byte-compile-warnings '(not obsolete cl-functions))

(provide '00-reduce-noise)
;;; 00-reduce-noise.el ends here

(provide '00-reduce-noise)
;;; 00-reduce-noise.el ends here
