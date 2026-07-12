;;; mylatex.el --- LaTeX configuration for Emacs -*- lexical-binding: t; -*-

;; Copyright (C) 2020-2025  Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph.vidal.rosset@gmail.com>
;; Keywords: latex, bibtex, auctex, reftex

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
;; Configuration complète pour AUCTeX, RefTeX et Biber
;; Utilise Evince pour les PDF et Firefox pour les HTML

;;; Code:

;;; ============================================================================
;;; AUCTeX Configuration
;;; ============================================================================

(setq TeX-auto-save t)                   ; Analyse automatique des fichiers
(setq TeX-parse-self t)                  ; Parse automatique du document
(setq TeX-PDF-mode t)                    ; Toujours compiler en PDF
(setq TeX-source-correlate-mode t)       ; Synctex activé
(setq TeX-source-correlate-start-server t)

;;; ============================================================================
;;; Visualiseurs externes
;;; ============================================================================

;; Evince pour les PDF (avec support synctex)
(setq TeX-view-program-list
      '(("Evince" "evince --page-index=%(outpage) %o")
        ("Firefox" "firefox %o")))

(setq TeX-view-program-selection
      '((output-pdf "Evince")
        (output-dvi "Evince")
        (output-html "Firefox")))

;; Firefox comme navigateur par défaut
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

;;; ============================================================================
;;; LaTeX Mode Hooks
;;; ============================================================================

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)

;;; ============================================================================
;;; RefTeX Configuration
;;; ============================================================================

(require 'reftex)

;; Activation pour LaTeX et latex modes
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'latex-mode-hook 'turn-on-reftex)

;; Options RefTeX
(setq reftex-plug-into-AUCTeX t)
(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq-default TeX-master t)

;;; ============================================================================
;;; Biber Configuration (pour bibliographies)
;;; ============================================================================

(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
                '("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber") t))

(defun TeX-run-Biber (name command file)
  "Create a process for NAME using COMMAND to format FILE with Biber."
  (let ((process (TeX-run-command name command file)))
    (setq TeX-sentinel-function 'TeX-Biber-sentinel)
    (if TeX-process-asynchronous
        process
      (TeX-synchronous-sentinel name file process))))

(defun TeX-Biber-sentinel (process name)
  "Cleanup TeX output buffer after running Biber."
  (goto-char (point-max))
  (cond
   ((re-search-backward (concat
                         "^(There \\(?:was\\|were\\) \\([0-9]+\\) "
                         "\\(warnings?\\|error messages?\\))") nil t)
    (message (concat "Biber finished with %s %s. "
                     "Type `%s' to display output.")
             (match-string 1) (match-string 2)
             (substitute-command-keys
              "\\\\[TeX-recenter-output-buffer]")))
   (t
    (message (concat "Biber finished successfully. "
                     "Run LaTeX again to get citations right."))))
  (setq TeX-command-next TeX-command-default))

;;; ============================================================================
;;; CDLaTeX (pour org-mode)
;;; ============================================================================

(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

;;; ============================================================================
;;; Compteur de mots LaTeX
;;; ============================================================================

(defun latex-word-count ()
  "Count words in current LaTeX document using texcount."
  (interactive)
  (let* ((this-file (buffer-file-name))
         (word-count
          (with-output-to-string
            (with-current-buffer standard-output
              (call-process "texcount" nil t nil "-brief" this-file)))))
    (string-match "\n$" word-count)
    (message (replace-match "" nil nil word-count))))

(defun my-latex-setup ()
  "Setup LaTeX mode keybindings."
  (define-key LaTeX-mode-map "\C-cw" 'latex-word-count))

(add-hook 'LaTeX-mode-hook 'my-latex-setup t)

;;; ============================================================================

(provide 'mylatex)
;;; mylatex.el ends here
