#!/usr/bin/env bash
# Offline tests for ip-mac-changer.
# Fake versions of ip, ethtool, dhclient, tor, nc, curl and systemctl are put first on PATH,
# so nothing here touches your real network, MAC address or Tor.
# Run: bash tests/run-tests.sh

ROOT=$(cd "$(dirname "$0")/.." && pwd)
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
STUBS=$T/bin; FAKE=$T/fake; STATE=$T/state
mkdir -p "$STUBS"

export FAKE_DIR="$FAKE" IMC_STATE_DIR="$STATE" IMC_ALLOW_NONROOT=1 IMC_SETTLE=0 NO_COLOR=1
export PATH="$STUBS:$PATH"

# ---------------------------------------------------------------- fake commands
cat > "$STUBS/ip" <<'EOF'
#!/usr/bin/env bash
F=${FAKE_DIR:?}
echo "ip $*" >> "$F/calls"
case "$*" in
    "-o route show default") cat "$F/route" ;;
    "-o link show up")
        echo "1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 state UNKNOWN"
        echo "2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP" ;;
    "-o link show dev "*)
        echo "2: $5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000\\    link/ether $(cat "$F/mac") brd ff:ff:ff:ff:ff:ff" ;;
    "link show dev "*) case "$4" in eth0 | wlan0 | wg0) exit 0 ;; *) exit 1 ;; esac ;;
    "link set dev "*" address "*) [ -e "$F/refuse" ] && exit 2; echo "$6" > "$F/mac" ;;
    "link set dev "*) ;;
    "-4 -o addr show dev "*)
        [ -s "$F/ip4" ] && echo "2: $6    inet $(cat "$F/ip4")/24 brd 192.168.1.255 scope global dynamic $6\\       valid_lft 86400sec preferred_lft 86400sec" ;;
    "addr flush dev "*) : > "$F/ip4" ;;
esac
exit 0
EOF

cat > "$STUBS/ethtool" <<'EOF'
#!/usr/bin/env bash
[ -e "${FAKE_DIR:?}/no_perm" ] && exit 1
echo "Permanent address: $(cat "$FAKE_DIR/perm")"
EOF

cat > "$STUBS/dhclient" <<'EOF'
#!/usr/bin/env bash
F=${FAKE_DIR:?}
echo "dhclient $*" >> "$F/calls"
[ "$1" = "-r" ] && exit 0
[ -e "$F/dhcp_fail" ] && exit 2
echo "192.168.1.$((RANDOM % 150 + 60))" > "$F/ip4"
EOF

cat > "$STUBS/nc" <<'EOF'
#!/usr/bin/env bash
F=${FAKE_DIR:?}
case "$*" in *-z*) [ -e "$F/socks_up" ]; exit $? ;; esac
cat > /dev/null
cat "$F/nc_reply"
if grep -q '^250 OK' "$F/nc_reply"; then echo $(( $(cat "$F/tor_n" 2>/dev/null || echo 0) + 1 )) > "$F/tor_n"; fi
EOF

cat > "$STUBS/curl" <<'EOF'
#!/usr/bin/env bash
F=${FAKE_DIR:?}
url=${*: -1}
case "$url" in
    *check.torproject.org*) echo "{\"IsTor\":true,\"IP\":\"185.220.101.$(( $(cat "$F/tor_n" 2>/dev/null || echo 0) + 1 ))\"}" ;;
    *api.ipify.org*) echo "203.0.113.9" ;;
    *ipwho.is*) echo '{"country":"Germany","city":"Frankfurt"}' ;;
    *) exit 22 ;;
esac
EOF

cat > "$STUBS/systemctl" <<'EOF'
#!/usr/bin/env bash
F=${FAKE_DIR:?}
echo "systemctl $*" >> "$F/calls"
case "$*" in
    "is-active --quiet NetworkManager") exit 3 ;;
    "start tor") touch "$F/tor_running" "$F/socks_up" ;;
    "restart tor") touch "$F/tor_running" "$F/socks_up"; echo $(( $(cat "$F/tor_n" 2>/dev/null || echo 0) + 1 )) > "$F/tor_n" ;;
    "stop tor" | "stop tor@default") rm -f "$F/tor_running" "$F/socks_up" ;;
esac
exit 0
EOF

cat > "$STUBS/pgrep" <<'EOF'
#!/usr/bin/env bash
[ -e "${FAKE_DIR:?}/tor_running" ]
EOF

cat > "$STUBS/pkill" <<'EOF'
#!/usr/bin/env bash
echo "pkill $*" >> "${FAKE_DIR:?}/calls"
rm -f "$FAKE_DIR/tor_running" "$FAKE_DIR/socks_up"
EOF

printf '#!/bin/sh\nexit 0\n' > "$STUBS/tor"
chmod +x "$STUBS"/*

ORIG=aa:bb:cc:dd:ee:01
reset() {
    /usr/bin/pkill -f "$ROOT/ip-mac-pro" 2>/dev/null
    rm -rf "$FAKE" "$STATE"; mkdir -p "$FAKE"
    echo "$ORIG" > "$FAKE/mac"; echo "$ORIG" > "$FAKE/perm"
    echo "192.168.1.50" > "$FAKE/ip4"
    echo "default via 192.168.1.1 dev eth0 proto dhcp metric 100" > "$FAKE/route"
    printf '250 OK\r\n250 OK\r\n250 closing connection\r\n' > "$FAKE/nc_reply"
    : > "$FAKE/calls"
}
cur_mac() { cat "$FAKE/mac"; }
lib() { . "$ROOT/lib.sh"; }

# ---------------------------------------------------------------- test runner
PASS=0; FAIL=0
t() {
    local name=$1; shift
    reset
    if ( "$@" ) > "$T/out" 2>&1; then
        PASS=$((PASS + 1)); printf 'ok    %s\n' "$name"
    else
        FAIL=$((FAIL + 1)); printf 'FAIL  %s\n' "$name"; sed 's/^/        | /' "$T/out" | head -12
    fi
}
same() { [ "$1" = "$2" ] || { echo "expected '$2' but got '$1'"; return 1; }; }
has()  { grep -q -- "$1" "$T/out" || { echo "output does not contain: $1"; cat "$T/out"; return 1; }; }

# ---------------------------------------------------------------- library tests
t_detect_default()  { lib; same "$(detect_iface)" eth0; }
t_detect_wg()       { lib; echo "default dev wg0 scope link" > "$FAKE/route"; same "$(detect_iface)" wg0; }
t_detect_wlan()     { lib; echo "default via 10.0.0.1 dev wlan0 proto dhcp metric 600" > "$FAKE/route"; same "$(detect_iface)" wlan0; }
t_detect_fallback() { lib; : > "$FAKE/route"; same "$(detect_iface)" eth0; }
t_detect_explicit() { lib; same "$(detect_iface wlan0)" wlan0; }
t_detect_bad()      { lib; ! detect_iface nosuch && ! detect_iface 'eth0;reboot'; }

t_random_mac() {
    lib
    local i m
    for i in $(seq 1 300); do
        m=$(random_mac)
        valid_mac "$m" || { echo "invalid: $m"; return 1; }
        case ${m:1:1} in 2 | 6 | a | e) ;; *) echo "not locally administered: $m"; return 1 ;; esac
    done
}
t_valid_mac() {
    lib
    valid_mac aa:bb:cc:dd:ee:02 && valid_mac AA:BB:CC:DD:EE:02 &&
        ! valid_mac 01:00:5e:00:00:01 && ! valid_mac zz:bb:cc:dd:ee:02 && ! valid_mac aa:bb:cc:dd:ee &&
        ! valid_mac ""
}
t_valid_interval() { lib; valid_interval 10 && valid_interval 300 && ! valid_interval 9 && ! valid_interval abc && ! valid_interval ""; }
t_need_root() {
    unset IMC_ALLOW_NONROOT
    id() { echo 1000; }
    lib
    ( need_root ) && return 1
    return 0
}

t_set_mac_ok()   { lib; set_mac eth0 aa:bb:cc:dd:ee:77 && same "$(cur_mac)" aa:bb:cc:dd:ee:77; }
t_set_mac_fail() {
    lib; touch "$FAKE/refuse"
    ! set_mac eth0 aa:bb:cc:dd:ee:77 || return 1
    same "$(cur_mac)" "$ORIG" || return 1
    grep -q 'link set dev eth0 up' "$FAKE/calls"     # the link must be brought back up
}
t_state_uses_hardware_mac() {
    lib; echo aa:bb:cc:dd:ee:99 > "$FAKE/mac"      # already spoofed by something else
    save_original_mac eth0 && same "$(original_mac eth0)" "$ORIG"
}
t_state_not_overwritten() {
    lib; save_original_mac eth0; echo aa:bb:cc:dd:ee:99 > "$FAKE/perm"
    save_original_mac eth0; same "$(cat "$STATE/eth0.mac")" "$ORIG"
}
t_original_fallbacks() {
    lib; echo aa:bb:cc:dd:ee:99 > "$FAKE/mac"
    same "$(original_mac eth0)" "$ORIG" || return 1          # hardware MAC
    touch "$FAKE/no_perm"
    same "$(original_mac eth0)" aa:bb:cc:dd:ee:99            # current MAC, last resort
}
t_newnym_ok()   { lib; tor_newnym; }
t_newnym_fail() { lib; printf '515 Authentication failed\r\n' > "$FAKE/nc_reply"; ! tor_newnym; }
t_newnym_half() { lib; printf '250 OK\r\n510 Unrecognized signal\r\n250 closing connection\r\n' > "$FAKE/nc_reply"; ! tor_newnym; }
t_tor_check()   { lib; same "$(tor_check)" "true 185.220.101.1" && same "$(tor_exit_ip)" 185.220.101.1; }

# ---------------------------------------------------------------- script tests
t_help()        { "$ROOT/ip-mac-pro" --help > "$T/out" && has '--mode'; }
t_version()     { "$ROOT/ip-mac-pro" --version > "$T/out" && has 'ip-mac-changer 2'; }
t_bad_mode()    { ! "$ROOT/ip-mac-pro" --mode bogus; }
t_bad_interval(){ ! "$ROOT/ip-mac-pro" --mode once --interval 3; }
t_bad_iface()   { ! "$ROOT/ip-mac-pro" --mode once --iface nosuch; }
t_no_tty()      { ! "$ROOT/ip-mac-pro" < /dev/null; }
t_missing_val() { ! "$ROOT/ip-mac-pro" --mode; }
t_anon_interval(){ ! "$ROOT/anonymizer.sh" 5; }
t_status()      { "$ROOT/ip-mac-pro" --status > "$T/out" && has "MAC now.*$ORIG" && has "Public IP.*203.0.113.9"; }
t_monitor_once(){ "$ROOT/monitor.sh" --once > "$T/out" && has "MAC address.*$ORIG" && has 'Public IP'; }

t_once_and_stop() {
    "$ROOT/ip-mac-pro" --mode once > "$T/out" 2>&1 || { cat "$T/out"; return 1; }
    [ "$(cur_mac)" != "$ORIG" ] || { echo "MAC did not change"; return 1; }
    same "$(cat "$STATE/eth0.mac")" "$ORIG" || return 1
    has "MAC $ORIG ->" && has 'Tor exit 185.220.101.1 -> 185.220.101.2 (Frankfurt, Germany)' || return 1
    [ -e "$FAKE/tor_running" ] || { echo "Tor was not started"; return 1; }
    "$ROOT/stop.sh" > "$T/out" 2>&1 || { cat "$T/out"; return 1; }
    same "$(cur_mac)" "$ORIG" || return 1
    [ ! -e "$STATE/eth0.mac" ] && [ ! -e "$FAKE/tor_running" ]
}
t_stop_without_state() {
    echo aa:bb:cc:dd:ee:99 > "$FAKE/mac"
    "$ROOT/stop.sh" > "$T/out" 2>&1 || return 1
    same "$(cur_mac)" aa:bb:cc:dd:ee:99 || return 1      # must not touch a MAC it did not change
    has 'left your MAC alone' || return 1
    "$ROOT/stop.sh" --iface eth0 > "$T/out" 2>&1 || return 1
    same "$(cur_mac)" "$ORIG"
}
t_once_refused() {
    touch "$FAKE/refuse"
    "$ROOT/ip-mac-pro" --mode once > "$T/out" 2>&1 && return 1
    has 'refused' && same "$(cur_mac)" "$ORIG"
}
t_once_dhcp_fail() {
    touch "$FAKE/dhcp_fail"
    "$ROOT/ip-mac-pro" --mode once > "$T/out" 2>&1 && return 1
    has 'No DHCP answer'
}
t_control_port_fallback() {
    printf '515 Authentication failed\r\n' > "$FAKE/nc_reply"
    "$ROOT/ip-mac-pro" --mode once > "$T/out" 2>&1 || { cat "$T/out"; return 1; }
    has 'restarting Tor instead' && grep -q 'systemctl restart tor' "$FAKE/calls"
}
t_netid_only_no_tor() {
    "$ROOT/ip-mac-pro" --mode netid --interval 10 > "$T/out" 2>&1 &
    local pid=$! i
    for i in $(seq 1 40); do [ "$(cur_mac)" != "$ORIG" ] && break; sleep 0.2; done
    kill -TERM "$pid"; wait "$pid"
    ! grep -q 'systemctl start tor' "$FAKE/calls"
}

wait_changed() { local i; for i in $(seq 1 50); do [ "$(cur_mac)" != "$ORIG" ] && return 0; sleep 0.2; done; return 1; }

t_loop_sigterm_restores() {
    "$ROOT/ip-mac-pro" --mode full --interval 10 > "$T/loop.out" 2>&1 &
    local pid=$! i rc=0
    wait_changed || { echo "MAC never changed"; cat "$T/loop.out"; kill "$pid"; return 1; }
    [ -s "$STATE/pid" ] || { echo "no pid file"; return 1; }
    kill -TERM "$pid"
    for i in $(seq 1 30); do kill -0 "$pid" 2>/dev/null || break; sleep 0.2; done
    kill -0 "$pid" 2>/dev/null && { echo "did not exit within 6s of TERM"; kill -9 "$pid"; return 1; }
    wait "$pid" || rc=$?
    [ "$rc" = 0 ] || { echo "exit status $rc"; cat "$T/loop.out"; return 1; }
    same "$(cur_mac)" "$ORIG" || return 1
    [ ! -e "$STATE/eth0.mac" ] && [ ! -e "$STATE/pid" ] && [ ! -e "$FAKE/tor_running" ]
}
t_loop_second_instance_blocked() {
    command -v flock > /dev/null || { echo "(flock missing, skipped)"; return 0; }
    "$ROOT/ip-mac-pro" --mode netid --interval 10 > "$T/loop.out" 2>&1 &
    local pid=$!
    wait_changed || { kill "$pid"; return 1; }
    "$ROOT/ip-mac-pro" --mode netid --interval 10 > "$T/out" 2>&1 && { kill "$pid"; return 1; }
    kill -TERM "$pid"; wait "$pid"
    has 'already running'
}
t_stop_kills_running() {
    "$ROOT/ip-mac-pro" --mode full --interval 10 > "$T/loop.out" 2>&1 &
    local pid=$!
    wait_changed || { kill "$pid"; return 1; }
    "$ROOT/stop.sh" > "$T/out" 2>&1 || { cat "$T/out"; kill "$pid"; return 1; }
    kill -0 "$pid" 2>/dev/null && { echo "loop still running"; kill -9 "$pid"; return 1; }
    same "$(cur_mac)" "$ORIG" && [ ! -e "$FAKE/tor_running" ]
}

t_repo_hygiene() {
    cd "$ROOT" || return 1
    local f bad=0
    for f in ip-mac-pro anonymizer.sh stop.sh monitor.sh install.sh tests/run-tests.sh; do
        [ -x "$f" ] || { echo "not executable: $f"; bad=1; }
    done
    if grep -lU $'\r' ./* tests/* .gitattributes .gitignore 2> /dev/null | grep -v '^$'; then echo "CRLF line endings found"; bad=1; fi
    head -n 1 LICENSE | grep -q '^MIT License' || { echo "LICENSE does not start with 'MIT License'"; bad=1; }
    grep -q "^EOF$" LICENSE && { echo "LICENSE ends with a stray EOF"; bad=1; }
    return "$bad"
}
t_no_dangerous_pkill() {
    ! grep -nE 'pkill -f|killall' "$ROOT"/ip-mac-pro "$ROOT"/stop.sh "$ROOT"/monitor.sh "$ROOT"/anonymizer.sh "$ROOT"/lib.sh
}
t_syntax() {
    local f
    for f in lib.sh ip-mac-pro stop.sh monitor.sh install.sh anonymizer.sh; do bash -n "$ROOT/$f" || return 1; done
}
t_shellcheck() {
    command -v shellcheck > /dev/null || { echo "(shellcheck not installed, skipped)"; return 0; }
    cd "$ROOT" && shellcheck -x -s bash lib.sh ip-mac-pro stop.sh monitor.sh install.sh anonymizer.sh tests/run-tests.sh
}

echo "== library"
t "detect_iface: default route"                 t_detect_default
t "detect_iface: route without 'via' (VPN)"     t_detect_wg
t "detect_iface: dev is not the 5th field"      t_detect_wlan
t "detect_iface: no default route, falls back"  t_detect_fallback
t "detect_iface: explicit name"                 t_detect_explicit
t "detect_iface: rejects unknown and unsafe"    t_detect_bad
t "random_mac: 300 valid, locally administered" t_random_mac
t "valid_mac: accepts and rejects"              t_valid_mac
t "valid_interval: minimum of 10"               t_valid_interval
t "need_root: refuses a normal user"            t_need_root
t "set_mac: changes and verifies"               t_set_mac_ok
t "set_mac: driver refuses, link comes back up" t_set_mac_fail
t "original MAC: hardware MAC beats spoofed"    t_state_uses_hardware_mac
t "original MAC: saved copy is never replaced"  t_state_not_overwritten
t "original MAC: fallback order"                t_original_fallbacks
t "tor_newnym: accepted"                        t_newnym_ok
t "tor_newnym: authentication refused"          t_newnym_fail
t "tor_newnym: signal refused after auth"       t_newnym_half
t "tor_check: reads the exit address"           t_tor_check
echo "== scripts"
t "ip-mac-pro --help"                           t_help
t "ip-mac-pro --version"                        t_version
t "rejects an unknown mode"                     t_bad_mode
t "rejects an interval under 10 seconds"        t_bad_interval
t "rejects an unknown interface"                t_bad_iface
t "needs a mode when there is no terminal"      t_no_tty
t "option without a value is an error"          t_missing_val
t "anonymizer.sh passes on the interval check"  t_anon_interval
t "--status shows MAC and public IP"            t_status
t "monitor.sh --once"                           t_monitor_once
t "one shot changes everything, stop restores"  t_once_and_stop
t "stop leaves an unchanged MAC alone"          t_stop_without_state
t "driver refuses the MAC: error, MAC intact"   t_once_refused
t "DHCP failure is reported"                    t_once_dhcp_fail
t "control port refused: restarts Tor instead"  t_control_port_fallback
t "netid mode does not start Tor"               t_netid_only_no_tor
t "Ctrl+C / TERM restores MAC and stops Tor"    t_loop_sigterm_restores
t "a second copy is blocked"                    t_loop_second_instance_blocked
t "stop.sh ends a running loop and restores"    t_stop_kills_running
echo "== repository"
t "scripts executable, LF endings, clean LICENSE" t_repo_hygiene
t "no broad pkill -f / killall"                 t_no_dangerous_pkill
t "bash -n on every script"                     t_syntax
t "shellcheck"                                  t_shellcheck

echo
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
