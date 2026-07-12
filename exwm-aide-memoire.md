# EXWM — Aide-mémoire

## Lancer des applications

| Touche        | Action                        |
|---------------|-------------------------------|
| `Super + f`   | Firefox                       |
| `Super + t`   | Terminal (xterm)              |
| `Super + e`   | Gestionnaire de fichiers      |
| `Super + d`   | dmenu (lanceur d'applications)|

## Gestion des fenêtres

| Touche        | Action                        |
|---------------|-------------------------------|
| `Super + b`   | Changer de buffer             |
| `Super + o`   | Passer à l'autre fenêtre      |
| `Super + h`   | Split vertical (côte à côte) |
| `Super + v`   | Split horizontal              |
| `Super + q`   | Fermer le panneau             |
| `Super + k`   | Tuer le buffer                |
| `Super + m`   | Plein écran                   |
| `Super + 1`   | Une seule fenêtre (C-x 1)    |
| `Super + g`   | Basculer flottant / tiling    |
| `Super + r`   | Reset (sortir du mode char)   |
| `Super + c`   | Basculer char-mode / line-mode|

## Workspaces

| Touche          | Action                      |
|-----------------|------------------------------|
| `Super + 0..9`  | Aller au workspace N         |

## Raccourcis Emacs dans Firefox (simulation-keys)

### Navigation
| Emacs         | Action dans Firefox           |
|---------------|-------------------------------|
| `C-b`         | ← gauche                     |
| `C-f`         | → droite                     |
| `C-p`         | ↑ haut                       |
| `C-n`         | ↓ bas                        |
| `C-a`         | Début de ligne                |
| `C-e`         | Fin de ligne                  |
| `M-v`         | Page précédente               |
| `C-v`         | Page suivante                 |
| `C-d`         | Supprimer caractère           |
| `C-k`         | Supprimer jusqu'à fin de ligne|

### Copier / Coller / Couper
| Emacs         | Action dans Firefox           |
|---------------|-------------------------------|
| `M-w`         | Copier                        |
| `C-y`         | Coller                        |
| `C-w`         | Couper                        |

### Recherche et édition
| Emacs         | Action dans Firefox           |
|---------------|-------------------------------|
| `C-s`         | Rechercher                    |
| `C-/`         | Annuler                       |
| `C-x h`       | Tout sélectionner             |
| `C-x C-s`     | Sauvegarder                  |

### Onglets
| Emacs         | Action dans Firefox           |
|---------------|-------------------------------|
| `C-x k`       | Fermer l'onglet               |
| `C-x b`       | Nouvel onglet                 |

## Mode char vs line

- **line-mode** (par défaut) : les raccourcis Emacs fonctionnent dans Firefox via simulation-keys
- **char-mode** (`Super+c` ou `C-c C-q`) : toutes les touches vont directement à Firefox
- Pour revenir en line-mode : `Super+r`

## Installation

1. Copier `exwm-config.el` dans `~/.emacs.d/personal/`
2. Se déconnecter, choisir **EXWM** dans LightDM
3. Si problème : se déconnecter, choisir **XFCE** dans LightDM
