;.......................................................................
; Athena proof assistant support:

; Athena mode
;; Chargement explicite du mode (car autoload ne fonctionne pas)

(setenv "ATHENA_HOME" (expand-file-name "~/athena"))
(require 'athena-mode)   ; <- utilise le feature que nous venons d'ajouter

;; Athena mode (associations)
(setq auto-mode-alist (cons '("\\.ath$" . athena-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("athena" . athena-mode) interpreter-mode-alist))

; The following addition to compilation-error-regexp-alist recognizes
; message lines with the file name and line and position numbers in
; the standard format but with the additional flexibility that they
; can begin with any number of blanks or tabs (since some Athena error
; messages are indented) or dashes (for recognizing conclude trace
; messages).

(save-excursion
  (compile "")
  (setq compilation-error-regexp-alist
      (cons '("^[- \t]*\\([a-zA-Z][-a-zA-Z._0-9]+: ?\\)?\\([a-zA-Z]?:?[^:( 	\n]*[^:( 	\n0-9][^:( 	\n]*\\)[:(][ 	]*\\([0-9]+\\)\\([) 	]\\|:\\(\\([0-9]+:\\)\\|[0-9]*[^:0-9]\\)\\)" 2 3 6)
        compilation-error-regexp-alist)))

; The following function and key binding, together with a shell script
; also named athena-run, are to facilitate testing of Athena files in
; compilation mode, in order to get the benefit of compilation mode's
; handling of error messages.  In the *shell* buffer, the current
; directory should be the directory relative to which Athena files are
; loaded, "proofs", say, and "proofs/test.ath" should contain a
; load-file command to load the file to be tested.

(defun athena-run ()
  "Lance Athena sur le fichier courant dans un buffer *compilation*."
  (interactive)
  (let ((file (buffer-file-name)))
    (if (and file (string-match "\\.ath\\'" file))
        (compile (format "%s/athena %s" (getenv "ATHENA_HOME") file))
      (user-error "Buffer courant n'est pas un fichier .ath"))))
