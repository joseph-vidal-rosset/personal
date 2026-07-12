;;; bbdb_silent.el --- pour que bbdb  me foute la paix au démarrage de emacs  -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2025

;; Author:  <joseph@vidal-rosset.net>
;; Keywords: convenience,
;;; bbdb-config.el --- Configuration BBDB préchargée

;; Désactiver toutes les vérifications BBDB au démarrage
(setq bbdb-check-postcode nil)
(setq bbdb-auto-revert nil)
(setq bbdb-notice-mail-hook nil)
(setq bbdb-canonicalize-mail-function nil)
(setq bbdb-allow-duplicates t)
(setq bbdb-silent t)
(setq bbdb-message-all-addresses nil)

;;; bbdb-config.el ends here
