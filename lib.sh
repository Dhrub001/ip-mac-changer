#!/usr/bin/env bash
# lib.sh - shared helpers for ip-mac-changer.
# Source this file from the other scripts. It is not meant to be run directly.
# Author: Dhrub Raj Giri (DRG)  https://github.com/Dhrub001

# shellcheck disable=SC2034  # these variables are used by the scripts that source this file
IMC_VERSION="2.1"
IMC_STATE_DIR="${IMC_STATE_DIR:-/var/lib/ip-mac-changer}"
IMC_MIN_INTERVAL=10
TOR_SOCKS_HOST="127.0.0.1"
TOR_SOCKS_PORT=9050
TOR_CONTROL_PORT=9051
TOR_COOKIE="${TOR_COOKIE:-/run/tor/control.authcookie}"

# ---------------------------------------------------------------- output
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    C_RED=$'\033[0;31m'; C_GREEN=$'\033[0;32m'; C_YELLOW=$'\033[1;33m'
    C_CYAN=$'\033[0;36m'; C_BOLD=$'\033[1m'; C_OFF=$'\033[0m'
else
    C_RED=""; C_GREEN=""; C_YELLOW=""; C_CYAN=""; C_BOLD=""; C_OFF=""
fi

info() { printf '%s[i]%s %s\n' "$C_CYAN" "$C_OFF" "$*"; }
ok()   { printf '%s[ok]%s %s\n' "$C_GREEN" "$C_OFF" "$*"; }
warn() { printf '%s[!]%s %s\n' "$C_YELLOW" "$C_OFF" "$*" >&2; }
err()  { printf '%s[x]%s %s\n' "$C_RED" "$C_OFF" "$*" >&2; }
die()  { err "$*"; exit 1; }

# ---------------------------------------------------------------- checks
need_root() {
    [ "$(id -u)" -eq 0 ] || [ -n "${IMC_ALLOW_NONROOT:-}" ] || die "This needs root. Run: sudo $0"
}

need_cmds() {
    local missing=() c
    for c in "$@"; do
        command -v "$c" >/dev/null 2>&1 || missing+=("$c")
    done
    [ "${#missing[@]}" -eq 0 ] || die "Missing: ${missing[*]}. Run: sudo ./install.sh"
}

valid_interval() {
    [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge "$IMC_MIN_INTERVAL" ]
}

# Sleep in a way that lets Ctrl+C or a TERM signal take effect immediately.
nap() { sleep "$1" 9>&- & wait $!; }

# ---------------------------------------------------------------- interface and MAC
detect_iface() {   # detect_iface [NAME] -> prints the interface to use
    local want="${1:-}" dev=""
    if [ -n "$want" ]; then
        [[ "$want" =~ ^[A-Za-z0-9_.:@-]+$ ]] || return 1
        ip link show dev "$want" >/dev/null 2>&1 || return 1
        printf '%s\n' "$want"
        return 0
    fi
    dev=$(ip -o route show default 2>/dev/null |
        awk '{for (i = 1; i < NF; i++) if ($i == "dev") { print $(i + 1); exit }}')
    if [ -z "$dev" ]; then
        dev=$(ip -o link show up 2>/dev/null | awk -F': ' '$2 != "lo" { print $2; exit }')
        dev=${dev%%@*}
    fi
    [ -n "$dev" ] || return 1
    printf '%s\n' "$dev"
}

iface_mac() {
    ip -o link show dev "$1" 2>/dev/null |
        awk '{for (i = 1; i < NF; i++) if ($i == "link/ether") { print tolower($(i + 1)); exit }}'
}

iface_ip() {
    ip -4 -o addr show dev "$1" 2>/dev/null |
        awk '{for (i = 1; i < NF; i++) if ($i == "inet") { split($(i + 1), a, "/"); print a[1]; exit }}'
}

valid_mac() {      # a unicast MAC written as aa:bb:cc:dd:ee:ff
    [[ "$1" =~ ^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$ ]] || return 1
    (( 16#${1:0:2} & 1 )) && return 1
    return 0
}

random_mac() {     # random, unicast, locally administered
    local first=$(( (RANDOM % 256 & 0xFE) | 0x02 ))
    printf '%02x:%02x:%02x:%02x:%02x:%02x\n' "$first" \
        $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))
}

perm_mac() {       # the hardware MAC burned into the card, if ethtool can read it
    command -v ethtool >/dev/null 2>&1 || return 0
    local m
    m=$(ethtool -P "$1" 2>/dev/null | awk '/Permanent address:/ { print tolower($3) }')
    case "$m" in "" | 00:00:00:00:00:00) return 0 ;; esac
    valid_mac "$m" && printf '%s\n' "$m"
    return 0
}

state_file() { printf '%s/%s.mac\n' "$IMC_STATE_DIR" "$1"; }

save_original_mac() {   # remember the real MAC once, before the first change
    local iface=$1 f m
    f=$(state_file "$iface")
    [ -s "$f" ] && return 0
    m=$(perm_mac "$iface")
    [ -n "$m" ] || m=$(iface_mac "$iface")
    [ -n "$m" ] || return 1
    mkdir -p "$IMC_STATE_DIR" && chmod 700 "$IMC_STATE_DIR" || return 1
    printf '%s\n' "$m" > "$f"
}

original_mac() {
    local f m
    f=$(state_file "$1")
    if [ -s "$f" ]; then head -n 1 "$f"; return 0; fi
    m=$(perm_mac "$1")
    if [ -n "$m" ]; then printf '%s\n' "$m"; return 0; fi
    iface_mac "$1"
}

set_mac() {        # set_mac IFACE MAC - changes the MAC and checks that it took
    local iface=$1 mac=$2 got
    valid_mac "$mac" || { err "Refusing an invalid MAC: $mac"; return 1; }
    ip link set dev "$iface" down || { err "Could not bring $iface down"; return 1; }
    if ! ip link set dev "$iface" address "$mac"; then
        ip link set dev "$iface" up
        err "The driver refused the new MAC on $iface (some Wi-Fi cards will not change while connected)"
        return 1
    fi
    ip link set dev "$iface" up || { err "Could not bring $iface back up"; return 1; }
    got=$(iface_mac "$iface")
    [ "$got" = "${mac,,}" ] || { err "The MAC did not change (it is still ${got:-unknown})"; return 1; }
}

# ---------------------------------------------------------------- IP address
nm_manages() {     # is this interface controlled by NetworkManager?
    command -v nmcli >/dev/null 2>&1 || return 1
    systemctl is-active --quiet NetworkManager 2>/dev/null || return 1
    nmcli -t -f DEVICE,STATE device status 2>/dev/null |
        awk -F: -v d="$1" '$1 == d && $2 != "unmanaged" { f = 1 } END { exit !f }'
}

wait_for_ip() {    # wait_for_ip IFACE [SECONDS]
    local i
    for ((i = 0; i < ${2:-15}; i++)); do
        [ -n "$(iface_ip "$1")" ] && return 0
        sleep 1
    done
    return 1
}

renew_ip() {       # ask for a fresh DHCP lease
    local iface=$1
    if nm_manages "$iface"; then
        nmcli device disconnect "$iface" >/dev/null 2>&1
        nmcli device connect "$iface" >/dev/null 2>&1 ||
            { err "NetworkManager could not reconnect $iface"; return 1; }
    else
        command -v dhclient >/dev/null 2>&1 ||
            { err "dhclient is not installed. Run: sudo ./install.sh"; return 1; }
        dhclient -r "$iface" >/dev/null 2>&1
        ip addr flush dev "$iface" >/dev/null 2>&1
        timeout 30 dhclient -1 "$iface" >/dev/null 2>&1 ||
            { err "No DHCP answer on $iface"; return 1; }
    fi
    wait_for_ip "$iface" 20 || { err "No IPv4 address on $iface after renewing"; return 1; }
}

restore_netid() {  # restore_netid IFACE - put the original MAC back
    local iface=$1 orig cur
    orig=$(original_mac "$iface")
    cur=$(iface_mac "$iface")
    [ -n "$orig" ] || { warn "No original MAC known for $iface"; return 1; }
    if [ "$cur" = "$orig" ]; then
        ok "MAC is already the original ($orig)"
    else
        set_mac "$iface" "$orig" || return 1
        ok "MAC restored to $orig"
        if renew_ip "$iface"; then ok "IP address: $(iface_ip "$iface")"; fi
    fi
    rm -f "$(state_file "$iface")"
}

# ---------------------------------------------------------------- Tor
tor_installed() { command -v tor >/dev/null 2>&1; }
tor_running()   { command -v pgrep >/dev/null 2>&1 && pgrep -x tor >/dev/null 2>&1; }
socks_up()      { command -v nc >/dev/null 2>&1 && nc -z "$TOR_SOCKS_HOST" "$TOR_SOCKS_PORT" >/dev/null 2>&1; }

tor_start() {
    tor_installed || { err "Tor is not installed. Run: sudo ./install.sh"; return 1; }
    local i
    if ! socks_up; then
        systemctl unmask tor >/dev/null 2>&1
        systemctl start tor >/dev/null 2>&1 || { err "systemctl could not start tor"; return 1; }
    fi
    for ((i = 0; i < 30; i++)); do
        socks_up && return 0
        sleep 1
    done
    err "Tor started but its proxy port $TOR_SOCKS_PORT never opened. Check: systemctl status tor"
    return 1
}

tor_stop() {
    systemctl stop tor >/dev/null 2>&1
    systemctl stop tor@default >/dev/null 2>&1
    if tor_running; then pkill -x tor >/dev/null 2>&1; fi
    return 0
}

tor_newnym() {     # ask Tor for fresh circuits; true only if Tor confirmed it
    local auth='AUTHENTICATE ""' reply
    if [ -r "$TOR_COOKIE" ]; then
        auth="AUTHENTICATE $(od -An -v -tx1 "$TOR_COOKIE" | tr -d ' \n')"
    fi
    reply=$(printf '%s\r\nSIGNAL NEWNYM\r\nQUIT\r\n' "$auth" |
        nc -w 3 127.0.0.1 "$TOR_CONTROL_PORT" 2>/dev/null | tr -d '\r')
    [ "$(printf '%s\n' "$reply" | grep -c '^250 OK$')" -ge 2 ]
}

tor_check() {      # prints "true|false EXIT_IP" as seen by check.torproject.org
    local json ip istor
    json=$(curl -s --max-time 15 --socks5-hostname "$TOR_SOCKS_HOST:$TOR_SOCKS_PORT" \
        https://check.torproject.org/api/ip 2>/dev/null) || return 1
    ip=$(printf '%s' "$json" | sed -n 's/.*"IP":"\([^"]*\)".*/\1/p')
    istor=$(printf '%s' "$json" | sed -n 's/.*"IsTor":\(true\|false\).*/\1/p')
    [ -n "$ip" ] || return 1
    printf '%s %s\n' "${istor:-false}" "$ip"
}

tor_exit_ip() { local out; out=$(tor_check) && printf '%s\n' "${out#* }"; }

tor_wait_ready() { # wait until Tor can carry traffic; tries ${1:-12} times
    local i
    for ((i = 0; i < ${1:-12}; i++)); do
        tor_exit_ip >/dev/null && return 0
        sleep 2
    done
    return 1
}

tor_where() {      # tor_where IP -> "City, Country" (looked up through Tor)
    local j c t
    j=$(curl -s --max-time 15 --socks5-hostname "$TOR_SOCKS_HOST:$TOR_SOCKS_PORT" \
        "https://ipwho.is/$1?fields=country,city" 2>/dev/null)
    c=$(printf '%s' "$j" | sed -n 's/.*"country":"\([^"]*\)".*/\1/p')
    t=$(printf '%s' "$j" | sed -n 's/.*"city":"\([^"]*\)".*/\1/p')
    [ -n "$c" ] && printf '%s%s\n' "${t:+$t, }" "$c"
    return 0
}

public_ip() {      # your address as the internet sees it, without Tor
    local ip
    ip=$(curl -s --max-time 6 https://api.ipify.org 2>/dev/null)
    [[ "$ip" =~ ^[0-9a-fA-F:.]+$ ]] && printf '%s\n' "$ip"
    return 0
}
