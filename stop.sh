#!/usr/bin/env bash
# stop.sh - stop ip-mac-pro, restore the original MAC and stop Tor.
# Author: Dhrub Raj Giri (DRG)  https://github.com/Dhrub001

DIR=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
# shellcheck source=lib.sh
. "$DIR/lib.sh" || { echo "Cannot load lib.sh from $DIR" >&2; exit 1; }

KEEP_TOR=0
IFACE_ARG=""

usage() {
    cat <<EOF
Usage: sudo ./stop.sh [options]

Stops a running ip-mac-pro, puts the original MAC back and stops Tor.

Options:
  -i, --iface NAME  also restore this interface to its hardware MAC, even if
                    no saved copy exists (for example after an old version
                    or a crash left a spoofed MAC behind)
      --keep-tor    leave Tor running
  -h, --help        show this help
EOF
}

while [ $# -gt 0 ]; do
    case $1 in
        -i | --iface)
            [ $# -ge 2 ] || die "Option $1 needs a value"
            IFACE_ARG=$2
            shift 2 ;;
        --keep-tor) KEEP_TOR=1; shift ;;
        -h | --help) usage; exit 0 ;;
        *) err "Unknown option: $1"; usage >&2; exit 2 ;;
    esac
done

need_root
need_cmds ip awk sed

# 1) Ask a running ip-mac-pro to shut down. Its own handler restores everything.
pidfile="$IMC_STATE_DIR/pid"
if [ -r "$pidfile" ]; then
    pid=$(cat "$pidfile" 2>/dev/null)
    if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null &&
        tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null | grep -q 'ip-mac-pro'; then
        info "Stopping the running ip-mac-pro (pid $pid)"
        kill -TERM "$pid"
        for _ in $(seq 1 20); do
            kill -0 "$pid" 2>/dev/null || break
            sleep 0.5
        done
    fi
fi

# 2) Restore every interface that has a saved original MAC.
restored=0
shopt -s nullglob
for f in "$IMC_STATE_DIR"/*.mac; do
    iface=$(basename "$f" .mac)
    if ip link show dev "$iface" >/dev/null 2>&1; then
        info "Restoring $iface"
        restore_netid "$iface" && restored=1
    fi
done
shopt -u nullglob

if [ -n "$IFACE_ARG" ]; then
    iface=$(detect_iface "$IFACE_ARG") || die "Network interface not found: $IFACE_ARG"
    info "Restoring $iface to its hardware MAC"
    restore_netid "$iface" && restored=1
fi

if [ "$restored" = 0 ]; then
    info "No saved original MAC was found, so I left your MAC alone."
    info "If a spoofed MAC is stuck, run: sudo ./stop.sh --iface <name>"
fi

# 3) Stop Tor.
if [ "$KEEP_TOR" = 0 ] && tor_running; then
    tor_stop
    ok "Tor stopped"
fi

ok "Done"
