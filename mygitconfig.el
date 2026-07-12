;;; mygitconfig.el --- Github configuration          -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2025

;; Author:  <joseph@vidal-rosset.net>
;; Keywords: convenience

;; ============================================
;; Configuration Git/Magit pour Joseph Vidal-Rosset
;; Prelude Emacs
;; ============================================

;; Installer Magit si pas déjà présent
(prelude-require-packages '(magit forge))

;; Raccourcis Magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c g") 'magit-file-dispatch)

;; Configuration Git - SIMPLIFIÉ : tout dans Dropbox
(setq magit-repository-directories '(("~/Dropbox/public_html" . 2)))

;; Affichage amélioré
(setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)

;; Forge pour intégration GitHub complète
(with-eval-after-load 'magit
  (require 'forge))

(provide 'mygitconfig)
;;; mygitconfig.el ends here
