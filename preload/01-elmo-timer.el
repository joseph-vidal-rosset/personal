;;; 01-elmo-timer.el --- pour supprimer une erreur au chargement de Wanderlust  -*- lexical-binding: t; -*-

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

;;; 01-fix-elmo-timer.el --- Fix Elmo cache timer error -*- lexical-binding: t; -*-

;;; Commentary:
;; Ce fichier désactive le timer elmo-cache-expire qui cause des erreurs
;; Il doit être chargé AVANT wl.el dans le répertoire preload/

;;; Code:

;; Désactiver complètement le système de cache expire d'Elmo
(with-eval-after-load 'elmo
  (when (boundp 'elmo-cache-expire-timer)
    (when (timerp elmo-cache-expire-timer)
      (cancel-timer elmo-cache-expire-timer))
    (setq elmo-cache-expire-timer nil))

  ;; Empêcher la recréation du timer
  (when (fboundp 'elmo-cache-expire-setup)
    (defun elmo-cache-expire-setup ()
      "Dummy function to prevent timer creation"
      nil)))

;; Alternative : redéfinir elmo-cache-expire comme une fonction vide
;; si elle n'existe pas encore
(unless (fboundp 'elmo-cache-expire)
  (defun elmo-cache-expire ()
    "Dummy function to prevent void-function error"
    (message "elmo-cache-expire disabled")))

(provide '01-elmo-timer)
;;; 01-elmo-timer.el ends here
