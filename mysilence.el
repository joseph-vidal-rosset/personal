;; Vire tous les warnings de compilation native
;;; -*- lexical-binding: t -*-
(setq native-comp-async-report-warnings-errors nil)
(setq native-comp-warning-on-missing-source nil)

;; Vire les warnings de lexical-binding
(setq warning-suppress-types '((lexical-binding)))

;; Vire les warnings org-ref/missing functions
(setq warning-suppress-log-types '((comp) (bytecomp)))

;; Niveau de warning minimum
(setq warning-minimum-level :error)

;; Réduire l'agressivité de flyspell si activé par Prelude
(setq prelude-flyspell nil)

;; Garder la completion native d'Emacs
(setq completing-read-function 'completing-read-default)

(setq auto-dictionary-idle-time 30.0)  ; Beaucoup plus de délai
(setq adict-mode nil)  ; Désactiver le mode problématique
