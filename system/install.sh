#!/bin/bash
# Installs the EXWM session files into their system locations.
# These live outside ~/.emacs.d/personal/ and need root, so they
# can't just be cloned into place like the rest of this repository.
#
# Usage: sudo ./system/install.sh
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root (sudo ./system/install.sh)." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -m 644 "$SCRIPT_DIR/xsessions/exwm.desktop" /usr/share/xsessions/exwm.desktop
install -m 755 "$SCRIPT_DIR/bin/exwm-session" /usr/local/bin/exwm-session

echo "Installed:"
echo "  /usr/share/xsessions/exwm.desktop"
echo "  /usr/local/bin/exwm-session"
echo
echo "EXWM should now appear as a session choice in LightDM."
