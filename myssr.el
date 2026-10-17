;;; myssr.el ---

(defvar my/ssr-process nil
  "Processus SimpleScreenRecorder en cours, s'il y en a un.")

(defun my/ssr-toggle ()
  "Démarre un enregistrement d'écran, ou sauvegarde celui en cours."
  (interactive)
  (if (process-live-p my/ssr-process)
      (progn
        (process-send-string my/ssr-process "record-save\nquit\n")
        (message "Enregistrement sauvegardé."))
    (let ((process-connection-type nil))   ; tube plutôt que pty
      (setq my/ssr-process
            (start-process "ssr" "*ssr*" "simplescreenrecorder"
                           "--start-hidden" "--start-recording")))
    (message "Enregistrement démarré.")))

(exwm-input-set-key (kbd "s-<f9>") #'my/ssr-toggle)
