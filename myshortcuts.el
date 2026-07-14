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
(global-set-key [f6]
                (lambda () (interactive)
                  (find-file "~/Dropbox/emacs_conf/personal/wanderlust-aide-memoire.md")))
(global-set-key [f7] 'org-mime-edit-mail-in-org-mode)
(global-set-key [f8] 'ediprolog-dwim)
(global-set-key [f9] 'org-capture)
(global-set-key [f10] 'org-schedule)
(global-unset-key [f11])
(define-prefix-command 'my-f11-map)
(global-set-key [f11] 'my-f11-map)
(define-key my-f11-map "a" 'org-archive-subtree)
(define-key my-f11-map "d" 'org-deadline)
(define-key my-f11-map "e" 'export-with-class)
(define-key my-f11-map "c" 'check-tag)
(define-key my-f11-map "n" 'new-org-file)
(define-key my-f11-map "g" 'my-git-push-ssh)
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
