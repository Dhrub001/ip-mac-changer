#!/usr/bin/env bash
# monitor.sh - live view of your MAC, local IP, public IP and Tor exit. No root needed.
# Author: Dhrub Raj Giri (DRG)  https://github.com/Dhrub001

DIR=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
# shellcheck source=lib.sh
. "$DIR/lib.sh" || { echo "Cannot load lib.sh from $DIR" >&2; exit 1; }

IFACE_ARG=""
REFRESH=2
NET_EVERY=30     # public IP and Tor are checked this often, so the lookup sites are not hammered
ONCE=0

usage() {
    cat <<EOF
Usage: ./monitor.sh [options]

Options:
  -i, --iface NAME   network interface (default: the one with the default route)
  -r, --refresh SEC  screen refresh in seconds (default 2)
      --once         print one snapshot and exit
  -h, --help         show this help
EOF
}

while [ $# -gt 0 ]; do
    case $1 in
        -i | --iface | -r | --refresh)
            [ $# -ge 2 ] || die "Option $1 needs a value"
            case $1 in -i | --iface) IFACE_ARG=$2 ;; *) REFRESH=$2 ;; esac
            shift 2 ;;
        --once) ONCE=1; shift ;;
        -h | --help) usage; exit 0 ;;
        *) err "Unknown option: $1"; usage >&2; exit 2 ;;
    esac
done
[[ "$REFRESH" =~ ^[1-9][0-9]*$ ]] || die "The refresh time must be a whole number of seconds"

need_cmds ip awk sed curl
iface=$(detect_iface "$IFACE_ARG") || die "Network interface not found. List them with: ip link"

declare -A LAST NOTE
mac=""; lip=""; pub=""; tor_up=0; tor_ip=""; tor_is=""; tor_loc=""; loc_for=""; last_net=0

track() {          # remember each value and note when it changes
    local k=$1 v=$2
    if [ -n "${LAST[$k]+x}" ] && [ "${LAST[$k]}" != "$v" ]; then
        NOTE[$k]="changed from ${LAST[$k]:-none} at $(date +%H:%M:%S)"
    fi
    LAST[$k]=$v
}

line() {           # line LABEL VALUE [KEY]
    printf '  %-14s %s\n' "$1" "${2:-unknown}"
    if [ -n "${3:-}" ] && [ -n "${NOTE[$3]:-}" ]; then
        printf '  %-14s %s%s%s\n' "" "$C_YELLOW" "${NOTE[$3]}" "$C_OFF"
    fi
}

refresh_net() {
    local out
    pub=$(public_ip)
    if socks_up; then
        tor_up=1
        if out=$(tor_check); then
            tor_is=${out%% *}
            tor_ip=${out#* }
            if [ "$tor_ip" != "$loc_for" ]; then tor_loc=$(tor_where "$tor_ip"); loc_for=$tor_ip; fi
        else
            tor_is=""; tor_ip=""; tor_loc=""
        fi
    else
        tor_up=0; tor_is=""; tor_ip=""; tor_loc=""
    fi
    last_net=$(date +%s)
    track pub "$pub"
    track torip "$tor_ip"
}

frame() {
    printf '%sNetwork monitor%s    %s    interface %s\n\n' "$C_BOLD" "$C_OFF" "$(date +%H:%M:%S)" "$iface"
    line "MAC address" "$mac" mac
    line "Local IP" "${lip:-none}" lip
    line "Public IP" "${pub:-unavailable} (direct, without Tor)" pub
    echo
    if [ "$tor_up" = 1 ]; then
        line "Tor" "running"
        if [ -n "$tor_ip" ]; then
            line "Tor exit IP" "$tor_ip" torip
            line "Tor location" "${tor_loc:-unknown}"
            line "Tor check" "$([ "$tor_is" = true ] && echo 'confirmed by check.torproject.org' || echo 'NOT confirmed as Tor')"
        else
            line "Tor exit IP" "not connected yet"
        fi
    else
        line "Tor" "not running (start it with: sudo ./ip-mac-pro)"
    fi
    printf '\n  Public IP and Tor were checked %ss ago.' "$(( $(date +%s) - last_net ))"
    [ "$ONCE" = 1 ] || printf '  Press Ctrl+C to exit.'
    echo
}

if [ "$ONCE" = 1 ]; then
    mac=$(iface_mac "$iface"); lip=$(iface_ip "$iface")
    refresh_net
    frame
    exit 0
fi

trap 'printf "\033[?25h\n"; exit 0' INT TERM
printf '\033[?25l'
while true; do
    mac=$(iface_mac "$iface")
    lip=$(iface_ip "$iface")
    track mac "$mac"
    track lip "$lip"
    if [ $(( $(date +%s) - last_net )) -ge "$NET_EVERY" ]; then refresh_net; fi
    out=$(frame)
    printf '\033[H\033[J%s\n' "$out"
    nap "$REFRESH"
done
