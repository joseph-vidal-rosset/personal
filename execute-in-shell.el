;;; execute-in-shell.el ---                          -*- lexical-binding: t; -*-

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

; These Emacs customizations define a keyboard macro and key bindings
; for executing S-expressions (such as Athena or Scheme expressions)
; in a shell buffer.  To use these, have exactly two windows open in
; Emacs, one on a buffer containing S-expressions and the other on a
; shell buffer in which you are running a program that can accept and
; execute S-expressions.  Place the cursor anywhere in the
; S-expression you want to execute and type Control-/ to send it to
; the program in the shell window.  It will be executed there, after
; which the cursor is returned to the S-expression window and
; positioned at the next S-expression that begins (has its
; left-parenthesis) in column one.

;; Guarded against being loaded twice: ath-setup.el loads this file
;; explicitly via load-file, and Prelude's own personal/ directory
;; loop loads every *.el file it finds regardless, including this
;; one. `provide' alone doesn't stop that second `load' — only an
;; explicit `featurep' check inside the file's own body does.
(unless (featurep 'execute-in-shell)

  (fset 'execute-in-shell
     [?\C-f ?\C-r ?\C-q ?\C-j ?\( ?\C-f ?\C-  escape ?\C-f escape ?w
     ?\C-x ?b ?* ?s ?h ?e ?l ?l ?* return escape ?> ?\C-y return ?\C-x
     ?b return ?\C-s ?\C-q ?\C-j ?\( ?\C-a])

  ; Type Ctl-/ to run it.  This may not work in all terminal programs
  ; when running Emacs at terminal level (emacs -nw); some terminal
  ; programs seem not to transmit the proper character code.
  (global-set-key [?\C-/] 'execute-in-shell)

  ; Alternatively, type Ctl-x a to run it; this works in either
  ; full-windows Emacs (such as via X-Windows) or terminal-level Emacs).
  (global-set-key "\C-xa" 'execute-in-shell)

  (provide 'execute-in-shell))
;;; execute-in-shell.el ends here
