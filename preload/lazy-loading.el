;;; lazy-loading.el --- Lazy loading configuration -*- lexical-binding: t; -*-

;; Augmenter drastiquement le GC threshold pendant le démarrage
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Désactiver anaconda-mode complètement
(setq python-shell-completion-native-enable nil)

;; Restaurer le GC après le démarrage
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024)
                  gc-cons-percentage 0.1)
            (garbage-collect)))

;; En mode daemon, restaurer aussi après 5 secondes d'idle
(when (daemonp)
  (run-with-idle-timer
   5 nil
   (lambda ()
     (setq gc-cons-threshold (* 20 1024 1024)
           gc-cons-percentage 0.1)
     (garbage-collect))))

(provide 'lazy-loading)
;;; lazy-loading.el ends here
