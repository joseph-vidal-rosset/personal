;;; ath-setup.el ---                                 -*- lexical-binding: t; -*-

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

;;; Configuration pour Athena avec execute-in-shell.el

;; 1. Indiquez à Emacs où se trouve Athena (à adapter si besoin)
(setenv "ATHENA_HOME" (expand-file-name "~/athena"))
;; On ajoute le dossier contenant le binaire au PATH d'Emacs
(add-to-list 'exec-path (expand-file-name "~/athena"))

;; 2. Chargez le script execute-in-shell
;; Cela définit la fonction 'execute-in-shell' et la lie à C-/
(load-file (expand-file-name "~/.emacs.d/personal/execute-in-shell.el"))

;; 3. Créez une commande pratique pour lancer Athena
(defun my-start-athena ()
  "Lance Athena dans un buffer shell, ou passe au buffer s'il existe."
  (interactive)
  (let ((shell-buf (get-buffer "*shell*")))
    (if shell-buf
        (switch-to-buffer-other-window shell-buf)
      (progn
        (shell) ;; Crée un nouveau shell
        (sleep-for 1) ;; Court délai pour laisser le shell s'initialiser
        (insert "athena")
        (comint-send-input)))))

(global-set-key (kbd "C-c a") 'my-start-athena) ;; Liez la commande à C-c a

;; 4. (Optionnel) Activez automatiquement le mode pour les fichiers .ath
(add-to-list 'auto-mode-alist '("\\.ath\\'" . lisp-mode))


(add-hook 'athena-mode-hook (lambda () (font-lock-mode 1)))

(provide 'ath-setup)
;;; ath-setup.el ends here
