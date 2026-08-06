# Wanderlust — Aide-mémoire

## Lancer / Quitter

| Touche      | Action                          |
|-------------|---------------------------------|
| `F2`        | Lancer Wanderlust               |
| `q`         | Quitter le summary / les dossiers |

## Composer et envoyer

| Touche      | Action                                              |
|-------------|------------------------------------------------------|
| `w`         | Nouveau message (depuis le summary)                  |
| `a`         | Répondre (reply)                                     |
| `A`         | Répondre à tous (reply all)                          |
| `f`         | Transférer (forward)                                 |
| `E`         | Éditer un brouillon existant (wl-summary-reedit)     |
| `F7`        | Passer en org-mode (`org-mime-edit-mail-in-org-mode`) |
| `F4`        | Convertir org → HTML (`org-mime-htmlize`)            |
| `C-c C-c`   | Envoyer le message                                  |
| `C-c C-k`   | Annuler le brouillon                                |

### Workflow typique (email enrichi)

1. `w` → composer
2. Remplir To:, Subject:
3. `F7` → passer en org-mode
4. Rédiger en Org (liens, listes, code, LaTeX…)
5. `F4` → convertir en HTML
6. `C-c C-c` → envoyer

### Workflow simple (texte brut)

1. `w` → composer
2. Remplir To:, Subject:, écrire le message
3. `C-c C-c` → envoyer

## Changer de compte (Proton ↔ Université)

| Touche      | Action                                     |
|-------------|---------------------------------------------|
| `C-c C-j`   | Ouvrir le sélecteur de template            |
| `←` / `→`  | Alterner entre **proton** et **univ**       |

- **proton** = joseph@vidal-rosset.net (via Proton Bridge, 127.0.0.1:10035)
- **univ** = joseph.vidal-rosset@univ-lorraine.fr (via smtp.univ-lorraine.fr)

⚠️ **Vérifier le template sélectionné avant d'envoyer !**

## Gestion des messages (dans le summary)

| Touche | Action                                    |
|--------|-------------------------------------------|
| `c`    | Mettre à la corbeille (raccourci perso)   |
| `d`    | Marquer pour suppression                  |
| `o`    | Déplacer vers un dossier (refile)         |
| `x`    | Exécuter les actions marquées             |
| `s`    | Synchroniser le dossier                   |
| `i`    | Rafraîchir / mettre à jour               |
| `n`    | Message suivant                           |
| `p`    | Message précédent                         |
| `SPC`  | Lire / défiler le message                 |

## Liens dans les messages

Les liens sont gérés par w3m-minor-mode, configuré pour ouvrir Firefox :

| Touche       | Action                              |
|--------------|--------------------------------------|
| `RET`        | Ouvrir le lien sous le curseur dans Firefox |
| `clic molette` | Ouvrir le lien dans Firefox        |

Configuration requise dans init Emacs :

```elisp
(with-eval-after-load 'w3m
  (setq w3m-use-external-browser t)
  (setq w3m-external-browser "firefox")
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
```

## Notifications de nouveaux messages

Wanderlust vérifie les nouveaux messages et envoie une notification bureau :

```elisp
(setq wl-biff-check-interval 180)  ; toutes les 3 minutes
(setq wl-biff-check-folder-list
      '("%INBOX:\"joseph@vidal-rosset.net\"/clear@127.0.0.1:11153"))
(setq wl-biff-notify-hook
      '(lambda ()
         (start-process "notify" nil
                        "notify-send" "-i" "mail-unread"
                        "Nouveau courriel"
                        "Vous avez un nouveau message")))
```

## Chaîne de réception univ-lorraine

univ-lorraine → Gmail (POP3, toutes les ~heures) → Proton (transfert auto) → Wanderlust

Rien à configurer côté Wanderlust, tout transite automatiquement.

## Fichiers de configuration

| Fichier                                       | Rôle                          |
|-----------------------------------------------|-------------------------------|
| `~/.emacs.d/personal/wl.el`                   | Configuration Wanderlust      |
| `~/.emacs.d/personal/.folders`                | Dossiers IMAP                 |
| `~/.emacs.d/personal/.authinfo`               | Identifiants (SMTP/IMAP)     |
| `~/.emacs.d/personal/preload/01-wanderlust-path.el` | Chemin vers wl.el       |
| `~/.emacs.d/personal/preload/00-fix-elmo-timer.el`  | Fix timer Elmo          |

## Rappel Proton Bridge

Proton Bridge doit tourner en arrière-plan pour que Wanderlust puisse se connecter.

- IMAP : `127.0.0.1:11153`
- SMTP : `127.0.0.1:10035`

## Raccourci aide-mémoire

`F11 w` → Ouvre ce fichier. Voir `myshortcuts.el`.

```elisp
(global-set-key [f6]
  (lambda () (interactive)
    (find-file "~/wanderlust-aide-memoire.md")))
```
