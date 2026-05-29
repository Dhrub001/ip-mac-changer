#!/bin/bash

# ============================================
# Monitor IP, MAC & Location Changes
# Author: Dhrub Raj Giri (DRG)
# ============================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; PURPLE='\033[0;35m'; BLUE='\033[0;34m'
BOLD='\033[1m'; NC='\033[0m'

INTERFACE="eth0"
LAST_MAC=""
LAST_IP=""
LAST_TOR_IP=""

clear
echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              NETWORK MONITOR - LIVE VIEW                  ║"
echo "║         Author: Dhrub Raj Giri (DRG)                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

get_mac() {
    cat /sys/class/net/$INTERFACE/address 2>/dev/null
}

get_local_ip() {
    ip -4 addr show $INTERFACE 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1
}

get_public_ip() {
    curl -s --max-time 3 ifconfig.me 2>/dev/null
}

get_tor_ip() {
    curl --socks5-hostname localhost:9050 -s --max-time 3 ifconfig.me 2>/dev/null
}

get_tor_location() {
    curl --socks5-hostname localhost:9050 -s --max-time 3 http://ip-api.com/line/?fields=country,city 2>/dev/null | head -2 | tr '\n' ' '
}

get_tor_status() {
    if systemctl is-active tor >/dev/null 2>&1; then
        echo -e "${GREEN}● RUNNING${NC}"
    else
        echo -e "${RED}○ STOPPED${NC}"
    fi
}

while true; do
    clear
    echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}              NETWORK MONITOR - $(date '+%H:%M:%S')${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # MAC Address
    CURRENT_MAC=$(get_mac)
    echo -e "${BLUE}┌─${NC} ${BOLD}[MAC ADDRESS]${NC}"
    if [ "$CURRENT_MAC" != "$LAST_MAC" ] && [ -n "$LAST_MAC" ]; then
        echo -e "│  ${RED}OLD: $LAST_MAC${NC}"
        echo -e "│  ${GREEN}NEW: $CURRENT_MAC ${YELLOW}← CHANGED!${NC}"
    else
        echo -e "│  ${GREEN}$CURRENT_MAC${NC}"
    fi
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────${NC}"
    echo ""
    
    # Local IP
    CURRENT_IP=$(get_local_ip)
    echo -e "${BLUE}┌─${NC} ${BOLD}[LOCAL IP]${NC}"
    if [ "$CURRENT_IP" != "$LAST_IP" ] && [ -n "$LAST_IP" ]; then
        echo -e "│  ${RED}OLD: $LAST_IP${NC}"
        echo -e "│  ${GREEN}NEW: $CURRENT_IP ${YELLOW}← CHANGED!${NC}"
    else
        echo -e "│  ${GREEN}$CURRENT_IP${NC}"
    fi
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────${NC}"
    echo ""
    
    # Public IP (Direct)
    PUBLIC_IP=$(get_public_ip)
    echo -e "${BLUE}┌─${NC} ${BOLD}[PUBLIC IP (Direct)]${NC}"
    echo -e "│  ${CYAN}$PUBLIC_IP${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────${NC}"
    echo ""
    
    # Tor Status & IP
    TOR_STATUS=$(get_tor_status)
    echo -e "${BLUE}┌─${NC} ${BOLD}[TOR NETWORK]${NC}"
    echo -e "│  Status: $TOR_STATUS"
    
    if systemctl is-active tor >/dev/null 2>&1; then
        TOR_IP=$(get_tor_ip)
        TOR_LOC=$(get_tor_location)
        if [ "$TOR_IP" != "$LAST_TOR_IP" ] && [ -n "$LAST_TOR_IP" ]; then
            echo -e "│  ${RED}OLD IP: $LAST_TOR_IP${NC}"
            echo -e "│  ${GREEN}NEW IP: $TOR_IP ${YELLOW}← CHANGED!${NC}"
        else
            echo -e "│  IP: ${GREEN}$TOR_IP${NC}"
        fi
        echo -e "│  Location: ${GREEN}$TOR_LOC${NC}"
    else
        echo -e "│  ${YELLOW}Tor not running. Start anonymizer to enable.${NC}"
    fi
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────${NC}"
    echo ""
    
    # Legend
    echo -e "${YELLOW}Legend:${NC}"
    echo -e "${GREEN}●${NC} Changed / Running    ${RED}○${NC} Stopped"
    echo -e ""
    echo -e "${YELLOW}Press Ctrl+C to exit monitor${NC}"
    
    LAST_MAC="$CURRENT_MAC"
    LAST_IP="$CURRENT_IP"
    LAST_TOR_IP="$TOR_IP"
    
    sleep 2
done
