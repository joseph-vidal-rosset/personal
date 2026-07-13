# personal

This repository contains the `personal/` layer of my [Prelude
Emacs](https://github.com/bbatsov/prelude) configuration — the part
that's actually mine, as opposed to Prelude itself or the packages it
installs.

**This is not a full `.emacs.d/`.** Prelude, and every package it
pulls in under `elpa/`, is reproducible on its own from Prelude's own
repository and your `package-selected-packages`. Committing that here
would just be dead weight that goes stale the moment a package
updates. What's versioned here is the layer that sits on top: my own
Elisp, my own decisions.

## What's in here

- **EXWM setup** — replacing XFCE with Emacs as the window manager on
  MX Linux: session glue, autostart handling, tray detection, and the
  fixes for the usual EXWM rough edges (autostart timing, ghost daemon
  on reboot, sysVinit migration).
- **`system/`** — the two files that make EXWM appear as a session
  choice in LightDM, which live outside `~/.emacs.d/personal/` in
  system directories (`/usr/share/xsessions/`, `/usr/local/bin/`) and
  therefore need a separate install step — see below.
- **`publish.el`** — the org-publish pipeline behind my blog at
  [vidal-rosset.net](https://vidal-rosset.net): section pages, date
  stamping, bibliography handling (CSL/org-cite for HTML, org-ref for
  LaTeX/PDF), and a GitHub link abbreviation so blog posts can
  reference files in this and other repositories directly.
- **Key bindings and shortcuts** — the day-to-day muscle memory:
  Org capture, Wanderlust, Athena, blog publishing commands, and more.

## How to use this

1. Install Prelude normally:
   ```sh
   git clone https://github.com/bbatsov/prelude.git ~/.emacs.d
   ```
2. Clone this repository and drop its contents into
   `~/.emacs.d/personal/`, replacing (or merging with) whatever
   Prelude put there by default.
3. Restart Emacs. Prelude will pick up everything in `personal/`
   automatically.
4. To also get EXWM as a LightDM session choice, install the system
   files (requires root, since they go outside your home directory):
   ```sh
   sudo ./system/install.sh
   ```
   This copies `system/xsessions/exwm.desktop` to
   `/usr/share/xsessions/` and `system/bin/exwm-session` to
   `/usr/local/bin/`, then makes the script executable. Log out and
   "EXWM" should appear as a session option in LightDM.

Some pieces assume my own directory layout (Dropbox paths, a
particular bibliography file, my own EXWM session scripts) and will
need adjusting for a different machine — this is published for
reference and reuse, not as a drop-in package.

## License

Free to reuse, adapt, and learn from. No warranty — some of this is
genuinely idiosyncratic to my own setup.
