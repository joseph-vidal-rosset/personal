;;; memory-daemon.el ---                             -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2025

;; Author:  <joseph@vidal-rosset.net>
;; Keywords: convenience,


;; ======================================================================
;; GESTION MÉMOIRE POUR DAEMON
;; ======================================================================

;; Garbage collection plus agressive quand idle
(run-with-idle-timer 300 t #'garbage-collect)

;; Libérer la mémoire de Wanderlust quand on quitte
(add-hook 'wl-exit-hook 'garbage-collect)

;; Limite de cache pour ELMO (en Mo)
(setq elmo-cache-expire-days 30)  ; Expire le cache après 30 jours
(setq elmo-msgdb-directory "~/.elmo")

;; Nettoyer le cache périodiquement (tous les jours)
(run-at-time "03:00" 86400  ; 3h du matin, tous les jours
             (lambda ()
               (elmo-cache-expire)
               (garbage-collect)))


;; Afficher l'utilisation mémoire
(defun my-emacs-memory-report ()
  "Affiche l'utilisation mémoire d'Emacs"
  (interactive)
  (message "Emacs utilise %.1f Mo"
           (/ (float (memory-use-counts)) 1048576.0)))

(global-set-key (kbd "C-c M") 'my-emacs-memory-report)
