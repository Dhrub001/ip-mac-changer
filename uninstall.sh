#!/bin/bash

# ============================================
# IP & MAC Changer Uninstall Script
# Author: Dhrub Raj Giri
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}"
cat << "EOF"
    ╔═══════════════════════════════════════════╗
    ║     IP & MAC Changer - Uninstall          ║
    ║        Removing from system...             ║
    ╚═══════════════════════════════════════════╝
EOF
echo -e "${NC}"

read -p "Are you sure you want to uninstall? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}[✓] Uninstall cancelled${NC}"
    exit 0
fi

echo -e "${YELLOW}[→] Stopping service...${NC}"
sudo systemctl stop ip-mac-changer.service
sudo systemctl disable ip-mac-changer.service

echo -e "${YELLOW}[→] Removing service file...${NC}"
sudo rm -f /etc/systemd/system/ip-mac-changer.service
sudo systemctl daemon-reload

echo -e "${YELLOW}[→] Removing main script...${NC}"
sudo rm -f /usr/local/bin/ip-mac-changer

echo -e "${YELLOW}[→] Removing configuration...${NC}"
sudo rm -rf /etc/ip-mac-changer

echo -e "${YELLOW}[→] Removing log files...${NC}"
sudo rm -f /var/log/ip-mac-changer.log

echo -e "${YELLOW}[→] Restoring original MAC address...${NC}"
if [[ -f /etc/ip-mac-changer/original_mac ]]; then
    ORIGINAL_MAC=$(cat /etc/ip-mac-changer/original_mac 2>/dev/null)
    if [[ -n "$ORIGINAL_MAC" ]]; then
        INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
        sudo ip link set dev $INTERFACE down 2>/dev/null
        sudo ip link set dev $INTERFACE address $ORIGINAL_MAC 2>/dev/null
        sudo ip link set dev $INTERFACE up 2>/dev/null
        echo -e "${GREEN}[✓] Original MAC restored: $ORIGINAL_MAC${NC}"
    fi
fi

echo -e "${YELLOW}[→] Removing Tor configuration changes...${NC}"
sudo sed -i '/# IP & MAC Changer configuration/d' /etc/tor/torrc
sudo sed -i '/ControlPort 9051/d' /etc/tor/torrc
sudo sed -i '/CookieAuthentication 0/d' /etc/tor/torrc

echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo -e "${GREEN}[✓] IP & MAC Changer has been uninstalled${NC}"
echo -e "${GREEN}════════════════════════════════════════════${NC}"