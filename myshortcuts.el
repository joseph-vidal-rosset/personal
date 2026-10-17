;;; myshortcuts.el --- key binding section             -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2020  Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph.vidal.rosset@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

(defun my-force-publish-current-file ()
  "Force la publication du fichier courant"
  (interactive)
  (let ((org-export-with-broken-links t))
    (org-publish-file (buffer-file-name)
                      (org-publish-get-project-from-filename (buffer-file-name)))))

(defun my-publish-blog ()
  "Publie tout le blog"
  (interactive)
  (org-publish "blog" t))

(defun my-git-push-ssh ()
  "Push the current branch of the Git repo at or above `default-directory'.

If the 'origin' remote is still set to an HTTPS GitHub URL
\(requiring a token, easy to expose by accident\), it is switched to
the equivalent SSH URL \(git@github.com:...\) first. Once your SSH key
is registered on GitHub, this means the push needs nothing typed —
no token, no password. Always pushes with '-u origin <branch>', so a
brand-new branch with no upstream yet still pushes cleanly instead of
failing with \"no upstream branch\". Output shows in a *git-push*
buffer."
  (interactive)
  (let* ((default-directory (or (vc-root-dir) default-directory))
         (url (string-trim (shell-command-to-string "git remote get-url origin")))
         (branch (string-trim (shell-command-to-string "git rev-parse --abbrev-ref HEAD"))))
    (if (string-prefix-p "https://github.com/" url)
        (let ((ssh-url (replace-regexp-in-string
                         "^https://github.com/" "git@github.com:" url)))
          (shell-command (format "git remote set-url origin %s" ssh-url))
          (message "origin switched to SSH: %s" ssh-url))
      (message "origin already non-HTTPS (%s), leaving as is" url))
    (async-shell-command
     (format "git push -u origin %s" (shell-quote-argument branch))
     "*git-push*")))

(defun my-publish-site-rsync ()
  "Synchronise ~/Dropbox/public_html vers le serveur (équivalent de `pubsync')."
  (interactive)
  (let ((default-directory (expand-file-name "~/Dropbox/public_html/")))
    (async-shell-command
     "rsync -avz --delete --exclude-from=$HOME/.rsync-exclude-blog ~/Dropbox/public_html/ joseph@vidal-rosset.net:/var/www/html/"
     "*pubsync*")))

(defun my-backup-to-disk ()
  "Sauvegarde complète du site sur le disque externe SAUVEGARDE.

Monte le disque s'il ne l'est pas déjà, puis enchaîne quatre étapes,
chacune n'ayant lieu que si la précédente réussit :

1. rapatriement de /var/backups/ de la Dedibox vers
   ~/Sauvegardes/vidal-rosset/ (équivalent de `getbackup') ;
2. élagage des archives hebdomadaires par ~/bin/purge-sauvegardes.sh :
   tout est gardé sur 120 jours, puis une archive par mois jusqu'à un
   an, rien au-delà. La fenêtre de 120 jours couvre celle que la
   Dedibox conserve elle-même, faute de quoi le premier rsync
   retéléchargerait chaque semaine ce que la purge vient d'effacer ;
3. recopie vers le disque externe, en miroir exact grâce à `--delete',
   ce qui répercute la purge sur le disque ;
4. affichage de la place restante, tant que le disque est monté.

Le disque est désigné par son étiquette de système de fichiers, non
par un nom de périphérique : le passage de sdc à sdd selon l'ordre
de branchement est donc sans effet. Le point de montage est celui
qu'annonce le système, et non une valeur codée en dur.

Sortie dans le tampon *sauvegarde*."
  (interactive)
  (let* ((lien "/dev/disk/by-label/SAUVEGARDE")
         (dev (and (file-exists-p lien) (file-truename lien)))
         (mp (lambda ()
               (let ((s (string-trim
                         (shell-command-to-string
                          (concat "lsblk -no MOUNTPOINT "
                                  (shell-quote-argument (or dev "/dev/null"))
                                  " 2>/dev/null")))))
                 (and (not (string-empty-p s)) s)))))
    (cond
     ((null dev)
      (message "Disque SAUVEGARDE introuvable — est-il branché ?"))
     (t
      (unless (funcall mp)
        (message "Montage du disque…")
        (shell-command-to-string
         (concat "udisksctl mount -b " (shell-quote-argument dev))))
      (let ((point (funcall mp)))
        (if (null point)
            (message "Échec du montage de %s — sauvegarde annulée." dev)
          (async-shell-command
           (concat "rsync -avh joseph@vidal-rosset.net:/var/backups/ "
                   "~/Sauvegardes/vidal-rosset/ && "
                   "$HOME/bin/purge-sauvegardes.sh && "
                   "rsync -avh --delete ~/Sauvegardes/vidal-rosset/ "
                   (shell-quote-argument (concat point "/vidal-rosset/"))
                   " && df -h " (shell-quote-argument point) " | tail -1"
                   " && echo '=== Sauvegarde terminée avec succès ==='")
           "*sauvegarde*")))))))

(defun my-eject-backup-disk ()
  "Démonte et éteint le disque externe SAUVEGARDE avant débranchement.

Démonte la partition, puis coupe l'alimentation du disque entier —
ce qui garantit que les tampons d'écriture sont vidés. Le disque est
désigné par son étiquette, le disque parent étant déduit
automatiquement : aucun nom de périphérique n'est codé en dur.

Le résultat s'affiche dans le minibuffer ; quand la LED du boîtier
s'éteint, la fiche peut être retirée."
  (interactive)
  (let* ((lien "/dev/disk/by-label/SAUVEGARDE")
         (dev (and (file-exists-p lien) (file-truename lien))))
    (if (null dev)
        (message "Disque SAUVEGARDE introuvable — déjà débranché ?")
      (let* ((parent (string-trim
                      (shell-command-to-string
                       (concat "lsblk -no PKNAME "
                               (shell-quote-argument dev) " | head -1"))))
             (disque (if (string-empty-p parent) dev (concat "/dev/" parent)))
             (sortie (concat
                      (shell-command-to-string
                       (concat "udisksctl unmount -b "
                               (shell-quote-argument dev) " 2>&1"))
                      (shell-command-to-string
                       (concat "udisksctl power-off -b "
                               (shell-quote-argument disque) " 2>&1")))))
        (message "%s" (string-trim sortie))))))

;;; Code:

(global-set-key [f1] 'package-list-packages)
(global-set-key [f2]
                (lambda ()
                  (interactive)
                  (unless (featurep 'wl)
                    (load (expand-file-name "~/.emacs.d/personal/.wl.el")))
                  (wl)))
(global-set-key [f3] 'org-latex-preview)
(global-set-key [f4] 'org-mime-htmlize)
(global-set-key [f5] 'kill-current-buffer)
(global-set-key [f6] 'my-backup-to-disk)
(global-set-key [S-f6] 'my-eject-backup-disk)
(global-set-key [f7] 'org-mime-edit-mail-in-org-mode)
(global-set-key [f8] 'my-publish-site-rsync)
(global-set-key [f9] 'org-capture)
(global-set-key [f10] 'org-schedule)

(when (boundp 'exwm-input-prefix-keys)
  (add-to-list 'exwm-input-prefix-keys 'f11))

(global-unset-key [f11])
(define-prefix-command 'my-f11-map)
(global-set-key [f11] 'my-f11-map)
(define-key my-f11-map "a" 'org-archive-subtree)
(define-key my-f11-map "d" 'org-deadline)
(define-key my-f11-map "e" 'export-with-class)
(define-key my-f11-map "c" 'check-article-tags)
(define-key my-f11-map "n" 'new-org-file)
(define-key my-f11-map "g" 'my-git-push-ssh)
(define-key my-f11-map "r" #'jvr/rygel-restart)
(define-key my-f11-map "s" #'jvr/rygel-stop)
;; Aide-mémoire Wanderlust, déplacé de F6 vers F11 w
(define-key my-f11-map "w"
            (lambda () (interactive)
              (find-file "~/.emacs.d/personal/wanderlust-aide-memoire.md")))
;; Raccourci clavier F12
(global-set-key [f12] 'complete-site-rebuild-and-publish)

;; Optionnel : Shift+F12 pour la version verbeuse
(global-set-key [S-f12] 'complete-site-rebuild-and-publish-verbose)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c h") 'athena-run)

;; C-c C-s  org-schedule
;; C-c C-d  org-deadline
;; C-c C-w  org-refile at a point
;; C-c C-t  org : done

;; snippets
;; snippets — yas-global-mode itself is now activated in a deferred
;; block from prelude-modules.el (~0.3s after startup, alongside
;; AUCTeX), so it doesn't block Emacs' startup time. Only the
;; directory variable needs setting here, synchronously, before that
;; deferred activation fires.
(setq yas-snippet-dirs '("~/.emacs.d/snippets/"))

(global-set-key (kbd "C-c m") (lambda () (interactive) (insert "@@latex:}%@@")))


(global-set-key (kbd "C-c w m")
                (lambda ()
                  (interactive)
                  (find-file "~/Dropbox/org/wanderlust_memo.org")))

(defun my-split-shell ()
  "Divise l'écran verticalement et ouvre un shell dans la nouvelle fenêtre."
  (interactive)
  (select-window (split-window-right))
  (shell))


(provide 'myshortcuts)
;;; myshortcuts.el ends here
