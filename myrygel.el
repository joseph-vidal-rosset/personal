;;; myrygel.el ---                                   -*- lexical-binding: t; -*-

;; Copyright (C) 2026  

;; Author:  <joseph@vidal-rosset.net>
;; Keywords: convenience, convenience, 

;;; myrygel.el --- Serveur DLNA Rygel sous EXWM  -*- lexical-binding: t; -*-

(defun jvr/rygel-restart ()
  "Relance Rygel, en tuant l'instance précédente s'il y en a une."
  (interactive)
  (when-let ((proc (get-process "rygel")))
    (delete-process proc))
  (let ((proc (start-process "rygel" "*rygel*" "rygel")))
    (set-process-query-on-exit-flag proc nil))
  (message "Rygel relancé"))

(defun jvr/rygel-stop ()
  "Arrête Rygel."
  (interactive)
  (when-let ((proc (get-process "rygel")))
    (delete-process proc))
  (message "Rygel arrêté"))

(provide 'myrygel)
;;; myrygel.el ends here
