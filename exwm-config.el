;; -*- lexical-binding: t; -*-
;; EXWM configuration for Joseph
;; Loads only when EXWM session is selected in LightDM
;; L'autostart XDG (Bridge, etc.) est lancé par /usr/local/bin/exwm-session.
;; Les applications à icône de tray (Clipman, Dropbox) sont lancées ICI,
;; quand le tray du panel est réellement prêt — jamais par l'autostart
;; (garde DESKTOP_SESSION dans leurs fichiers .desktop).

(when (string= (or (getenv "DESKTOP_SESSION") "") "exwm")

  (require 'exwm)

  ;; ── Serveur Emacs (emacsclient, garde du démon autostart) ──
  (server-start)

  ;; ── Trousseau de clés : variables + synchronisation du bus D-Bus ──
  (let ((output (shell-command-to-string
                 "gnome-keyring-daemon --start --components=secrets,ssh,pkcs11")))
    (dolist (line (split-string output "\n" t))
      (when (string-match "\\([^=]+\\)=\\(.*\\)" line)
        (setenv (match-string 1 line) (match-string 2 line))))
    (call-process "dbus-update-activation-environment" nil nil nil
                  "--systemd" "--all"))

  ;; ── Services propres à la session EXWM ──
  (start-process "xfsettingsd" nil "xfsettingsd")
  (start-process "xfce4-terminal" nil "xfce4-terminal" "--drop-down")

  ;; ── Panel, puis applets quand le tray est réellement prêt ──
  ;; Principe : tout délai fixe est une course déguisée. On ne lance pas
  ;; les applets « N secondes après le panel », mais « quand le tray
  ;; existe » (sélection X _NET_SYSTEM_TRAY_S0), sondé chaque seconde.
  (defun joseph/lancer-applets-tray (&optional essais)
    "Lance les applets à tray dès que celui-ci existe (poll 1 s, max 30)."
    (let ((essais (or essais 0)))
      (cond
       ((x-selection-exists-p '_NET_SYSTEM_TRAY_S0)
        (start-process "clipman" nil "xfce4-clipman")
        ;; Dropbox vient de l'autostart (réglages par défaut intacts) ;
        ;; on relance seulement son icône une fois le tray prêt.
        (start-process "dropbox-icon" nil "bash" "-c"
                       "dropbox stop && sleep 2 && dropbox start -i")
        (message "Tray prêt après %d s — applets lancées" essais))
       ((< essais 30)
        (run-at-time "1 sec" nil #'joseph/lancer-applets-tray (1+ essais)))
       (t
        (message "Tray absent après 30 s — applets non lancées")))))

  (run-at-time "3 sec" nil
               (lambda ()
                 (start-process "xfce4-panel" nil "xfce4-panel")
                 (joseph/lancer-applets-tray)))

  ;; ── Deux workspaces ──
  (setq exwm-workspace-number 2)

  ;; ── Nommer les buffers X ──
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (when (string= exwm-class-name "firefox")
                (exwm-workspace-rename-buffer
                 (concat "Firefox: " exwm-title)))))

  ;; ── Raccourcis globaux (Super) ──
  (setq exwm-input-global-keys
        `(([?\s-f] . (lambda () (interactive)
                       (start-process "firefox" nil "firefox")))
          ([?\s-t] . (lambda () (interactive)
                       (start-process "xterm" nil "xterm")))
          ([?\s-e] . (lambda () (interactive)
                       (start-process "thunar" nil "thunar")))
          ([?\s-d] . (lambda () (interactive)
                       (shell-command "dmenu_run &")))
          ([?\s-s] . my-split-shell)
          ([?\s-r] . exwm-reset)
          ([?\s-q] . delete-window)
          ([?\s-k] . kill-buffer)
          ([?\s-b] . switch-to-buffer)
          ([?\s-h] . split-window-right)
          ([?\s-v] . split-window-below)
          ([?\s-o] . other-window)
          ([?\s-m] . exwm-layout-toggle-fullscreen)
          ([?\s-1] . delete-other-windows)
          ([?\s-g] . exwm-floating-toggle-floating)
          ([?\s-c] . exwm-input-toggle-keyboard)
          ([?\s-l] . (lambda () (interactive)
                       (start-process "lock" nil "xfce4-screensaver-command" "--lock")))))

  ;; ── Simulation keys (raccourcis Emacs dans Firefox etc.) ──
  (setq exwm-input-simulation-keys
        '(([?\C-b] . [left])
          ([?\C-f] . [right])
          ([?\C-p] . [up])
          ([?\C-n] . [down])
          ([?\C-a] . [home])
          ([?\C-e] . [end])
          ([?\M-v] . [prior])
          ([?\C-d] . [delete])
          ([?\C-k] . [S-end delete])
          ([?\M-w] . [?\C-c])
          ([?\C-y] . [?\C-v])
          ([?\C-w] . [?\C-x])
          ([?\C-s] . [?\C-f])
          ([?\C-/] . [?\C-z])
          ([?\C-x ?k] . [?\C-w])
          ([?\C-x ?b] . [?\C-t])
          ([?\C-x ?h] . [?\C-a])
          ([?\C-x ?\C-s] . [?\C-s])
          ([?\M-f] . [C-right])
          ([?\M-b] . [C-left])
          ))

  ;; ── Modeline ──
  (display-time-mode 1)
  (display-battery-mode 1)

  ;; ── Écran d'accueil : Firefox à +2 s, nettoyage à +5 s ──
  (add-hook 'exwm-init-hook
            (lambda ()
              (run-at-time "2 sec" nil
                           (lambda ()
                             (start-process "firefox" nil "firefox")))
              (run-at-time "5 sec" nil #'delete-other-windows)))

  ;; ── Activer EXWM ──
  (exwm-wm-mode 1)

  (message "EXWM chargé avec succès !"))
