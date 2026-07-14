;;; 00-package-quickstart.el --- Precompute package autoloads
;; Loaded very early (preload/ runs before Prelude initializes
;; package.el), so this setting takes effect before packages are
;; scanned. Pure startup-time win: no behavior change, nothing to
;; think about. After adding this file, run once:
;;   M-x package-quickstart-refresh
;; and again any time you install/remove a package.

(setq package-quickstart t)

(provide '00-package-quickstart)
;;; 00-package-quickstart.el ends here
