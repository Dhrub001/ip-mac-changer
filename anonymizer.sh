#!/usr/bin/env bash
# anonymizer.sh - shortcut for: ip-mac-pro --mode full
# Rotates the MAC, DHCP lease and Tor identity on a timer. Ctrl+C restores everything.
# Usage: sudo ./anonymizer.sh [seconds]      (default 60, minimum 10)
# Author: Dhrub Raj Giri (DRG)  https://github.com/Dhrub001

DIR=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
exec "$DIR/ip-mac-pro" --mode full --interval "${1:-60}"
