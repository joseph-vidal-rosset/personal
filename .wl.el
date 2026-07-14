;;; wl.el --- Wanderlust configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration complète pour Wanderlust avec BBDB et org-mime

;;; Code:

;; ======================================================================
;; AUTH-SOURCE CONFIGURATION (DOIT ÊTRE EN PREMIER!)
;; ======================================================================
;; Charger auth-source avant tout
(require 'auth-source)

;; Définir explicitement où chercher les credentials
(setq auth-sources '("~/.emacs.d/personal/.authinfo.gpg"))

;; Activer le cache auth-source
(setq auth-source-cache-expiry nil)  ; Cache infini pour ne pas redemander
(setq auth-source-do-cache t)

;; IMPORTANT : Dire à Elmo d'utiliser auth-source
(setq elmo-passwd-storage-type 'auth-source)

;; CRITICAL : Forcer SMTP à utiliser auth-source aussi
(setq wl-smtp-authenticate-type "plain")
(setq wl-smtp-connection-type 'starttls)

;; Force auth-source pour SMTP (bug fix pour certaines versions de WL)
(setq smtp-auth-credentials 'auth-source)  ; Pour smtp.el
(setq smtpmail-auth-credentials 'auth-source)  ; Pour smtpmail.el

;; ======================================================================
;; CONFIGURATION SMTP ALTERNATIVE : utiliser smtpmail au lieu de smtp.el
;; ======================================================================
;; Wanderlust peut utiliser soit smtp.el soit smtpmail.el
;; smtpmail.el a un meilleur support d'auth-source
(setq wl-smtp-posting-function 'wl-smtp-posting-via-smtpmail)

;; Configuration smtpmail avec auth-source
(with-eval-after-load 'smtpmail
  (setq smtpmail-auth-supported '(plain login)
        smtpmail-starttls-credentials '(("smtp.univ-lorraine.fr" 587 nil nil))
        smtpmail-smtp-service 587))

;; Debug auth-source (décommenter pour voir ce qui se passe)
;; (setq auth-source-debug t)

;; ======================================================================
;; SUPPRESSION DES MESSAGES D'ERREUR POUR MODULES OPTIONNELS
;; ======================================================================
;; Wanderlust cherche gnus-mime et emh-setup mais on n'en a pas besoin
(setq mime-setup-enable-inline-html nil)  ; Pas besoin de Gnus pour le HTML
(with-eval-after-load 'mime-setup
  (remove-hook 'mime-setup-hook 'gnus-mime-setup)
  (remove-hook 'mime-setup-hook 'emh-setup))

;; ======================================================================
;; CHARGEMENT EXPLICITE DES MODULES ELMO
;; ======================================================================
(require 'wl)
(require 'elmo)

(setq wl-insert-message-id nil)
(setq elmo-imap4-use-modified-utf7 t)

;; Configuration de la signature globale
(setq wl-signature-file "~/.signature")
(setq signature-file-name "~/.signature")

;; ======================================================================
;; CONFIGURATION SMTP (ERREURS CORRIGÉES!)
;; ======================================================================
(setq wl-template-alist
  '(
    ("proton"
     (wl-from . "Joseph Vidal-Rosset <joseph@vidal-rosset.net>")
     ("From" . wl-from)
     (wl-smtp-connection-type . 'starttls)
     (wl-smtp-posting-port .  10035)
     (wl-smtp-authenticate-type .  "plain")
     (wl-smtp-posting-user . "joseph@vidal-rosset.net")  ;; CORRIGÉ : pas d'espace!
     (wl-smtp-posting-server . "127.0.0.1")
     (wl-local-domain . "vidal-rosset.net")  ;; CORRIGÉ : pas d'espace!
     )
    ("univ"
     (wl-from . "Joseph Vidal-Rosset <joseph.vidal-rosset@univ-lorraine.fr>")
     ("From" . wl-from)
     (wl-smtp-connection-type . 'starttls)
     (wl-smtp-posting-port . 587)
     (wl-smtp-authenticate-type . "plain")
     (wl-smtp-posting-user . "vidalros5@univ-lorraine.fr")  ;; LOGIN UL, pas l'email!
     (wl-smtp-posting-server . "smtp.univ-lorraine.fr")
     (wl-local-domain . "univ-lorraine.fr")
     )
    ))

(setq wl-draft-config-matchone t)
(setq wl-draft-config-alist
      '(
        ((string-match ".*univ-lorraine" wl-draft-parent-folder)
         (template . "univ")
         )
        ((string-match ".*proton\\|.*vidal-rosset" wl-draft-parent-folder)
         (template . "proton")
         )
        ))

(add-hook 'wl-mail-setup-hook 'wl-draft-config-exec)

;; Insérer automatiquement la signature
(add-hook 'wl-mail-setup-hook 'wl-draft-insert-signature)

;; Configurations générales
(setq wl-forward-subject-prefix "Fwd: ")
(setq wl-user-mail-address-list '("joseph@vidal-rosset.net" "joseph.vidal-rosset@univ-lorraine.fr"))
(setq wl-draft-use-frame nil)
(setq wl-message-window-size '(3 . 7))

;; Champs visibles par défaut dans les drafts
(setq wl-draft-fields '("To:" "Cc:" "Subject:"))
(setq wl-draft-always-delete-myself t)

;; ======================================================================
;; SIMPLIFICATION DES EN-TÊTES AFFICHÉS
;; ======================================================================

;; Masquer presque tous les en-têtes techniques
(setq wl-message-ignored-field-list
      '(".*:"))  ; Masque TOUT par défaut

;; N'afficher QUE ces champs essentiels
(setq wl-message-visible-field-list
      '("^From:"
        "^To:"
        "^Cc:"
        "^Date:"
        "^Subject:"))

;; Ordre d'affichage des en-têtes
(setq wl-message-header-field-order
      '("From" "To" "Cc" "Date" "Subject"))

;; Auto-fill
(add-hook 'wl-mail-setup-hook 'auto-fill-mode)
;; ======================================================================
;; AFFICHAGE DU CLIENT EMAIL DU DESTINATAIRE (comme dans Gnus)
;; ======================================================================

(defun wl-summary-display-user-agent ()
  "Affiche le client email utilisé par l'expéditeur du message"
  (interactive)
  (let* ((msg-id (wl-summary-message-number))
         (entity (when msg-id (elmo-message-entity wl-summary-buffer-elmo-folder msg-id)))
         (user-agent (when entity
                       (or (elmo-message-entity-field entity 'user-agent)
                           (elmo-message-entity-field entity 'x-mailer)
                           (elmo-message-entity-field entity 'x-newsreader))))
         (mime-version (when entity
                        (elmo-message-entity-field entity 'mime-version))))
    (if user-agent
        (message "Client: %s" user-agent)
      (message "Client email inconnu (MIME: %s)" (or mime-version "N/A")))))

;; Ajouter aux en-têtes visibles
(setq wl-message-visible-field-list
      '("^From:"
        "^To:"
        "^Cc:"
        "^Date:"
        "^Subject:"
        "^User-Agent:"     ; Ajout
        "^X-Mailer:"       ; Ajout
        "^X-Newsreader:")) ; Ajout

;; Raccourci dans le summary pour voir le client
(with-eval-after-load 'wl-summary
  (define-key wl-summary-mode-map (kbd "C-c u") 'wl-summary-display-user-agent))

;; Optionnel : afficher automatiquement dans le modeline
(defun wl-summary-redisplay-hook-user-agent ()
  "Affiche le client dans le modeline lors de la lecture d'un message"
  (let* ((msg-id (wl-summary-message-number))
         (entity (when msg-id (elmo-message-entity wl-summary-buffer-elmo-folder msg-id)))
         (user-agent (when entity
                       (or (elmo-message-entity-field entity 'user-agent)
                           (elmo-message-entity-field entity 'x-mailer)
                           "Inconnu"))))
    (when user-agent
      (setq mode-line-misc-info
            (list (format " [%s]" (truncate-string-to-width user-agent 30 nil nil "…")))))))

;; Activer l'affichage automatique (décommenter si vous voulez)
(add-hook 'wl-summary-redisplay-hook 'wl-summary-redisplay-hook-user-agent)
;; ======================================================================
;; FIX CRITIQUE :  Keybindings pour templates APRÈS chargement du mode
;; ======================================================================
(with-eval-after-load 'wl-template
  (when (boundp 'wl-template-mode-map)
    (define-key wl-template-mode-map (kbd "<right>") 'wl-template-next)
    (define-key wl-template-mode-map (kbd "<left>") 'wl-template-prev)))

;; ======================================================================
;; ORDRE D'AFFICHAGE DES MESSAGES : DU PLUS RÉCENT AU PLUS ANCIEN
;; ======================================================================
(setq wl-summary-default-sort-spec 'date)
(setq wl-summary-default-sort-order 'reverse)  ; Inverse : plus récent en haut

;; ======================================================================
;; SYNCHRONISATION BIDIRECTIONNELLE IMAP PARFAITE
;; ======================================================================

;; Utiliser le cache local pour les performances
(setq elmo-imap4-use-cache t)

;; Toujours synchroniser les flags (lu/non-lu, important, etc.) avec le serveur
(setq wl-fcc-force-imap-folder t)
(setq elmo-imap4-set-seen-flag-explicitly t)

;; Synchroniser automatiquement au démarrage
(setq wl-auto-check-folder-name "^%")  ; Vérifie tous les dossiers IMAP
(setq wl-auto-check-folder-list '("%INBOX:\"joseph@vidal-rosset.net\"/clear@127.0.0.1:11153"))

;; Synchronisation automatique périodique
(setq wl-biff-check-interval 300)  ; Toutes les 5 minutes (300 secondes)
(setq wl-biff-use-idle-timer t)

;; Confirmer avant de quitter pour s'assurer que tout est synchronisé
(setq wl-interactive-exit t)

;; Configuration de la corbeille et suppressions
(setq wl-trash-folder "%Trash:\"joseph@vidal-rosset.net\"/clear@127.0.0.1:11153")
(setq wl-dispose-folder-alist
      '(("^%.*" . remove)))  ; Suppression définitive sur le serveur

;; Forcer la synchronisation des dossiers IMAP
(setq wl-folder-check-async t)  ; Vérification asynchrone

;; Expunge automatique (vider la corbeille sur le serveur)
(setq wl-expunge-trash-on-exit t)

;; Synchroniser les messages supprimés immédiatement
(setq wl-delete-folder-alist
      '(("^%.*" .  remove)))

;; ======================================================================
;; NOTIFICATIONS POUR NOUVEAUX MESSAGES
;; ======================================================================

(defun my-wl-biff-notify ()
  "Notification système pour nouveaux messages"
  (let ((new (wl-biff-check-folder)))
    (when (and new (> new 0))
      (start-process "wl-notify" nil "notify-send"
                     "Nouveau mail"
                     (format "Vous avez %d nouveau(x) message(s)" new)))))

(add-hook 'wl-biff-notify-hook 'my-wl-biff-notify)

;; ======================================================================
;; RACCOURCI POUR METTRE À LA CORBEILLE
;; ======================================================================

;; FIX :  Utilise with-eval-after-load pour wl-summary
(with-eval-after-load 'wl-summary
  (define-key wl-summary-mode-map (kbd "c")
              (lambda ()
                (interactive)
                (wl-summary-refile (wl-summary-message-number) wl-trash-folder)
                (wl-summary-exec))))

;; ======================================================================
;; CONFIGURATION ORG-MIME POUR WANDERLUST
;; ======================================================================
(require 'oc-csl)  ;; Support CSL dans org-cite
(require 'citeproc)


(with-eval-after-load 'org-mime
  (setq org-mime-library 'semi))  ; Wanderlust utilise SEMI pour MIME

;; ======================================================================
;; BBDB AVEC COMPLÉTION AUTOMATIQUE ET AUTO-COLLECTION
;; ======================================================================
(with-eval-after-load 'wl
  (require 'bbdb nil t)
  (when (featurep 'bbdb)
    (require 'bbdb-mua nil t)
    (require 'bbdb-com nil t)

    (setq bbdb-file "~/.bbdb")
    (bbdb-initialize 'wl)

    ;; AUTO-COLLECTION DES ADRESSES
    (setq bbdb-mua-auto-update-p 'query)  ; Demande confirmation avant d'ajouter
    ;; Ou pour ajouter automatiquement sans demander :
    ;; (setq bbdb-mua-auto-update-p 'create)

    (bbdb-mua-auto-update-init 'wl)

    ;; Créer automatiquement les enregistrements pour les destinataires
    (setq bbdb-mua-update-interactive-p '(query . create))

    ;; Mettre à jour lors de l'envoi ET de la lecture
    (setq bbdb-update-records-p 'create)  ; ou 'query pour demander

    (setq bbdb-completion-display-record t)
    (setq bbdb-complete-mail-allow-cycling t)
    (setq bbdb-mail-name-format 'first-last)

    ;; Charge les records silencieusement
    (with-demoted-errors "BBDB load error: %S"
      (bbdb-records))

    ;; ======================================================================
    ;; DÉSACTIVER SCAN DOUBLONS AU DÉMARRAGE
    ;; ======================================================================
    (setq bbdb-check-postcode nil)
    (setq bbdb-auto-revert nil)
    (setq bbdb-notice-mail-hook nil)
    (setq bbdb-canonicalize-mail-function nil)
    (setq bbdb-allow-duplicates t)
    (setq bbdb-silent t)
    (setq bbdb-message-all-addresses nil)))

;; ======================================================================
;; COMPANY-MODE POUR COMPLÉTION AUTO
;; ======================================================================
(with-eval-after-load 'company
  (when (require 'company-bbdb nil t)
    (add-hook 'wl-draft-mode-hook
              (lambda ()
                (company-mode 1)
                (setq-local company-backends '(company-bbdb))
                (setq-local company-minimum-prefix-length 2)
                (setq-local company-idle-delay 0.1)))

    (setq company-bbdb-modes '(message-mode wl-draft-mode))))

;; ======================================================================
;; NETTOYAGE DOUBLONS BBDB
;; ======================================================================
(defun bbdb-delete-redundant-mails ()
  "Supprime les adresses email redondantes dans BBDB"
  (interactive)
  (let ((records (bbdb-records))
        (n 0))
    (dolist (record records)
      (let* ((mails (bbdb-record-mail record))
             (unique-mails (delete-dups mails)))
        (when (not (equal mails unique-mails))
          (bbdb-record-set-mail record unique-mails)
          (setq n (1+ n)))))
    (bbdb-save)
    (message "Nettoyé %d enregistrements" n)))

(defun bbdb-remove-duplicate-records ()
  "Supprime les enregistrements BBDB dupliqués"
  (interactive)
  (when (yes-or-no-p "Supprimer les doublons BBDB ? ")
    (let ((records (bbdb-records))
          (seen (make-hash-table :test 'equal))
          (to-delete nil))
      (dolist (record records)
        (let* ((name (bbdb-record-name record))
               (mail (car (bbdb-record-mail record)))
               (key (cons name mail)))
          (if (gethash key seen)
              (push record to-delete)
            (puthash key t seen))))
      (dolist (record to-delete)
        (bbdb-delete-records (list record) t))
      (bbdb-save)
      (message "Supprimé %d doublons" (length to-delete)))))

;; ======================================================================
;; GESTION MÉMOIRE LÉGÈRE POUR DAEMON
;; ======================================================================

;; Garbage collection quand idle (toutes les 5 minutes)
(run-with-idle-timer 300 t #'garbage-collect)

;; Libérer la mémoire de Wanderlust quand on quitte
(add-hook 'wl-exit-hook
          (lambda ()
            (garbage-collect)))

;; Fonction pour monitorer la mémoire
(defun my-emacs-memory-report ()
  "Affiche l'utilisation mémoire d'Emacs"
  (interactive)
  (let ((mem (memory-use-counts)))
    (message "Emacs utilise %.1f Mo"
             (/ (float (car mem)) 1048576.0))))

;;=====================================================================
;; Configuration de base pour Wanderlust en org-mode
;;====================================================================

;; Assurez-vous que org-ref est chargé
(require 'org-ref)
(require 'ivy-bibtex)  ; au lieu de helm-bibtex
(setq org-ref-completion-library 'org-ref-ivy-cite)  ; au lieu de helm-cite
  ; Support CSL dans org-ref ?



;; Chemin vers les fichiers CSL
(setq org-ref-csl-styles-directory "~/.emacs.d/personal/oil-shale.csl")
                                        ; Choisir un style (par exemple, IEEE, APA, Chicago, etc.)
(setq org-ref-csl-default-style "~/.emacs.d/personal/oil-shale.csl")  ; ou votre style préféré

;; Configuration pour citations dans emails
(setq org-ref-bibliography-notes "~/Dropbox/Orgzly/notes.org"
      org-ref-default-bibliography '("~/Dropbox/org/blog/blog.bib")
      org-ref-pdf-directory "~/~/Dropbox/org/pdf/")

;; Pour que les liens de citations soient exportés en HTML
(setq org-html-with-latex 'mathjax)  ; Si vous avez des formules

;; Fonction pour insérer rapidement une citation dans un email
(defun wl-draft-insert-citation ()
  "Insert org-ref citation in Wanderlust draft"
  (interactive)
  (when (eq major-mode 'org-mode)
    (org-ref-insert-cite-link)))

;; Keybinding dans les brouillons
(add-hook 'wl-draft-mode-hook
          '(lambda ()
             (when (eq major-mode 'org-mode)
               (local-set-key (kbd "C-c ]") 'wl-draft-insert-citation))))



(defun my-org-mime-edit-advice ()
  "Add template after org-mime-edit-mail-in-org-mode"
  (run-with-idle-timer
   0.1 nil
   (lambda ()
     (when (get-buffer "OrgMimeMailBody")
       (with-current-buffer "OrgMimeMailBody"
         (goto-char (point-max))
         ;; AJOUT CRUCIAL : Activer l'export LaTeX en images
         (insert "#+OPTIONS: tex:dvipng\n")
         (insert "#+BIBLIOGRAPHY: ~/Dropbox/org/blog/blog.bib\n")
         (insert "#+CSL_STYLE: /home/joseph/.emacs.d/personal/oil-shale.csl\n")
         (insert "#+CSL_LOCALE: en-US\n\n")
         ;; Section References avec biblio Kitchin
         (goto-char (point-max))
         (insert "\n*** References\n\n")
         (insert "bibliography:~/Dropbox/org/blog/blog.bib\n"))))))

(advice-add 'org-mime-edit-mail-in-org-mode :after #'my-org-mime-edit-advice)

;; Vérifier les nouveaux messages toutes les 3 minutes
(setq wl-biff-check-interval 180)
(setq wl-biff-check-folder-list '("%INBOX"))
(setq wl-biff-notify-hook
      '(lambda ()
         (start-process "notify" nil
                        "notify-send" "-i" "mail-unread"
                        "Nouveau courriel"
                        "Vous avez un nouveau message")))

(setq wl-biff-check-folder-list
      '("%INBOX:\"joseph@vidal-rosset.net\"/clear@127.0.0.1:11153"))

;; BBDB : enregistrer uniquement à l'envoi, pas à la lecture
(setq bbdb-mua-auto-update-p 'search)  ; ne pas créer à la lecture
(setq bbdb/mail-auto-create-p nil)

;; Créer automatiquement à l'envoi
(add-hook 'wl-mail-send-hook
          (lambda ()
            (let ((bbdb/mail-auto-create-p t))
              (bbdb-mua-auto-update))))

(with-eval-after-load 'w3m
  (setq w3m-use-external-browser t)
  (setq w3m-external-browser "firefox")

  ;; Remplacer la fonction qui intercepte les liens dans Wanderlust
  (define-key w3m-minor-mode-map [return]
              (lambda () (interactive)
                (let ((url (w3m-url-valid (w3m-anchor))))
                  (if url
                      (start-process "firefox" nil "firefox" url)
                    (w3m-safe-view-this-url)))))

  (define-key w3m-minor-mode-map [mouse-2]
              (lambda (event) (interactive "e")
                (mouse-set-point event)
                (let ((url (w3m-url-valid (w3m-anchor))))
                  (if url
                      (start-process "firefox" nil "firefox" url)
                    (w3m-safe-view-this-url))))))

(provide 'wl)
;;; wl.el ends here
