#!/bin/bash

# ============================================
# Complete System Anonymizer
# Author: Dhrub Raj Giri (DRG)
# GitHub: @Dhrub001
# ============================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; PURPLE='\033[0;35m'; NC='\033[0m'

INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
ORIGINAL_MAC=$(cat /sys/class/net/$INTERFACE/address 2>/dev/null)

clear
echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         COMPLETE SYSTEM ANONYMIZER                       ║"
echo "║         Author: Dhrub Raj Giri (DRG)                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 2

restore_all() {
    echo -e "\n${YELLOW}[!] Restoring original settings...${NC}"
    ip link set $INTERFACE down 2>/dev/null
    ip link set $INTERFACE address $ORIGINAL_MAC 2>/dev/null
    ip link set $INTERFACE up 2>/dev/null
    systemctl stop tor 2>/dev/null
    systemctl disable tor 2>/dev/null
    echo -e "${GREEN}[✓] Original MAC restored${NC}"
    echo -e "${RED}[✗] Anonymizer stopped${NC}"
    exit 0
}
trap restore_all SIGINT SIGTERM

echo -e "${CYAN}Change interval (seconds):${NC}"
echo "1) 30 seconds"
echo "2) 60 seconds (recommended)"
echo "3) 300 seconds"
read -p "Choice [1-3]: " INT_CHOICE

case $INT_CHOICE in
    1) INTERVAL=30 ;;
    2) INTERVAL=60 ;;
    3) INTERVAL=300 ;;
    *) INTERVAL=60 ;;
esac

systemctl unmask tor 2>/dev/null
systemctl start tor 2>/dev/null

echo -e "${GREEN}[✓] Anonymizer started - Changing every ${INTERVAL}s${NC}"
echo -e "${YELLOW}[!] Press Ctrl+C to stop and restore${NC}"

COUNTER=0
while true; do
    COUNTER=$((COUNTER + 1))
    echo ""
    echo -e "${PURPLE}[🌀] Cycle #${COUNTER}${NC}"
    
    NEW_MAC=$(printf "02:%02x:%02x:%02x:%02x:%02x" $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
    ip link set $INTERFACE down 2>/dev/null
    ip link set $INTERFACE address $NEW_MAC 2>/dev/null
    ip link set $INTERFACE up 2>/dev/null
    echo -e "${GREEN}[✓] MAC: $NEW_MAC${NC}"
    
    dhclient -r $INTERFACE 2>/dev/null
    dhclient $INTERFACE 2>/dev/null
    CURRENT_IP=$(ip -4 addr show $INTERFACE 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
    echo -e "${GREEN}[✓] IP: $CURRENT_IP${NC}"
    
    echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc -w 2 127.0.0.1 9051 2>/dev/null
    echo -e "${GREEN}[✓] Location changed${NC}"
    
    echo -e "${YELLOW}[⏰] Next change in ${INTERVAL}s${NC}"
    sleep $INTERVAL
done
