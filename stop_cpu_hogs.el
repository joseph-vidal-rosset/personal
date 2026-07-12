;;; stop_cpu_hogs.el ---                             -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2025

;; Author:  <joseph@vidal-rosset.net>
;; Keywords: c,
;; Désactiver flycheck globalement
(global-flycheck-mode -1)

;; Désactiver flyspell globalement
(setq prelude-flyspell nil)

;; Ou les activer seulement à la demande
(defun jvr/enable-flycheck ()
  "Active flycheck pour ce buffer seulement"
  (interactive)
  (flycheck-mode 1))

(defun jvr/enable-flyspell ()
  "Active flyspell pour ce buffer seulement"
  (interactive)
  (flyspell-mode 1))

;; Raccourcis pour activer à la demande
(global-set-key (kbd "C-c f c") 'jvr/enable-flycheck)
(global-set-key (kbd "C-c f s") 'jvr/enable-flyspell)
