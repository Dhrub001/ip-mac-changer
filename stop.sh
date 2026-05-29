#!/bin/bash

# ============================================
# Stop All Services - Restore Network
# Author: Dhrub Raj Giri (DRG)
# ============================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}[!] Stopping all services and restoring network...${NC}"

INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
ORIGINAL_MAC=$(cat /sys/class/net/$INTERFACE/address 2>/dev/null)

# Kill all processes
pkill -f tor 2>/dev/null
pkill -f ip-mac-pro 2>/dev/null
pkill -f anonymizer 2>/dev/null

# Restore MAC
if [ -n "$ORIGINAL_MAC" ] && [ -n "$INTERFACE" ]; then
    ip link set $INTERFACE down 2>/dev/null
    ip link set $INTERFACE address $ORIGINAL_MAC 2>/dev/null
    ip link set $INTERFACE up 2>/dev/null
    echo -e "${GREEN}[✓] MAC restored to: $ORIGINAL_MAC${NC}"
fi

# Restore network
dhclient -r $INTERFACE 2>/dev/null
dhclient $INTERFACE 2>/dev/null

# Stop Tor
systemctl stop tor 2>/dev/null
systemctl disable tor 2>/dev/null
systemctl mask tor 2>/dev/null

# Restart NetworkManager
systemctl restart NetworkManager 2>/dev/null

echo -e "${GREEN}[✓] Tor stopped and disabled${NC}"
echo -e "${GREEN}[✓] Network restored to normal${NC}"
echo -e "${RED}[✗] All services STOPPED${NC}"
