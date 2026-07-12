;;; visual.el --- emacs utilities                    -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2020  Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph.vidal.rosset@gmail.com>
;; Keywords: convenience, help

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
;; (add-to-list 'default-frame-alist '(fullscreen . fullboth))


;(add-to-list 'initial-frame-alist '(fullscreen . maximized))






;; set a default font
(set-face-attribute 'default nil :height 150)
;;
;; (global-display-line-numbers-mode)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; justification
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook
          (lambda ()
            (auto-fill-mode 1)
            (setq default-justification 'full))
          )
;; écriture automatique des parenthèses, guillemets, etc.
(defun insert-parentheses () "insert parentheses and go between them" (interactive)
       (insert "()")
       (backward-char 1))
(defun insert-brackets () "insert brackets and go between them" (interactive)
       (insert "[]")
       (backward-char 1))
(defun insert-braces () "insert curly braces and go between them" (interactive)
       (insert "{}")
       (backward-char 1))
(defun insert-quotes () "insert quotes and go between them" (interactive)
       (insert "\"\"")
       (backward-char 1))
(global-set-key "(" 'insert-parentheses) ;;inserts "()"
(global-set-key "[" 'insert-brackets)
(global-set-key "{" 'insert-braces)
(global-set-key "\"" 'insert-quotes)

;;--------------------------
;; Vraiment quitter Emacs?
(setq kill-emacs-query-functions
      (cons (lambda () (yes-or-no-p "Bye bye? "))
            kill-emacs-query-functions))

;;--------------------------------------------------------------------
;; Montrerl la correspondance des parenthèses
(setq show-paren-style 'expression)
(show-paren-mode)
(global-set-key [M-right] 'forward-sexp)
(global-set-key [M-left] 'backward-sexp)
;;Pompée sur le .emacs de Mandrake (licence GPL)
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)
;;
;; pour l'accent circonflexe:
(load-library "iso-transl")
;;; Code:
;; Definit firefox comme brouteur web, pour suivre les liens
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
;; Date et Heure
 ;;;;;;
(display-time)
(setq display-time-24hr-format t)
;; Cloche système / Flach écran
 ;;;;;;
(setq visible-bell t)

(setq time-stamp-active t)
;; titre de la fenetre
(setq frame-title-format '(buffer-file-name "%b [%f]" "%b"))

;;---------------------------
;; Fonction count-char-buffer
;;---------------------------
(defun count-char-buffer ()
  "Compte le nombre de caractères contenus dans le tampon
et affiche le résultat dans le mini-tampon"
  (interactive)
  (save-excursion
    (let ((compteur 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
        (forward-char 1)
        (setq compteur (1+ compteur)))
      (message "Le tampon contient %d caractères." compteur))))
;;------------------------------
;; Fonction "count-words-buffer"
;;------------------------------
(defun count-words-buffer ()
  "Compte le nombre de mots du tampon courant
et affiche le résultat dans le mini-buffer"
  (interactive)
  (save-excursion
    (let ((compteur 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
        (forward-word 1)
        (setq compteur (1+ compteur)))
      (message "Le tampon contient %d mots." compteur))))
;;------------------------------
;; Fonction "count-lines-buffer"
;;------------------------------
(defun count-lines-buffer ()
  "Compte le nombre de lignes du tampon courant
et affiche le résultat dans le mini tampon."
  (interactive)
  (save-excursion
    (let ((compteur 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
        (next-line 1)
        (setq compteur (1+ compteur)))))) ;; Ce qui me permet ensuite de compter caractères, mots et lignes avec les commandes : M-x count-char-buffer, M-x count-words-buffer, M-x count-lines-buffer.

;; bookmarks in buffer
;;(require 'bm).
;;-------------------------
;; tool-bar and menu-bar on:
(tool-bar-mode 1)
(menu-bar-mode 1)
;; highlits permanently the current line
(global-hl-line-mode -1)
(set-face-background 'hl-line "dimgray")  ;; for tantango-theme



;; Or if you have use-package installed
;(use-package kaolin-themes
;  :config
;  (load-theme 'kaolin-valley-dark t)
;  (kaolin-treemacs-theme))

;(global-aggressive-indent-mode 1)
;(add-to-list 'aggressive-indent-excluded-modes 'html-mode)

;;;;;;;; THEMES
(add-to-list 'custom-theme-load-path "~/.emacs.d/personal/themes/")

;; (load-theme 'leuven t)
;; (load-theme 'material t)
(load-theme 'tangotango t)
;; (load-theme 'melancholy t)


                                       ;(load-theme 'doom-vibrant t)
;; (load-theme 'doom-Iosvkem t)
;; (load-theme 'leuven t)
;; (load-theme 'tangotango t)
;; (load-theme 'zenburn t)
;; (load-theme 'spacemacs-dark t)

;;(load-theme 'doom-gruvbox t)

;;(add-to-list 'custom-theme-load-path "~/GIT/emacs-leuven-theme/lisp")
;;(load-theme 'leuven-dark t)

;;(load-theme 'gruv-box-dark-medium t)
;;(load-theme 'gruv-box-dark-soft t)
;;(load-theme 'gruv-box-dark-hard t)

;;(load-theme 'gruv-box-light-medium t)
;;(load-theme 'gruv-box-light-soft t)
;;(load-theme 'gruv-box-light-hard t)

;(require 'neotree)
;(global-set-key [f8] 'neotree-toggle)
;(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

(setq org-highlight-latex-and-related '(latex))

;(require 'centaur-tabs)
;  (centaur-tabs-mode t)
;  ("C-<prior>" . centaur-tabs-backward)
;  ("C-<next>" . centaur-tabs-forward))

; (centaur-tabs-headline-match)
; (setq centaur-tabs-style "slant")
; (setq centaur-tabs-height 25)
; (setq centaur-tabs-set-icons t)
; (setq centaur-tabs-gray-out-icons 'buffer)
; (setq centaur-tabs-set-bar 'over)


(setq frame-title-format '(buffer-file-name "%b [%f]" "%b"))

;; (provide 'visual)

;; https://zzamboni.org/post/beautifying-org-mode-in-emacs/

; (setq org-hide-emphasis-markers t)

;(add-hook 'org-mode-hook 'visual-line-mode)

;(set-face-attribute 'default nil :height 180)


;(provide 'visual)



;;; visual.el ends here
