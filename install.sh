#!/usr/bin/env bash
# install.sh - install what ip-mac-changer needs (Kali, Parrot, Debian, Ubuntu).
# Author: Dhrub Raj Giri (DRG)  https://github.com/Dhrub001

DIR=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
# shellcheck source=lib.sh
. "$DIR/lib.sh" || { echo "Cannot load lib.sh from $DIR" >&2; exit 1; }

need_root

if ! command -v apt-get >/dev/null 2>&1; then
    die "This installer supports apt-based systems (Kali, Parrot, Debian, Ubuntu).
    On another distribution, install these by hand: tor, curl, netcat (the OpenBSD one),
    iproute2, ethtool, procps and util-linux, plus dhclient or NetworkManager.
    Then run: chmod +x ip-mac-pro anonymizer.sh stop.sh monitor.sh"
fi

export DEBIAN_FRONTEND=noninteractive

info "Installing packages"
apt-get update || warn "apt-get update reported a problem, trying to continue"
apt-get install -y tor curl netcat-openbsd iproute2 ethtool procps util-linux ||
    die "Package installation failed"
# dhclient is only needed when NetworkManager is not managing the interface.
apt-get install -y isc-dhcp-client ||
    warn "isc-dhcp-client is not available here. That is fine if NetworkManager manages your network."

info "Making the scripts executable"
chmod +x "$DIR/ip-mac-pro" "$DIR/anonymizer.sh" "$DIR/stop.sh" "$DIR/monitor.sh" "$DIR/install.sh"

# Tor's control port is off by default. It is what lets us ask for a new identity
# without restarting Tor. It listens on localhost only and needs Tor's cookie file.
TORRC=/etc/tor/torrc
MARK_BEGIN="# >>> ip-mac-changer >>>"
MARK_END="# <<< ip-mac-changer <<<"
if [ -f "$TORRC" ] && ! grep -qF "$MARK_BEGIN" "$TORRC"; then
    info "Enabling Tor's local control port"
    cp -n "$TORRC" "$TORRC.imc-backup"
    add_lines=""
    grep -Eq '^[[:space:]]*ControlPort[[:space:]]' "$TORRC" ||
        add_lines+="ControlPort 127.0.0.1:$TOR_CONTROL_PORT"$'\n'
    grep -Eq '^[[:space:]]*CookieAuthentication[[:space:]]' "$TORRC" ||
        add_lines+="CookieAuthentication 1"$'\n'
    printf '\n%s\n%s%s\n' "$MARK_BEGIN" "$add_lines" "$MARK_END" >> "$TORRC"
    if tor --verify-config -f "$TORRC" >/dev/null 2>&1; then
        systemctl try-restart tor >/dev/null 2>&1
        ok "Tor control port enabled"
    else
        cp "$TORRC.imc-backup" "$TORRC"
        warn "Tor rejected the new settings, so I put your torrc back. Tor identity changes will restart Tor instead."
    fi
fi

echo
ok "Installation complete"
echo
echo "Usage:"
echo "  sudo ./ip-mac-pro         menu (or: sudo ./ip-mac-pro --help)"
echo "  sudo ./anonymizer.sh      MAC + IP + Tor identity every 60 seconds"
echo "  sudo ./stop.sh            restore the original MAC and stop Tor"
echo "  ./monitor.sh              live view of MAC, IP and Tor"
echo
echo "Note: installing Tor starts it at boot. To stop that: sudo systemctl disable tor"
